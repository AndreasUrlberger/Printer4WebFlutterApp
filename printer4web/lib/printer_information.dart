import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printer4web/custom_printer_chart.dart';

class PrinterInformation extends StatefulWidget {
  PrinterInformation({super.key, required this.printerInformationState});

  AppPrinterInformationState printerInformationState;
  final DateFormat dateFormat = DateFormat('kk:mm');

  @override
  State<PrinterInformation> createState() => _PrinterInformationState();
}

class AppPrinterInformationState {
  static const String defaultPrintName = "Kein laufender Druck";
  static const double defaultNozzleTempWanted = 0.0;
  static const double defaultNozzleTempHave = 0.0;
  static const double defaultHeatbedTempWanted = 0.0;
  static const double defaultHeatbedTempHave = 0.0;
  static const int defaultPrintFinishedAt = 0;

  bool prusalinkStatus = false;
  String printName = defaultPrintName;
  double nozzleTempWanted = defaultNozzleTempWanted;
  double nozzleTempHave = defaultNozzleTempHave;
  double heatbedTempWanted = defaultHeatbedTempWanted;
  double heatbedTempHave = defaultHeatbedTempHave;
  int printFinishedAt = defaultPrintFinishedAt;
  List<FlSpot> temperatureHistory = [];
}

class _PrinterInformationState extends State<PrinterInformation> {
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
              children: [const Text("Status"), Switch(value: widget.printerInformationState.prusalinkStatus, onChanged: onStatusSwitchChanged)],
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
                  children: [
                    Text(widget.printerInformationState.printName),
                    Text("Fertig um ${widget.dateFormat.format(DateTime.now().add(Duration(milliseconds: widget.printerInformationState.printFinishedAt)))}"),
                  ],
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
                  children: [
                    const Icon(Icons.pin_drop),
                    Text("${widget.printerInformationState.nozzleTempHave.round()}/${widget.printerInformationState.nozzleTempWanted.round()}°C")
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.hot_tub),
                    Text("${widget.printerInformationState.heatbedTempHave.round()}/${widget.printerInformationState.heatbedTempWanted.round()}°C")
                  ],
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
              child: LineChartExample(history: widget.printerInformationState.temperatureHistory),
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
