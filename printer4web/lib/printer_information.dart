import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printer4web/custom_printer_chart.dart';

import 'prusalink_api.dart';

class PrinterInformation extends StatefulWidget {
  const PrinterInformation({super.key});

  @override
  State<PrinterInformation> createState() => _PrinterInformationState();
}

class _PrinterInformationState extends State<PrinterInformation> {
  static const num timerPeriod = 1;
  static const num historySeconds = 20;
  static const num numHistoryElements = historySeconds / timerPeriod;

  bool status = true;
  String filename = "Dateiname";
  double nozzleTempWanted = 240.0;
  double nozzleTempHave = 237.2;
  double heatbedTempWanted = 90.0;
  double heatbedTempHave = 81.3;
  List<double> temperatureHistory = [];

  late Timer timer;
  final DateFormat dateFormat = DateFormat('kk:mm');
  DateTime printCompleteAt = DateTime.now().add(const Duration(hours: 1, minutes: 28));

  void onPreheatClicked() {
    // TODO Implement.
  }

  void onStatusSwitchChanged(bool value) {
    // TODO Implement.
  }

  void onCoolDownClicked() {
    // TODO Implement.
  }


  @override
  void initState() {
    super.initState();

    prusaDataRequest(null);

    timer = Timer.periodic(
      Duration(seconds: timerPeriod.round()),
      prusaDataRequest,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void prusaDataRequest(Timer? _) {
    makeRequest().then(
      (prusalinkData) {
        if (prusalinkData != null) {
          setState(() {
            nozzleTempWanted = prusalinkData.temperature.nozzle.targetTemp;
            nozzleTempHave = prusalinkData.temperature.nozzle.actualTemp;
            heatbedTempWanted = prusalinkData.temperature.heatbed.targetTemp;
            heatbedTempHave = prusalinkData.temperature.heatbed.actualTemp;
          });
        } else {
          print("Prusalink data could not get fetched.");
        }
        // Just use the same data again.
        setState(() {
          temperatureHistory.add(nozzleTempHave);
          if (temperatureHistory.length > numHistoryElements) {
            temperatureHistory.removeAt(0);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [const Text("Status"), Switch(value: status, onChanged: onStatusSwitchChanged)],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    height: 100,
                    child: AspectRatio(
                      aspectRatio: 16.0 / 9.0,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(filename), Text("Fertig um ${dateFormat.format(printCompleteAt)}")],
                )
              ],
            ),
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text("Temperatur", textAlign: TextAlign.start),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [const Icon(Icons.pin_drop), Text("${nozzleTempHave.round()}/${nozzleTempWanted.round()}°C")],
                ),
                Row(
                  children: [const Icon(Icons.hot_tub), Text("${heatbedTempHave.round()}/${heatbedTempWanted.round()}°C")],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: onPreheatClicked, child: const Text("Preheat")),
                ElevatedButton(onPressed: onPreheatClicked, child: const Text("Cool Down")),
              ],
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: chartToRun(temperatureHistory),
            )
          ],
        ),
      ),
    );
  }
}

Widget chartToRun(List<double> history) {
  return PrinterChart(history);
}
