import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:printer4web/printer_communication.dart';
import 'package:printer4web/proto/printer_data.pb.dart';
import 'homepage.dart';
import 'printer_information.dart';
import 'housing_information.dart';
import 'prusalink.dart';
import 'settings.dart';

import 'prusalink_api.dart';

class PrinterTabs extends StatefulWidget {
  PrinterTabs({super.key});

  final PrinterAppState appState = PrinterAppState();

  static const num timerPeriod = 1;
  static const num historySeconds = 120;
  static const num numHistoryElements = historySeconds / timerPeriod;

  PrinterConnection? connection;

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
      length: 5,
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
                icon: Icon(Icons.science_outlined),
              ),
              Tab(
                icon: Icon(Icons.crop_square_rounded),
              ),
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.settings_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomePage(homePageState: widget.appState.homePageState),
            PrinterInformation(printerInformationState: widget.appState.printerInformationState),
            HousingInformation(housingState: widget.appState.housingState),
            Prusalink(),
            Settings(),
          ],
        ),
      ),
    ); //const MyHomePage(title: 'Printer4Web'),;
  }

  @override
  void initState() {
    super.initState();

    prusaDataRequest(null);

    timer = Timer.periodic(
      Duration(seconds: PrinterTabs.timerPeriod.round()),
      runTimedTasks,
    );

    PrinterConnection.create("192.168.178.143", 1933, processStatusMessage).then((connection) => widget.connection = connection, onError: (error) {
      print("Failed creating connection with error: $error");
    });
  }

  void runTimedTasks(Timer t) {
    prusaDataRequest(t);
    sendStatusRequest(t);
  }

  void sendStatusRequest(Timer _) {
    widget.connection?.sendStatusRequest();
    if (widget.connection == null) {
      print("connection is ${widget.connection}");
    }
  }

  void prusaDataRequest(Timer? _) {
    makeRequest().then(
      (prusalinkData) {
        if (prusalinkData != null) {
          setState(() {
            widget.appState.printerInformationState.prusalinkStatus = true;
            widget.appState.printerInformationState.nozzleTempWanted = prusalinkData.temperature.nozzle.targetTemp;
            widget.appState.printerInformationState.nozzleTempHave = prusalinkData.temperature.nozzle.actualTemp;
            widget.appState.printerInformationState.heatbedTempWanted = prusalinkData.temperature.heatbed.targetTemp;
            widget.appState.printerInformationState.heatbedTempHave = prusalinkData.temperature.heatbed.actualTemp;
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
      widget.appState.housingState.innerTempBottom = printerStatus.temperatureInsideBottom;
      widget.appState.housingState.innerTempTop = printerStatus.temperatureInsideTop;
      widget.appState.housingState.outerTemp = printerStatus.temperatureOutside;
      widget.appState.housingState.isTempControlActive = printerStatus.isTempControlActive;

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
