import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:intl/intl.dart';
import 'package:printer4web/printer_settings.dart';
import 'package:printer4web/prusalink_api.dart';
import 'printer_chart.dart';
import 'package:printer4web/printer_4_web_icons.dart';

class PrinterInformation extends StatefulWidget {
  PrinterInformation({super.key, required this.printerInformationState});

  AppPrinterInformationState printerInformationState;
  final DateFormat dateFormat = DateFormat('kk:mm');

  @override
  State<PrinterInformation> createState() => _PrinterInformationState();
}

class AppPrinterInformationState {
  int? estimatedPrintTime;

  bool prusalinkStatus = false;
  String? printName;
  double? nozzleTempWanted;
  double? nozzleTempHave;
  double? heatbedTempWanted;
  double? heatbedTempHave;
  int? printFinishedAt;
  List<FlSpot> temperatureHistory = [];
}

class _PrinterInformationState extends State<PrinterInformation> {
  static const String defaultPrintName = "Kein laufender Druck";
  static const int defaultNozzleTempWanted = 0;
  static const int defaultNozzleTempHave = 0;
  static const int defaultHeatbedTempWanted = 0;
  static const int defaultHeatbedTempHave = 0;

  static const int heatbedPreheatTemp = 85;
  static const int nozzlePreheatTemp = 250;

  void onPreheatClicked() {
    // Wait for the result of both calls and then show a toast message.
    Future.wait([makePreheatHeatbedRequest(heatbedPreheatTemp), makePreheatNozzleRequest(nozzlePreheatTemp)]).then((success) {
      if (!success[0] || !success[1]) {
        print("Error preheating heatbed or nozzle");
        // Show failure message.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed preheating heatbed or nozzle"),
          duration: Duration(seconds: 5),
        ));
      }
    }, onError: (error) {
      print("Error preheating heatbed or nozzle: $error");
      // Show failure message.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed preheating heatbed or nozzle"),
      duration: Duration(seconds: 5),
      ));
    });
  }

  void onStatusSwitchChanged(bool value) {
    // TODO Implement.
  }

  void onCoolDownClicked() {
    // Wait for the result of both calls and then show a toast message.
    Future.wait([makePreheatHeatbedRequest(0), makePreheatNozzleRequest(0)]).then((success) {
      if (!success[0] || !success[1]) {
        print("Error cooling down heatbed or nozzle");
        // Show failure message.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed cooling down heatbed or nozzle"),
          duration: Duration(seconds: 5),
        ));
      }
    }, onError: (error) {
      print("Error cooling down heatbed or nozzle: $error");
      // Show failure message.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed cooling down heatbed or nozzle"),
        duration: Duration(seconds: 5),
      ));
    });  }

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
            // Makes sure the Column is taking the full width.
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(widget.printerInformationState.printName ?? defaultPrintName),
                    const SizedBox(height: 8),
                    if (widget.printerInformationState.printFinishedAt != null)
                      Text("Fertig um ${widget.dateFormat.format(DateTime.now().add(Duration(milliseconds: widget.printerInformationState.printFinishedAt ?? 0)))}"),
                    const SizedBox(height: 8),
                  ],
                ),
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
                    const Icon(Printer4Web.nozzle),
                    Text(
                        "${widget.printerInformationState.nozzleTempHave?.round() ?? defaultNozzleTempHave}/${widget.printerInformationState.nozzleTempWanted?.round() ?? defaultNozzleTempWanted}°C")
                  ],
                ),
                Row(
                  children: [
                    const Icon(Printer4Web.heatplate),
                    Text(
                        "${widget.printerInformationState.heatbedTempHave?.round() ?? defaultHeatbedTempHave}/${widget.printerInformationState.heatbedTempWanted?.round() ?? defaultHeatbedTempWanted}°C")
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: onPreheatClicked, child: const Text("Preheat")),
                ElevatedButton(onPressed: onCoolDownClicked, child: const Text("Cool Down")),
              ],
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: PrinterChart(history: widget.printerInformationState.temperatureHistory),
            ),
            const Spacer(),
            ElevatedButton(onPressed: () => _launchPrusalinkSite(context), child: const Text("PrusaLink")),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPrusalinkSite(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await launch(
        prusalinkAddress,
        customTabsOption: CustomTabsOption(
          toolbarColor: theme.primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: theme.primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}

// Custom ImageProvider that enables access to files requiring digest authentication. It essentially downloads the image using a digest authentication client and then converts it in a form that is displayable in the app.
