import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class Prusalink extends StatefulWidget {
  const Prusalink({super.key});

  @override
  State<Prusalink> createState() => _PrusalinkState();
}

class _PrusalinkState extends State<Prusalink> {
  late WebViewXController webviewController;

  void onWebViewCreated(WebViewXController<dynamic> controller) {
    webviewController = controller;
    controller.loadContent("http://192.168.178.129/", SourceType.url);
  }

  void onWebError(WebResourceError error) {
    print("onWebResourceError");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: WebViewX(
          onWebViewCreated: onWebViewCreated,
          onWebResourceError: onWebError,
          width: 999999,
          height: 999999,
        ),
      ),
    );
  }
}
