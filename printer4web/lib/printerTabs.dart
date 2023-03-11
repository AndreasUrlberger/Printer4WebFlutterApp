import 'package:flutter/material.dart';
import 'homepage.dart';
import 'printerInformation.dart';

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
