import 'package:flutter/material.dart';

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

