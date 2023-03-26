import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:intl/intl.dart';
import 'package:printer4web/printer_settings.dart';
import 'package:webviewx/webviewx.dart';

import 'app_config.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.homePageState, required this.pressDebugButton});

  AppHomePageState homePageState;
  Function pressDebugButton;

  final DateFormat dateFormat = DateFormat('kk:mm');

  @override
  State<HomePage> createState() => _HomePageState();
}

class AppHomePageState {
  String? printName;
  int? printProgress;
  int? printTimeLeft;
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: size.aspectRatio > wideLayoutThreshold ? horizontalLayout(context) : verticalLayout(context),
    );
  }

  Widget verticalLayout(BuildContext context) {
    return Column(
      children: [
        progressUI(context),
        const SizedBox(
          height: 16,
        ),
        chartUI(context)
      ],
    );
  }

  Widget horizontalLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: chartUI(context)),
        const SizedBox(
          width: 32,
        ),
        Expanded(flex: 1, child: progressUI(context)),
      ],
    );
  }

  Widget progressUI(BuildContext context) {
    const String defaultPrintName = "Kein laufender Druck";

    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(widget.homePageState.printName ?? defaultPrintName), Text("${widget.homePageState.printProgress ?? 0}%")],
      ),
      const SizedBox(
        height: 16,
      ),
      LinearProgressIndicator(
        value: (widget.homePageState.printProgress?.toDouble() ?? 0) / 100.0,
        semanticsLabel: 'Print progress indicator',
      ),
      const SizedBox(
        height: 16,
      ),
      if (widget.homePageState.printTimeLeft != null)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("fertig um ${widget.dateFormat.format(DateTime.now().add(Duration(milliseconds: widget.homePageState.printTimeLeft!)))}"),
            Text("-${formatDeltaTime(widget.homePageState.printTimeLeft!)}"),
          ],
        ),
    ]);
  }

  Widget chartUI(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: kIsWeb
            ? const MjpgWebView()
            : const Mjpeg(
          stream: mjpgStreamAddress,
          isLive: true,
          error: onMjpgError,
          timeout: Duration(seconds: 10),
        ),
      ),
    );
  }
}

String formatDeltaTime(int milliseconds) {
  Duration duration = Duration(milliseconds: milliseconds);
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);

  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedHours = hours.toString();

  return '$formattedHours:${formattedMinutes}h';
}

Widget onMjpgError(BuildContext context, dynamic error, dynamic stack) {
  return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Center(
          child: Text(
            "$error",
            style: const TextStyle(color: Colors.white),
          )));
}

class MjpgWebView extends StatefulWidget {
  const MjpgWebView({super.key});

  @override
  State<MjpgWebView> createState() => _MjgWebViewState();
}

class _MjgWebViewState extends State<MjpgWebView> with AutomaticKeepAliveClientMixin<MjpgWebView> {
  late WebViewXController webviewController;

  bool imageLoadError = false;

  String streamHtml = '''
    <html>
    <body style="margin: 0; padding: 0">
    <img id="image" src=$mjpgStreamAddress height="100%" width="100%" >
    </body>
    </html>
    ''';

  @override
  void initState() {
    super.initState();
  }

  void onWebViewCreated(WebViewXController<dynamic> controller) {
    webviewController = controller;

    // Disable scrollbars for Internet Explorer and Edge
    webviewController.evalRawJavascript('''
    if (window.navigator.userAgent.indexOf("Trident") > -1) {
      document.body.style.msOverflowStyle = "none";
    }''');

    // Hide the scrollbar for Google Chrome and Safari
    webviewController.evalRawJavascript('''
    if (window.navigator.userAgent.indexOf("Chrome") > -1 || window.navigator.userAgent.indexOf("Safari") > -1) {
      document.documentElement.style.WebkitScrollbar = "display: none;";
    }
    ''');

    // Firefox?
    // document.body.style.scrollbarWidth = "none";
    webviewController.evalRawJavascript('document.documentElement.style.overflow = "hidden";');
  }

  void onWebError(WebResourceError error) {
    print("onWebResourceError");
  }

  void onImageLoadError(dynamic value) {
    print("onImageLoadError");
    setState(() {
      imageLoadError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebViewX(
      initialContent: streamHtml,
      initialSourceType: SourceType.html,
      onWebViewCreated: (controller) => onWebViewCreated(controller),
      onWebResourceError: (error) => onWebError(error),
      jsContent: const {
        EmbeddedJsContent(js: """
                      const img = document.getElementById("image")
                      img.addEventListener("error", function(event) {
                          //event.onerror = null
                          onImageLoadError(null)
                      })""")
      },
      dartCallBacks: {DartCallback(name: "onImageLoadError", callBack: onImageLoadError)},
      onPageFinished: (src) {
        print("onPageFinished: $src");
      },
      width: 999999,
      height: 999999,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
