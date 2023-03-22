import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'printer_chart.dart';

class HousingInformation extends StatefulWidget {
  HousingInformation({super.key, required this.housingState});

  AppHousingState housingState;

  @override
  State<HousingInformation> createState() => _HousingInformationState();
}

class AppHousingState {
  double innerTempTop = 0;
  double innerTempBottom = 0;
  double outerTemp = 0;
  bool isTempControlActive = false;

  double tempOverall = 0;

  double tempOverallHave = 0;
  double tempOverallWant = 0;
  double fanSpeed = 0.8;

  List<FlSpot> history = [];

  List<DropdownMenuItem<int>> profiles = [
    const DropdownMenuItem(
      value: 0,
      child: Text("PETG"),
    ),
    const DropdownMenuItem(
      value: 1,
      child: Text("ABS"),
    ),
  ];

  int selectedProfile = 0;
}

class _HousingInformationState extends State<HousingInformation> {
  bool status = true;

  void onStatusSwitchChanged(bool value) {
    // TODO Send message to printer to turn off.
    setState(() {
      status = value;
    });
  }

  void onTempControlChanged(bool value) {
    // TODO Send message to printer to change temp control.
  }

  void onProfileChanged(int? value) {
    setState(() {
      widget.housingState.selectedProfile = value ?? 0;
    });
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
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text("Temperatur", textAlign: TextAlign.start),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.crop_square_rounded),
                      Text("${widget.housingState.outerTemp.round()}°C"),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.maximize),
                      Text("${widget.housingState.innerTempTop.round()}°C"),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.minimize),
                      Text("${widget.housingState.innerTempBottom.round()}°C"),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [const Text("Temperaturregelung"), Switch(value: widget.housingState.isTempControlActive, onChanged: onTempControlChanged)],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Profil:"),
                DropdownButton(
                  value: widget.housingState.selectedProfile,
                  items: widget.housingState.profiles,
                  onChanged: onProfileChanged,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.heat_pump),
                    Text("${(widget.housingState.fanSpeed * 100).round().clamp(0, 100)}%"),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.square_outlined),
                    Text("${widget.housingState.tempOverallHave.round()}/${widget.housingState.tempOverallWant.round()}°C"),
                  ],
                )
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

  Widget chartToRun() {
    return PrinterChart(history: widget.housingState.history);
  }
}
