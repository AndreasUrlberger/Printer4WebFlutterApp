import 'package:flutter/material.dart';
import 'package:printer4web/app_config.dart';
import 'printer_tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Printer4Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: colorPrimary),
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: colorPrimary,
        tabBarTheme: TabBarTheme(
            labelColor: colorPrimary,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: colorPrimary,width: 4))),
      ),
      home: PrinterTabs(),
    );
  }
}
// TabBarTheme that makes background of TabBar orange.
