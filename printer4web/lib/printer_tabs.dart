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
  AppPrinterInformationState printerInformationState =
      AppPrinterInformationState();
  AppHousingState housingState = AppHousingState();
}

class _PrinterTabsState extends State<PrinterTabs>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  AppLifecycleState state = AppLifecycleState.resumed;
  late final List<String> _tabNames;
  late Timer _timer;
  late TabController _controller;
  late String _appbarTitle;
  int _selectedTabIndex = 0;
  bool _isPrinterDataRequestInFlight = false;
  bool _isStatusRequestInFlight = false;
  int _consecutiveStatusRequestFailures = 0;
  static const int _statusFailuresBeforeDisconnect = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabNames = ["Printer4Web", "Druckerinfo", "Gehäuseinfo"];
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedTabIndex = _controller.index;
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          _controller.animateTo(index);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Start',
          ),
          BottomNavigationBarItem(
            icon: Icon(Printer4Web.printer_3d),
            label: 'Drucker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Printer4Web.housing),
            label: 'Gehäuse',
          ),
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          HomePage(
              homePageState: widget.appState.homePageState,
              pressDebugButton: prusaDataRequest),
          PrinterInformation(
              printerInformationState: widget.appState.printerInformationState),
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
    if (_isStatusRequestInFlight) {
      return;
    }
    _isStatusRequestInFlight = true;

    PrinterHttpApi.getStatus().then((value) {
      _consecutiveStatusRequestFailures = 0;
      processStatusMessage(value);
    }, onError: (error) {
      print("status request error: $error");
      _consecutiveStatusRequestFailures++;
      if (_consecutiveStatusRequestFailures >=
              _statusFailuresBeforeDisconnect &&
          mounted) {
        setState(() {
          widget.appState.housingState.connectionStatus = false;
        });
      }
    }).whenComplete(() {
      _isStatusRequestInFlight = false;
    });
  }

  void prusaDataRequest(Timer? _) {
    if (_isPrinterDataRequestInFlight) {
      return;
    }
    _isPrinterDataRequestInFlight = true;

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
          while (widget
                  .appState.printerInformationState.temperatureHistory.length >
              PrinterTabs.numHistoryElements) {
            widget.appState.printerInformationState.temperatureHistory
                .removeAt(0);
          }

          if (prusalinkData != null &&
              widget.appState.printerInformationState.nozzleTempHave != null) {
            final List<FlSpot> history =
                widget.appState.printerInformationState.temperatureHistory;
            final double timestamp =
                DateTime.now().millisecondsSinceEpoch.toDouble();
            final double nextTimestamp =
                history.isEmpty || timestamp > history.last.x
                    ? timestamp
                    : history.last.x + 1;
            widget.appState.printerInformationState.temperatureHistory.add(
                FlSpot(nextTimestamp,
                    widget.appState.printerInformationState.nozzleTempHave!));
          }
        });
      },
    ).whenComplete(() {
      _isPrinterDataRequestInFlight = false;
    });

    makeJobRequest().then(
      (prusalinkData) {
        if (prusalinkData != null) {
          setState(() {
            if (prusalinkData.state == "Printing" &&
                prusalinkData.job != null &&
                prusalinkData.progress != null) {
              final String? printName = prusalinkData.job!.file.name;
              int endIndex =
                  (printName?.lastIndexOf(RegExp(r"\.bgcode")) ?? 1) - 1;
              if (endIndex < 0) {
                endIndex = printName!.length;
              }
              final String? printNameShort = printName?.substring(0, endIndex);

              widget.appState.printerInformationState
                ..estimatedPrintTime = prusalinkData.job!.estimatedPrintTime
                ..prusalinkStatus = true
                ..printName = printNameShort;
              widget.appState.homePageState
                ..printProgress = prusalinkData.progress!.completion
                ..printName = printNameShort
                ..printTimeLeft = prusalinkData.progress!.printTimeLeft;
            } else {
              widget.appState.printerInformationState
                ..estimatedPrintTime = null
                ..prusalinkStatus = false
                ..printName = null;
              widget.appState.homePageState
                ..printProgress = 0
                ..printName = null
                ..printTimeLeft = null;
            }
          });
        } else {
          print("Prusalink job data could not get fetched.");
          widget.appState.printerInformationState
            ..estimatedPrintTime = null
            ..prusalinkStatus = false
            ..printName = null;
          widget.appState.homePageState.printProgress = null;
        }
      },
    );
  }

  void processStatusMessage(PrinterStatus printerStatus) {
    while (widget.appState.housingState.history.length >
        PrinterTabs.numHistoryElements) {
      widget.appState.housingState.history.removeAt(0);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      widget.appState.housingState
        ..tempOverallWant = printerStatus.currentPrintConfig.temperature / 1000
        ..isTempControlActive = printerStatus.isTempControlActive
        ..connectionStatus = true
        ..fanSpeed = printerStatus.fanSpeed;

      if (printerStatus.temperatureOutside != 0) {
        // Only update the outer temperature if the new one is not 0.
        widget.appState.housingState.outerTemp =
            printerStatus.temperatureOutside / 1000;
      }

      if (printerStatus.temperatureInsideTop != 0) {
        widget.appState.housingState.innerTempTop =
            printerStatus.temperatureInsideTop / 1000;
      }

      if (printerStatus.temperatureInsideBottom != 0) {
        widget.appState.housingState.innerTempBottom =
            printerStatus.temperatureInsideBottom / 1000;
        widget.appState.housingState.tempOverallHave =
            printerStatus.temperatureInsideBottom / 1000;
      }

      widget.appState.housingState.printProfiles.clear();
      for (var config in printerStatus.printConfigs) {
        widget.appState.housingState.printProfiles
            .add(PrintProfile(config.name, config.temperature));
      }

      if (printerStatus.currentPrintConfig.name.isEmpty) {
        widget.appState.housingState.selectedProfile = null;
      } else {
        widget.appState.housingState.selectedProfile = PrintProfile(
            printerStatus.currentPrintConfig.name,
            printerStatus.currentPrintConfig.temperature);
      }

      final List<FlSpot> history = widget.appState.housingState.history;
      final double timestamp = DateTime.now().millisecondsSinceEpoch.toDouble();
      final double nextTimestamp = history.isEmpty || timestamp > history.last.x
          ? timestamp
          : history.last.x + 1;
      history
          .add(FlSpot(nextTimestamp, widget.appState.housingState.outerTemp));
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
