import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printer4web/printer_http_api.dart';

import 'expanded_section.dart';
import 'housing_information.dart';

// Statefull Dialog widget
class EditProfilesDialog extends StatefulWidget {
  EditProfilesDialog({Key? key, required this.housingState}) : super(key: key);

  final tempPattern = RegExp("^\\d+([\\.\\,]\\d+?)?\$");
  final namePattern = RegExp("^\\S(.*\\S)?\$");
  final tempInputController = TextEditingController();
  final nameInputController = TextEditingController();

  AppHousingState housingState;

  @override
  EditProfilesDialogState createState() => EditProfilesDialogState();
}

class EditProfilesDialogState extends State<EditProfilesDialog> {
  bool isExpanded = false;
  int? selectedIndex;

  // The list in the dialog shows the name and temperature of each profile provided in the profiles parameter.
  bool tempInputValid = false;
  bool nameInputValid = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.housingState.printProfiles.indexWhere((profile) => profile == widget.housingState.selectedProfile);

    tempInputValid = widget.tempPattern.hasMatch(widget.tempInputController.text);
    nameInputValid = widget.namePattern.hasMatch(widget.nameInputController.text);
  }

  bool onAddPrintConfig() {
    if (widget.namePattern.hasMatch(widget.nameInputController.text) && widget.tempPattern.hasMatch(widget.tempInputController.text)) {
      PrinterHttpApi.addPrintConfig(widget.nameInputController.text, (double.parse(widget.tempInputController.text.replaceAll(",", ".")) * 1000).round()).then(
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
      widget.nameInputController.clear();
      widget.tempInputController.clear();
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
  Widget build(BuildContext context) {
    // The list in the dialog shows the name and temperature of each profile provided in the profiles parameter.
    bool tempInputValid = widget.tempPattern.hasMatch(widget.tempInputController.text);
    bool nameInputValid = widget.namePattern.hasMatch(widget.nameInputController.text);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(isExpanded ? "Druckerprofil hinzufügen" : "Druckerprofil auswählen", style: const TextStyle(fontSize: 20)),
                const Spacer(),
                IconButton(
                  icon: Icon(isExpanded ? Icons.remove : Icons.add),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),
            buildProfileList(context),
            buildExpandableSection(context),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
              },
              children: [
                TableRow(children: [
                  TextButton(
                    child: const Text("Abbrechen"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                      // disable button if text is not a valid temperature
                      onPressed: ((tempInputValid && nameInputValid) || !isExpanded)
                          ? () {
                              if (isExpanded) {
                                // Add new profile
                                if (onAddPrintConfig()) {
                                  Navigator.pop(context);
                                }
                              } else {
                                // Select profile
                                if (selectedIndex != null) {
                                  onProfileChanged(widget.housingState.printProfiles[selectedIndex!]);
                                }
                                Navigator.pop(context);
                              }
                            }
                          : null,
                      child: Text(isExpanded ? "Hinzufügen" : "Bestätigen")),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpandableSection(BuildContext context) {
    return ExpandedSection(
      expand: isExpanded,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    maxLength: 15,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: widget.nameInputController,
                    onChanged: (text) {
                      final bool isValid = widget.namePattern.hasMatch(text);
                      if (nameInputValid != isValid) {
                        setState(() {
                          nameInputValid = isValid;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: nameInputValid ? Colors.green : Colors.red),
                      ),
                      // Disable the counter text as it is affecting the widget height.
                      counterText: "",
                      border: OutlineInputBorder(borderSide: BorderSide(color: nameInputValid ? Colors.green : Colors.red)),
                      hintText: "Name",
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    controller: widget.tempInputController,
                    onChanged: (text) {
                      final bool isValid = widget.tempPattern.hasMatch(text);
                      if (tempInputValid != isValid) {
                        setState(() {
                          tempInputValid = isValid;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: tempInputValid ? Colors.green : Colors.red),
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide(color: tempInputValid ? Colors.green : Colors.red)),
                      hintText: "Temperatur",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileList(BuildContext context) {
    // Get screen height and width
    final Size size = MediaQuery.of(context).size;
    return LimitedBox(
      maxHeight: size.height * 0.3,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.housingState.printProfiles.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    print("tapped");
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: (index == selectedIndex) ? Colors.black : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(widget.housingState.printProfiles[index].name)),
                      Text((widget.housingState.printProfiles[index].temperature / 1000).toString()),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onRemoveProfile(widget.housingState.printProfiles[index]);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
