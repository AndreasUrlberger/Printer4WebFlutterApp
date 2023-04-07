import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printer4web/app_config.dart';
import 'printer_tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Printer4Web',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: colorPrimary, brightness: Brightness.dark),
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: colorPrimary,
        tabBarTheme: const TabBarTheme(labelColor: colorPrimary, indicator: UnderlineTabIndicator(borderSide: BorderSide(color: colorPrimary, width: 4))),
        switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected) ? colorPrimary : null),
            trackColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected) ? colorPrimary : null)),
      ),
      theme:
      ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: colorPrimary),
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: colorPrimary,
        tabBarTheme: const TabBarTheme(labelColor: colorPrimary, indicator: UnderlineTabIndicator(borderSide: BorderSide(color: colorPrimary, width: 4))),
      ),
      themeMode: ThemeMode.system,
      home: PrinterTabs(),
    );
  }
}
