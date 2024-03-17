import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printer4web/printer_settings.dart';
import 'package:webviewx/webviewx.dart';

import 'app_config.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {super.key, required this.homePageState, required this.pressDebugButton});

  AppHomePageState homePageState;
  Function pressDebugButton;

  final DateFormat dateFormat = DateFormat('kk:mm');
  final String html = """
<html>
  <head>
    <style>
      /* Hide broken image icon */
      img {
        font-size: 0;
      }
      img:before {
        content: "";
        display: block;
      }
      /* Loading animation */
      .loader {
        border: 0.8vh solid #f3f3f3;
        border-top: 0.8vh solid #3498db;
        border-radius: 50%;
        width: 16vh;
        height: 16vh;
        animation: spin 2s linear infinite;
        position: absolute;
        top: calc(50% - 8vh);
        left: calc(50% - 8vh);
      }

      @media (max-width: 600px) {
        .loader {
          border: 2.5vh solid #f3f3f3;
          border-top: 2.5vh solid #3498db;
          border-radius: 50%;
          width: 20vh;
          height: 20vh;
          animation: spin 2s linear infinite;
          position: absolute;
          top: calc(50% - 10vh);
          left: calc(50% - 10vh);
        }
      }
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
    </style>
  </head>
  <body style="margin: 0; padding: 0; background-color: black">
    <div class="loader"></div>
    <img
      id="image"
      src=$mjpgStreamAddress
      height="100%"
      width="100%"
      onError="reloadImage()"
      onLoad="showImage()"
    />
    <script>
      function adjustStyle() {
        if (window.navigator.userAgent.indexOf("Trident") > -1) {
          document.body.style.msOverflowStyle = "none";
        }
        if (window.navigator.userAgent.indexOf("Chrome") > -1 || window.navigator.userAgent.indexOf("Safari") > -1) {
          document.documentElement.style.WebkitScrollbar = "display: none;";
        }
        document.documentElement.style.overflow = "hidden";
      }

      function reloadImage() {
        console.log("reloadImage");
        var image = document.getElementById('image');
        image.style.display = 'none';
        setTimeout(function () {
          image.src = "$mjpgStreamAddress?" + new Date().getTime();
        }, $mjpgImageReloadIntervalMS);
      }

      function showImage() {
        console.log("showImage");
        var image = document.getElementById('image');
        var loader = document.querySelector('.loader');
        image.style.display = 'block';
        loader.style.display = 'none';
      }

      window.onload = adjustStyle;
    </script>
  </body>
</html>
""";

  @override
  State<HomePage> createState() => _HomePageState();
}

class AppHomePageState {
  String? printName;
  double? printProgress;
  int? printTimeLeft;
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: size.aspectRatio > wideLayoutThreshold
          ? horizontalLayout(context)
          : verticalLayout(context),
    );
  }

  Widget verticalLayout(BuildContext context) {
    return Column(
      children: [
        progressUI(context),
        const SizedBox(
          height: 16,
        ),
        streamerUI(context)
      ],
    );
  }

  Widget horizontalLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: streamerUI(context)),
        const SizedBox(
          width: 32,
        ),
        Expanded(flex: 1, child: progressUI(context)),
      ],
    );
  }

  Widget progressUI(BuildContext context) {
    const String defaultPrintName = "Kein laufender Druck";

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.homePageState.printName ?? defaultPrintName),
              Text("${(widget.homePageState.printProgress ?? 0) * 100}%")
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          LinearProgressIndicator(
            value: (widget.homePageState.printProgress ?? 0),
            semanticsLabel: 'Print progress indicator',
          ),
          const SizedBox(
            height: 16,
          ),
          if (widget.homePageState.printTimeLeft != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "fertig um ${widget.dateFormat.format(DateTime.now().add(Duration(seconds: widget.homePageState.printTimeLeft!)))}"),
                Text(
                    "-${formatDeltaTime(widget.homePageState.printTimeLeft!)}"),
              ],
            ),
        ]);
  }

  Widget streamerUI(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              Container(
                color: Colors.black,
                alignment: Alignment.center,
              ),
              mjpgView(),
            ],
          )),
    );
  }

  Widget mjpgView() {
    return WebViewX(
      width: 99999,
      height: 99999,
      initialContent: widget.html,
      initialSourceType: SourceType.html,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

String formatDeltaTime(int seconds) {
  Duration duration = Duration(seconds: seconds);
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);

  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedHours = hours.toString();

  return '$formattedHours:${formattedMinutes}h';
}
