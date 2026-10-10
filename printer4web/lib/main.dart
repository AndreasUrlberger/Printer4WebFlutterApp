import 'package:flutter/material.dart';
import 'package:printer4web/app_config.dart';
import 'package:printer4web/printer_settings.dart';
import 'printer_tabs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  currentPrinterSettings = await PrinterSettings.load();
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
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: colorPrimary, brightness: Brightness.dark),
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: colorPrimary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary,
            foregroundColor: Colors.white,
          ),
        ),
        tabBarTheme: const TabBarThemeData(
            labelColor: colorPrimary,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: colorPrimary, width: 4))),
        switchTheme: SwitchThemeData(
            thumbColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.selected) ? colorPrimary : null),
            trackColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.selected) ? colorPrimary : null)),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: colorPrimary),
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: colorPrimary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary,
            foregroundColor: Colors.white,
          ),
        ),
        tabBarTheme: const TabBarThemeData(
            labelColor: colorPrimary,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: colorPrimary, width: 4))),
      ),
      themeMode: ThemeMode.system,
      home: PrinterTabs(),
    );
  }
}
