import 'package:fl_chart/fl_chart.dart';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:printer4web/edit_profiles_dialog.dart';
import 'package:printer4web/printer_http_api.dart';

import 'app_config.dart';
import 'printer_chart.dart';

enum PrinterConnectionStatus {
  checking,
  connected,
  disconnected,
}

class HousingInformation extends StatefulWidget {
  HousingInformation({super.key, required this.housingState});

  final AppHousingState housingState;
  final tempPattern = RegExp("^\\d+([\\.\\,]\\d+?)?\$");

  // Regex pattern for any non empty string with at least one character and at most 20 characters. The string must contain at least one non-whitespace character.
  final namePattern = RegExp("^\\S(.*\\S)?\$");

  @override
  State<HousingInformation> createState() => _HousingInformationState();
}

class PrintProfile {
  final String name;
  final int temperature;

  const PrintProfile(this.name, this.temperature);

  @override
  bool operator ==(Object other) {
    final bool output = identical(this, other) ||
        other is PrintProfile &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            temperature == other.temperature;
    return output;
  }

  @override
  int get hashCode => name.hashCode ^ temperature.hashCode;
}

class AppHousingState {
  PrinterConnectionStatus connectionStatus = PrinterConnectionStatus.checking;
  double innerTempTop = 0;
  double innerTempBottom = 0;
  double outerTemp = 0;
  bool isTempControlActive = false;

  double tempOverall = 0;

  double tempOverallHave = 0;
  double tempOverallWant = 0;
  double fanSpeed = 0.0;

  List<FlSpot> history = [];

  List<PrintProfile> printProfiles = List.empty(growable: true);

  PrintProfile? selectedProfile;
}

class ConnectionStatusIndicator extends StatelessWidget {
  const ConnectionStatusIndicator({
    super.key,
    required this.status,
  });

  final PrinterConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final ({
      Color backgroundColor,
      Color borderColor,
      Color foregroundColor,
      String label,
    }) statusStyle = switch (status) {
      PrinterConnectionStatus.connected => (
          backgroundColor:
              isDark ? const Color(0xFF1B4D2B) : const Color(0xFFE0F2E5),
          borderColor:
              isDark ? const Color(0xFF6DD58C) : const Color(0xFF2E7D32),
          foregroundColor:
              isDark ? const Color(0xFFB8F5C8) : const Color(0xFF1B5E20),
          label: "Verbunden",
        ),
      PrinterConnectionStatus.disconnected => (
          backgroundColor:
              isDark ? const Color(0xFF5A2020) : const Color(0xFFFDE7E7),
          borderColor:
              isDark ? const Color(0xFFFF8A80) : const Color(0xFFC62828),
          foregroundColor:
              isDark ? const Color(0xFFFFCDD2) : const Color(0xFFB71C1C),
          label: "Nicht verbunden",
        ),
      PrinterConnectionStatus.checking => (
          backgroundColor:
              isDark ? const Color(0xFF594512) : const Color(0xFFFFF4D6),
          borderColor:
              isDark ? const Color(0xFFFFD54F) : const Color(0xFFB26A00),
          foregroundColor:
              isDark ? const Color(0xFFFFE7A3) : const Color(0xFF8A4B00),
          label: "Verbindung wird geprüft",
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusStyle.backgroundColor,
        border: Border.all(color: statusStyle.borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: statusStyle.foregroundColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            statusStyle.label,
            style: TextStyle(
              color: statusStyle.foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HousingInformationState extends State<HousingInformation> {
  final tempInputController = TextEditingController();
  final nameInputController = TextEditingController();

  void onTempControlChanged(bool value) {
    PrinterHttpApi.changeTempControl(
            value,
            widget.housingState.selectedProfile?.name,
            widget.housingState.selectedProfile?.temperature)
        .then(
      (printerStatus) {
        if (!mounted) {
          return;
        }
        setState(() {
          widget.housingState.isTempControlActive =
              printerStatus.isTempControlActive;
        });
      },
      onError: (error) {
        developer.log(
          'Failed to send temp control change: $error',
          name: 'printer4web.housing',
          error: error,
        );
      },
    );
  }

  @override
  void dispose() {
    tempInputController.dispose();
    nameInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: queryData.size.aspectRatio > wideLayoutThreshold
          ? horizontalLayout(context)
          : verticalLayout(context),
    );
  }

  Widget verticalLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        statisticsLayout(context),
        const SizedBox(height: 16),
        chartLayout(context),
      ],
    );
  }

  Widget horizontalLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: statisticsLayout(context),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: chartLayout(context),
        ),
      ],
    );
  }

  Widget statisticsLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Status"),
            ConnectionStatusIndicator(
              status: widget.housingState.connectionStatus,
            ),
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
          children: [
            const Text("Temperaturregelung"),
            Switch(
                value: widget.housingState.isTempControlActive,
                onChanged: onTempControlChanged)
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
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditProfilesDialog(
                          housingState: widget.housingState);
                    });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      widget.housingState.selectedProfile?.name ??
                          "Kein Profil ausgewählt",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 8),
                  const Icon(
                    size: 21,
                    Icons.edit,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.heat_pump),
                Text(
                    "${(widget.housingState.fanSpeed * 100).round().clamp(0, 100)}%"),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.square_outlined),
                Text(
                    "${widget.housingState.tempOverallHave.round()}/${widget.housingState.tempOverallWant.round()}°C"),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget chartLayout(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: AspectRatio(
            aspectRatio: 16 / 9,
            child: PrinterChart(history: widget.housingState.history)));
  }
}
