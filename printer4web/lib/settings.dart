import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            setting("Druckername"),
            const SizedBox(height: 32,),
            setting("IP-Addresse Gehäuse"),
            const SizedBox(height: 32,),
            setting("IP-Addresse Prusalink"),
            const SizedBox(height: 32,),
            setting("Prusalink-Url")
          ],
        ),
      ),
    );
  }
}

Widget setting(String name) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("$name:", style: const TextStyle(fontSize: 18)),
      const SizedBox(height: 8,),
      Padding(
        padding: const EdgeInsets.only(left: 8),
        child: TextField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: name,
          ),
        ),
      ),
    ],
  );
}
