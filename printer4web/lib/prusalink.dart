import 'package:flutter/material.dart';

class Prusalink extends StatefulWidget {
  const Prusalink({super.key, required this.title});

  final String title;

  @override
  State<Prusalink> createState() => _PrusalinkState();
}

class _PrusalinkState extends State<Prusalink> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Prusalink",
        ),
      ),
    );
  }
}

