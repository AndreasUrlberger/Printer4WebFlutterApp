import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:webviewx/webviewx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
      ),
      home: const PrinterTabs(
        title: "PrinterTabs",
      ),
    );
  }
}

class PrinterTabs extends StatefulWidget {
  const PrinterTabs({super.key, required this.title});
  final String title;

  @override
  State<PrinterTabs> createState() => _PrinterTabsState();
}

class _PrinterTabsState extends State<PrinterTabs> {
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(title: const Text("App Title")),
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.primary,
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home_outlined),
              ),
              Tab(
                icon: Icon(Icons.science_outlined),
              ),
              Tab(
                icon: Icon(Icons.crop_square_rounded),
              ),
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.settings_outlined),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomePage(title: "Home"),
            PrinterInformation(title: "Printer information"),
            Icon(Icons.directions_bike),
            Icon(Icons.directions_bike),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    ); //const MyHomePage(title: 'Printer4Web'),;
  }
}

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
      child: Text(
        "$error",
        style: const TextStyle(color: Colors.white),
      ));
}

class PrinterInformation extends StatefulWidget {
  const PrinterInformation({super.key, required this.title});

  final String title;

  @override
  State<PrinterInformation> createState() => _PrinterInformationState();
}

class _PrinterInformationState extends State<PrinterInformation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Printer Information",
        ),
      ),
    );
  }
}

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late WebViewXController webviewController;

  bool imageLoadError = false;

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter WebView'),
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(0.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.0),
                      child: Container(
                          color: Colors.green,
                          child: Stack(
                            children: [
                              WebViewX(
                                initialContent: streamHtml,
                                initialSourceType: SourceType.html,
                                onWebViewCreated: (controller) =>
                                    onWebViewCreated(controller),
                                onWebResourceError: (error) =>
                                    onWebError(error),
                                jsContent: {
                                  EmbeddedJsContent(mobileJs: """
                      const img = document.getElementById("image")
                      img.addEventListener("error", function(event) {
                          //event.onerror = null
                          onImageLoadError(null)
                      })""", webJs: """
                      const img = document.getElementById("image")
                      img.addEventListener("error", function(event) {
                          //event.onerror = null
                          onImageLoadError(null)
                      })""")
                                },
                                dartCallBacks: {
                                  DartCallback(
                                      name: "onImageLoadError",
                                      callBack: onImageLoadError)
                                },
                                width: 999999,
                                height: 999999,
                              ),
                              if (imageLoadError)
                                Container(
                                  color: Colors.black,
                                  width: 1000000,
                                  height: 1000000,
                                  child: const WebViewAware(
                                    child: Text("Image Load Error",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                )
                            ],
                          ))),
                )),
          ],
        ));
  }
}

class MjpgWebView extends StatefulWidget {
  const MjpgWebView({super.key});

  @override
  State<MjpgWebView> createState() => _MjgWebViewState();
}

class _MjgWebViewState extends State<MjpgWebView> {
  late WebViewXController webviewController;

  bool imageLoadError = false;

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

String streamHtml = '''
<html>
<body style="margin: 0; padding: 0">
<img id="image" src="http://192.168.178.143:8080/?action=stream" height="100%" width="100%" >
</body>
</html>
''';
