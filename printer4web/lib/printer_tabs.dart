import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
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

class _PrinterTabsState extends State<PrinterTabs> with WidgetsBindingObserver, TickerProviderStateMixin {
  AppLifecycleState state = AppLifecycleState.resumed;
  late final List<String> _tabNames;
  late Timer _timer;
  late TabController _controller;
  late String _appbarTitle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabNames = ["Printer4Web", "Druckerinfo", "Gehäuseinfo"];
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      setState(() {
        _appbarTitle = _tabNames[_controller.index];
      });
    });
    _appbarTitle = _tabNames[0];

    runTimedTasks(null);
    _timer = Timer.periodic(
      Duration(seconds: PrinterTabs.timerPeriod.round()),
      runTimedTasks,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: (kIsWeb || size.aspectRatio <= 1)
          ? AppBar(
              title: Text(_appbarTitle.toString()),
            )
          : null,
      bottomNavigationBar: TabBar(
        controller: _controller,
        tabs: const <Tab>[
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
      body: TabBarView(
        controller: _controller,
        children: [
          HomePage(homePageState: widget.appState.homePageState, pressDebugButton: prusaDataRequest),
          PrinterInformation(printerInformationState: widget.appState.printerInformationState),
          HousingInformation(housingState: widget.appState.housingState),
        ],
      ),
    );
  }

  void runTimedTasks(Timer? t) {
    if (state != AppLifecycleState.resumed) {
      return;
    }

    prusaDataRequest(t);
    sendPrinterStatusRequest(t);
  }

  void sendPrinterStatusRequest(Timer? _) {
    PrinterHttpApi.getStatus().then((value) {
      processStatusMessage(value);
    }, onError: (error) {
      print("status request error: $error");
      setState(() {
        widget.appState.housingState.connectionStatus = false;
      });
    });
  }

  void prusaDataRequest(Timer? _) {
    makePrinterRequest().then(
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
          widget.appState.printerInformationState.prusalinkStatus = false;
          print("Prusalink printer data could not get fetched.");
        }
        // Just use the same data again.
        setState(() {
          while (widget.appState.printerInformationState.temperatureHistory.length > PrinterTabs.numHistoryElements) {
            widget.appState.printerInformationState.temperatureHistory.removeAt(0);
          }

          if (widget.appState.printerInformationState.nozzleTempHave != null) {
            widget.appState.printerInformationState.temperatureHistory
                .add(FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), widget.appState.printerInformationState.nozzleTempHave!));
          }
        });
      },
    );

    makeJobRequest().then(
      (prusalinkData) {
        if (prusalinkData != null) {
          setState(() {
            widget.appState.printerInformationState
              ..estimatedPrintTime = prusalinkData.job.estimatedPrintTime
              ..prusalinkStatus = true
              ..printName = prusalinkData.job.file.name;
          });
        } else {
          print("Prusalink job data could not get fetched.");
          widget.appState.printerInformationState
            ..estimatedPrintTime = null
            ..prusalinkStatus = false
            ..printName = null;
        }
      },
    );
  }

  void processStatusMessage(PrinterStatus printerStatus) {
    while (widget.appState.housingState.history.length > PrinterTabs.numHistoryElements) {
      widget.appState.housingState.history.removeAt(0);
    }

    setState(() {
      widget.appState.housingState
        ..innerTempBottom = printerStatus.temperatureInsideBottom / 1000
        ..innerTempTop = printerStatus.temperatureInsideTop / 1000
        ..outerTemp = printerStatus.temperatureOutside / 1000
        ..tempOverallHave = printerStatus.temperatureInsideBottom / 1000
        ..tempOverallWant = printerStatus.currentPrintConfig.temperature / 1000
        ..isTempControlActive = printerStatus.isTempControlActive
        ..connectionStatus = true
        ..fanSpeed = printerStatus.fanSpeed;

      widget.appState.housingState.printProfiles.clear();
      for (var config in printerStatus.printConfigs) {
        widget.appState.housingState.printProfiles.add(PrintProfile(config.name, config.temperature));
      }

      if (printerStatus.currentPrintConfig.name.isEmpty) {
        widget.appState.housingState.selectedProfile = null;
      } else {
        widget.appState.housingState.selectedProfile = PrintProfile(printerStatus.currentPrintConfig.name, printerStatus.currentPrintConfig.temperature);
      }

      widget.appState.housingState.history.add(FlSpot(
        DateTime.now().millisecondsSinceEpoch.toDouble(),
        widget.appState.housingState.outerTemp,
      ));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    this.state = state;
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}
