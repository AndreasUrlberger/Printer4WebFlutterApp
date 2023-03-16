import 'package:flutter/material.dart';
import 'homepage.dart';
import 'printer_information.dart';
import 'housing_information.dart';
import 'prusalink.dart';
import 'settings.dart';

class PrinterTabs extends StatefulWidget {
  const PrinterTabs({super.key});

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
        body: TabBarView(
          children: [
            const HomePage(),
            const PrinterInformation(),
            HousingInformation(),
            const Prusalink(),
            const Settings(),
          ],
        ),
      ),
    ); //const MyHomePage(title: 'Printer4Web'),;
  }
}