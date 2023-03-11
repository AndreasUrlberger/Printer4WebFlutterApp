import 'package:flutter/material.dart';

class HousingInformation extends StatefulWidget {
  const HousingInformation({super.key, required this.title});

  final String title;

  @override
  State<HousingInformation> createState() => _HousingInformationState();
}

class _HousingInformationState extends State<HousingInformation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Housing Information",
        ),
      ),
    );
  }
}

