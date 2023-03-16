import 'dart:async';

import 'package:flutter/material.dart';
import 'package:printer4web/printer_chart.dart';
import 'package:printer4web/printer_communication.dart';

class HousingInformation extends StatefulWidget {
  HousingInformation({super.key});

  PrinterConnection? connection;


  @override
  State<HousingInformation> createState() => _HousingInformationState();
}

class _HousingInformationState extends State<HousingInformation> {
  bool status = true;
  bool isTempControlActive = true;
  int profileValue = 0;

  double tempOutside = 21.3;
  double tempTop = 32.4;
  double tempBottom = 24.3;

  double tempOverallHave = 27.7;
  double tempOverallWant = 20;
  double fanSpeed = 0.8;

  static const int timerPeriod = 3;
  Timer ?timer;


  List<DropdownMenuItem<int>>

  profiles = [
    const DropdownMenuItem(value: 0, child: Text("PETG"),),
    const DropdownMenuItem (value: 1, child: Text("ABS"),),
  ];


  @override
  void initState() {
    super.initState();

    PrinterConnection.create("192.168.178.143", 1933).then((connection) => widget.connection = connection);

    Timer.periodic(Duration(seconds: timerPeriod.round()), sendStatusRequest
    );
  }

  void sendStatusRequest(Timer _){
    print("clicked preheat");
    widget.connection?.sendStatusRequest();
    print("connection is ${widget.connection}");
  }

  void onStatusSwitchChanged(bool value) {
    setState(() {
      status = value;
    });
  }

  void onTempControlChanged(bool value) {
    setState(() {
      isTempControlActive = value;
    });
  }

  void onProfileChanged(int? value) {
    setState(() {
      profileValue = value ?? 0;
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
              children: [
                const Text("Status"),
                Switch(value: status, onChanged: onStatusSwitchChanged)
              ],
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
                      Text("${tempOutside.round()}°C"),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.maximize),
                      Text("${tempTop.round()}°C"),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.minimize),
                      Text("${tempBottom.round()}°C"),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Temperaturregelung"),
                Switch(
                    value: isTempControlActive, onChanged: onTempControlChanged)
              ],
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
                  value: profileValue,
                  items: profiles,
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
                    Text("${(fanSpeed * 100).round().clamp(0, 100)}%"),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.square_outlined),
                    Text("${tempOverallHave.round()}/${tempOverallWant.round()}°C"),
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
}

Widget chartToRun() {
  //List<double> list = [19.4, 20.3, 13.0, 3.9];
  return LineChartSample10();
}
