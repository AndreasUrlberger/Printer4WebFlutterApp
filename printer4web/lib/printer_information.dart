import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:intl/intl.dart';

import 'prusalink_api.dart';

class PrinterInformation extends StatefulWidget {
  const PrinterInformation({super.key});

  @override
  State<PrinterInformation> createState() => _PrinterInformationState();
}

void onStatusSwitchChanged(bool value) {
  // TODO Implement.
}

void onPreheatClicked() {
  // TODO Implement.
}

void onCoolDownClicked() {
  // TODO Implement.
}

class _PrinterInformationState extends State<PrinterInformation> {
  bool status = true;
  String filename = "Dateiname";
  double nozzleTempWanted = 240.0;
  double nozzleTempHave = 237.2;
  double heatbedTempWanted = 90.0;
  double heatbedTempHave = 81.3;
  late Timer timer;

  final DateFormat dateFormat = DateFormat('kk:mm');
  DateTime printCompleteAt =
      DateTime.now().add(const Duration(hours: 1, minutes: 28));

  @override
  void initState() {
    super.initState();

    prusaDataRequest(null);

    timer = Timer.periodic(
      const Duration(seconds: 3),
      prusaDataRequest,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void prusaDataRequest(Timer? _) {
    print("Called timer iteration");
    makeRequest().then(
      (prusalinkData) {
        if (prusalinkData != null) {
          print("Prusalink data successfully fetched.");
          setState(() {
            nozzleTempWanted = prusalinkData.temperature.nozzle.targetTemp;
            nozzleTempHave = prusalinkData.temperature.nozzle.actualTemp;
            heatbedTempWanted = prusalinkData.temperature.heatbed.targetTemp;
            heatbedTempHave = prusalinkData.temperature.heatbed.actualTemp;
          });
        } else {
          print("Prusalink data could not get fetched.");
        }
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
              children: [
                const Text("Status"),
                Switch(value: status, onChanged: onStatusSwitchChanged)
              ],
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
                    Text(filename),
                    Text("Fertig um ${dateFormat.format(printCompleteAt)}")
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
                    Text(
                        "${nozzleTempHave.round()}/${nozzleTempWanted.round()}°C"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.hot_tub),
                    Text(
                        "${heatbedTempHave.round()}/${heatbedTempWanted.round()}°C"),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                ElevatedButton(
                    onPressed: onPreheatClicked, child: Text("Preheat")),
                ElevatedButton(
                    onPressed: onPreheatClicked, child: Text("Cool Down")),
              ],
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: chartToRun(),
            )
          ],
        ),
      ),
    );
  }
}

Widget chartToRun() {
  LabelLayoutStrategy? xContainerLabelLayoutStrategy;
  ChartData chartData;
  ChartOptions chartOptions = const ChartOptions(
    legendOptions: LegendOptions(isLegendContainerShown: false),
  );
  // Example shows a demo-type data generated randomly in a range.
  chartData = RandomChartData.generated(
      chartOptions: chartOptions, numDataRows: 1, numXLabels: 4);
  var lineChartContainer = LineChartTopContainer(
    chartData: chartData,
    xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
  );

  var lineChart = LineChart(
    painter: LineChartPainter(
      lineChartContainer: lineChartContainer,
    ),
  );
  return lineChart;
}
