import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:printer4web/printer_http_api.dart';

import 'printer_chart.dart';

class HousingInformation extends StatefulWidget {
  HousingInformation({super.key, required this.housingState});

  AppHousingState housingState;
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
  bool operator ==(Object other) => identical(this, other) || other is PrintProfile && runtimeType == other.runtimeType && name == other.name && temperature == other.temperature;

  @override
  int get hashCode => name.hashCode ^ temperature.hashCode;
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

  List<PrintProfile> printProfiles = List.empty(growable: true);

  PrintProfile? selectedProfile;
}

class _HousingInformationState extends State<HousingInformation> {
  bool status = true;
  final tempInputController = TextEditingController();
  final nameInputController = TextEditingController();

  void onStatusSwitchChanged(bool value) {
    setState(() {
      status = value;
      PrinterHttpApi.shutdown();
    });
  }

  void onTempControlChanged(bool value) {
    PrinterHttpApi.changeTempControl(value, widget.housingState.selectedProfile?.name, widget.housingState.selectedProfile?.temperature).then(
      (printerStatus) {
        setState(() {
          widget.housingState.isTempControlActive = printerStatus.isTempControlActive;
        });
      },
      onError: (error) {
        print("Failed to send temp control change to printer with error: $error");
      },
    );
  }

  bool onAddPrintConfig() {
    if (widget.namePattern.hasMatch(nameInputController.text) && widget.tempPattern.hasMatch(tempInputController.text)) {
      PrinterHttpApi.addPrintConfig(nameInputController.text, (double.parse(tempInputController.text.replaceAll(",", ".")) * 100).round()).then(
        (printerStatus) {
          setState(() {
            widget.housingState.printProfiles = printerStatus.printConfigs.map((config) => PrintProfile(config.name, config.temperature)).toList(growable: true);
            widget.housingState.selectedProfile = PrintProfile(printerStatus.currentPrintConfig.name, printerStatus.currentPrintConfig.temperature);
          });
        },
        onError: (error) {
          print("Failed to send add print config request to printer with error: $error");
        },
      );
      nameInputController.clear();
      tempInputController.clear();
      return true;
    } else {
      return false;
    }
  }

  void onProfileChanged(PrintProfile? value) {
    if (value == null) {
      return;
    }

    PrinterHttpApi.changeTempControl(widget.housingState.isTempControlActive, value.name, value.temperature).then((response) {
      setState(() {
        widget.housingState.isTempControlActive = response.isTempControlActive;
        widget.housingState.selectedProfile = PrintProfile(response.currentPrintConfig.name, response.currentPrintConfig.temperature);
      });
    });
  }

  void onRemoveProfile(PrintProfile profile) {
    PrinterHttpApi.removePrintConfig(profile.name, profile.temperature).then((response) {
      setState(() {
        widget.housingState.printProfiles = response.printConfigs.map((config) => PrintProfile(config.name, config.temperature)).toList(growable: true);
        widget.housingState.selectedProfile = PrintProfile(response.currentPrintConfig.name, response.currentPrintConfig.temperature);
      });
    });
  }

  @override
  void dispose() {
    tempInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<PrintProfile>> profiles;
    profiles = widget.housingState.printProfiles
        .map((printConfig) => DropdownMenuItem(
              value: printConfig,
              child: GestureDetector(
                onLongPress: () {
                  print("Long press detected on profile: $printConfig");
                  onRemoveProfile(printConfig);
                },
                child: Text(printConfig.name),
              ),
            ))
        .toList(growable: true);

    profiles.add(
      DropdownMenuItem<PrintProfile>(
        value: null,
        child: GestureDetector(
          onTap: () {
            dynamicPrintConfigDialog();
          },
          child: const Text("Hinzufügen"),
        ),
      ),
    );

    // Print name and temp of each profile
    print("WebProfiles: ${widget.housingState.printProfiles.map((profile) => "${profile.name} ${profile.temperature}").join(", ")}");
    print("Profiles: ${profiles.map((profile) => "${profile.value?.name} ${profile.value?.temperature}").join(", ")}");
    print("Selected profile: ${widget.housingState.selectedProfile?.name} ${widget.housingState.selectedProfile?.temperature}");

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
                  alignment: Alignment.centerRight,
                  value: widget.housingState.selectedProfile,
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
              child: PrinterChart(history: widget.housingState.history),
            ),
          ],
        ),
      ),
    );
  }

// Returns a dialog for entering a name and a temperature of a new print profile. The dialog has a header with the title "Neues Profil erstellen", a text field for the name and a text field for the temperature. The temperature text field has a green border if the entered text is a valid temperature and a red border if the entered text is not a valid temperature. The dialog has two buttons, one for canceling the dialog and one for creating the new profile. The dialog is closed when the cancel button is pressed or when the create button is pressed and the entered text is a valid temperature.
  void dynamicPrintConfigDialog() {
    bool tempInputValid = widget.tempPattern.hasMatch(tempInputController.text);
    bool nameInputValid = widget.namePattern.hasMatch(nameInputController.text);

    showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Neues Profil erstellen',
                    textScaleFactor: 1.4,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLength: 15,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: nameInputController,
                    onChanged: (text) {
                      final bool isValid = widget.namePattern.hasMatch(text);
                      if (nameInputValid != isValid) {
                        setState(() {
                          nameInputValid = isValid;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: nameInputValid ? Colors.green : Colors.red),
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide(color: nameInputValid ? Colors.green : Colors.red)),
                      hintText: "Name",
                    ),
                  ),
                  TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    controller: tempInputController,
                    onChanged: (text) {
                      final bool isValid = widget.tempPattern.hasMatch(text);
                      if (tempInputValid != isValid) {
                        setState(() {
                          tempInputValid = isValid;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: tempInputValid ? Colors.green : Colors.red),
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide(color: tempInputValid ? Colors.green : Colors.red)),
                      hintText: "Temperatur",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Abbrechen")),
                    ElevatedButton(
                        // disable button if text is not a valid temperature
                        onPressed: (tempInputValid && nameInputValid)
                            ? () {
                                if (onAddPrintConfig()) {
                                  Navigator.pop(context);
                                }
                              }
                            : null,
                        child: const Text("Bestätigen")),
                  ]),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
