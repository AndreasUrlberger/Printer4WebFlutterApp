import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:webviewx/webviewx.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("Name_der_Druckdatei"), Text("80%")],
              ),
              const SizedBox(
                height: 16,
              ),
              const LinearProgressIndicator(
                value: 0.6,
                semanticsLabel: 'Linear progress indicator',
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("fertig um 17:48"), Text("-1:43h")],
              ),
              const SizedBox(
                height: 16,
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: kIsWeb
                        ? const MjpgWebView()
                        : const Mjpeg(
                            stream:
                                'http://192.168.178.143:8080/?action=stream',
                            isLive: true,
                            error: onMjpgError,
                            timeout: Duration(seconds: 10),
                          )

                    /*Container(
                    color: Colors.black,
                  ),*/
                    ),
              )
            ]),
      ),
    );
  }
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

class _MjgWebViewState extends State<MjpgWebView> {
  late WebViewXController webviewController;

  bool imageLoadError = false;

  String streamHtml = '''
    <html>
    <body style="margin: 0; padding: 0">
    <img id="image" src="http://192.168.178.143:8080/?action=stream" height="100%" width="100%" >
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
    webviewController.evalRawJavascript(
        'document.documentElement.style.overflow = "hidden";');
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
      dartCallBacks: {
        DartCallback(name: "onImageLoadError", callBack: onImageLoadError)
      },
      width: 999999,
      height: 999999,
    );
  }
}
