import 'package:flutter/material.dart';

import 'printer_http_api.dart';
import 'printer_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.settings});

  final PrinterSettings settings;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _printerHostController;
  late final TextEditingController _prusalinkHostController;
  late final TextEditingController _servicePortController;
  late final TextEditingController _corsPortController;
  late final TextEditingController _mjpgPortController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _printerHostController =
        TextEditingController(text: widget.settings.printerHost);
    _prusalinkHostController =
        TextEditingController(text: widget.settings.prusalinkHost);
    _servicePortController = TextEditingController(
        text: widget.settings.serviceControllerPort.toString());
    _corsPortController =
        TextEditingController(text: widget.settings.corsProxyPort.toString());
    _mjpgPortController = TextEditingController(
        text: widget.settings.mjpgStreamerPort.toString());
    _usernameController =
        TextEditingController(text: widget.settings.prusalinkUsername);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    for (final controller in [
      _printerHostController,
      _prusalinkHostController,
      _servicePortController,
      _corsPortController,
      _mjpgPortController,
      _usernameController,
      _passwordController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;

  String? _port(String? value) {
    final port = int.tryParse(value ?? '');
    return port == null || port < 1 || port > 65535
        ? 'Enter a port from 1 to 65535'
        : null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isSaving = true);
    widget.settings
      ..printerHost = _printerHostController.text.trim()
      ..prusalinkHost = _prusalinkHostController.text.trim()
      ..serviceControllerPort = int.parse(_servicePortController.text)
      ..corsProxyPort = int.parse(_corsPortController.text)
      ..mjpgStreamerPort = int.parse(_mjpgPortController.text)
      ..prusalinkUsername = _usernameController.text.trim();
    if (_passwordController.text.isNotEmpty) {
      widget.settings.prusalinkPassword = _passwordController.text;
    }
    try {
      await widget.settings.save();
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save settings: $error')),
        );
      }
    }
  }

  Future<void> _reset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset settings?'),
        content: const Text('All custom values will be replaced by defaults.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reset')),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await widget.settings.reset();
    if (!mounted) {
      return;
    }
    setState(() {
      _printerHostController.text = widget.settings.printerHost;
      _prusalinkHostController.text = widget.settings.prusalinkHost;
      _servicePortController.text =
          widget.settings.serviceControllerPort.toString();
      _corsPortController.text = widget.settings.corsProxyPort.toString();
      _mjpgPortController.text = widget.settings.mjpgStreamerPort.toString();
      _usernameController.text = widget.settings.prusalinkUsername;
      _passwordController.clear();
    });
  }

  Future<void> _shutdown() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Turn off housing backend?'),
        content: const Text('This will shut down the printer housing backend.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Turn off')),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    try {
      await PrinterHttpApi.shutdown();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Housing backend shutdown requested.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to shut down backend: $error')),
        );
      }
    }
  }

  Widget _field(TextEditingController controller, String label,
      {String? Function(String?)? validator, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_printerHostController, 'Printer host',
                validator: _required),
            _field(_prusalinkHostController, 'PrusaLink host',
                validator: _required),
            _field(_servicePortController, 'Service controller port',
                validator: _port),
            _field(_corsPortController, 'CORS proxy port', validator: _port),
            _field(_mjpgPortController, 'MJPG streamer port',
                validator: _port),
            _field(_usernameController, 'PrusaLink username',
                validator: _required),
            _field(_passwordController, 'PrusaLink password override',
                obscureText: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              child: Text(_isSaving ? 'Saving...' : 'Save settings'),
            ),
            TextButton(
              onPressed: _isSaving ? null : _reset,
              child: const Text('Reset to defaults'),
            ),
            const Divider(height: 32),
            OutlinedButton.icon(
              onPressed: _shutdown,
              icon: const Icon(Icons.power_settings_new),
              label: const Text('Turn off housing backend'),
            ),
          ],
        ),
      ),
    );
  }
}
