import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:printer4web/printer_4_web_icons.dart';
import 'package:printer4web/printer_http_api.dart';
import 'package:printer4web/proto/printer_data.pb.dart';
import 'homepage.dart';
import 'printer_information.dart';
import 'housing_information.dart';

import 'prusalink_api.dart';

class PrinterTabs extends StatefulWidget {
  PrinterTabs({super.key});

  final PrinterAppState appState = PrinterAppState();

  static const num timerPeriod = 1;
  static const num historySeconds = 120;
  static const num numHistoryElements = historySeconds / timerPeriod;

  @override
  State<PrinterTabs> createState() => _PrinterTabsState();
}

class PrinterAppState {
  AppHomePageState homePageState = AppHomePageState();
  AppPrinterInformationState printerInformationState = AppPrinterInformationState();
  AppHousingState housingState = AppHousingState();
}

class _PrinterTabsState extends State<PrinterTabs> {
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text("App Title")),
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.primary,
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home_outlined),
              ),
              Tab(
                icon: Icon(Printer4Web.printer_3d),
              ),
              Tab(
                icon: Icon(Printer4Web.housing),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomePage(homePageState: widget.appState.homePageState, pressDebugButton: prusaDataRequest),
            PrinterInformation(printerInformationState: widget.appState.printerInformationState),
            HousingInformation(housingState: widget.appState.housingState),
          ],
        ),
      ),
    ); //const MyHomePage(title: 'Printer4Web'),;
  }

  @override
  void initState() {
    super.initState();

    runTimedTasks(null);

    timer = Timer.periodic(
      Duration(seconds: PrinterTabs.timerPeriod.round()),
      runTimedTasks,
    );
  }

  void runTimedTasks(Timer? t) {
    prusaDataRequest(t);
    sendStatusRequest(t);
  }

  void sendStatusRequest(Timer? _) {
    PrinterHttpApi.getStatus().then((value) {
      processStatusMessage(value);
    }, onError: (error) {
      print("status request error: $error");
    });
  }

  void prusaDataRequest(Timer? _) {
    makeRequest().then(
      (prusalinkData) {
        if (prusalinkData != null) {
          setState(() {
            widget.appState.printerInformationState
              ..prusalinkStatus = true
              ..nozzleTempWanted = prusalinkData.temperature.nozzle.targetTemp
              ..nozzleTempHave = prusalinkData.temperature.nozzle.actualTemp
              ..heatbedTempWanted = prusalinkData.temperature.heatbed.targetTemp
              ..heatbedTempHave = prusalinkData.temperature.heatbed.actualTemp;
          });
        } else {
          print("Prusalink data could not get fetched.");
        }
        // Just use the same data again.
        setState(() {
          while (widget.appState.printerInformationState.temperatureHistory.length > PrinterTabs.numHistoryElements) {
            widget.appState.printerInformationState.temperatureHistory.removeAt(0);
          }

          widget.appState.printerInformationState.temperatureHistory
              .add(FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), widget.appState.printerInformationState.nozzleTempHave));
        });
      },
    );
  }

  void processStatusMessage(PrinterStatus printerStatus) {
    while (widget.appState.housingState.history.length > PrinterTabs.numHistoryElements) {
      widget.appState.housingState.history.removeAt(0);
    }

    setState(() {
      widget.appState.housingState
        ..innerTempBottom = printerStatus.temperatureInsideBottom
        ..innerTempTop = printerStatus.temperatureInsideTop
        ..outerTemp = printerStatus.temperatureOutside
        ..isTempControlActive = printerStatus.isTempControlActive;

      widget.appState.housingState.printProfiles.clear();
      for (var config in printerStatus.printConfigs) {
        widget.appState.housingState.printProfiles.add(PrintProfile(config.name, config.temperature));
      }
      widget.appState.housingState.selectedProfile = PrintProfile(printerStatus.currentPrintConfig.name, printerStatus.currentPrintConfig.temperature);

      widget.appState.housingState.history.add(FlSpot(
        DateTime.now().millisecondsSinceEpoch.toDouble(),
        widget.appState.housingState.outerTemp,
      ));
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
