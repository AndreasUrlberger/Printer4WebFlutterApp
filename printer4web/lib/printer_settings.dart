import 'package:shared_preferences/shared_preferences.dart';

import 'auth/keys.dart';

const String defaultPrinterIpAddress = '192.168.178.150';
const String defaultPrusalinkIpAddress = '192.168.178.129';
const int defaultServiceControllerPort = 1933;
const int defaultCorsProxyPort = 8080;
const int defaultMjpgStreamerPort = 8000;

class PrinterSettings {
  PrinterSettings({
    required this.printerHost,
    required this.prusalinkHost,
    required this.serviceControllerPort,
    required this.corsProxyPort,
    required this.mjpgStreamerPort,
    required this.prusalinkUsername,
    required this.prusalinkPassword,
  });

  String printerHost;
  String prusalinkHost;
  int serviceControllerPort;
  int corsProxyPort;
  int mjpgStreamerPort;
  String prusalinkUsername;
  String prusalinkPassword;

  static const _printerHostKey = 'printerHost';
  static const _prusalinkHostKey = 'prusalinkHost';
  static const _serviceControllerPortKey = 'serviceControllerPort';
  static const _corsProxyPortKey = 'corsProxyPort';
  static const _mjpgStreamerPortKey = 'mjpgStreamerPort';
  static const _prusalinkUsernameKey = 'prusalinkUsername';
  static const _prusalinkPasswordKey = 'prusalinkPassword';

  factory PrinterSettings.defaults() {
    return PrinterSettings(
      printerHost: defaultPrinterIpAddress,
      prusalinkHost: defaultPrusalinkIpAddress,
      serviceControllerPort: defaultServiceControllerPort,
      corsProxyPort: defaultCorsProxyPort,
      mjpgStreamerPort: defaultMjpgStreamerPort,
      prusalinkUsername: prusalinkUsername,
      prusalinkPassword: prusalinkPassword,
    );
  }

  static Future<PrinterSettings> load() async {
    final preferences = await SharedPreferences.getInstance();
    final defaults = PrinterSettings.defaults();
    return PrinterSettings(
      printerHost: preferences.getString(_printerHostKey) ?? defaults.printerHost,
      prusalinkHost:
          preferences.getString(_prusalinkHostKey) ?? defaults.prusalinkHost,
      serviceControllerPort: preferences.getInt(_serviceControllerPortKey) ??
          defaults.serviceControllerPort,
      corsProxyPort:
          preferences.getInt(_corsProxyPortKey) ?? defaults.corsProxyPort,
      mjpgStreamerPort:
          preferences.getInt(_mjpgStreamerPortKey) ?? defaults.mjpgStreamerPort,
      prusalinkUsername: preferences.getString(_prusalinkUsernameKey) ??
          defaults.prusalinkUsername,
      prusalinkPassword: preferences.getString(_prusalinkPasswordKey) ??
          defaults.prusalinkPassword,
    );
  }

  Future<void> save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_printerHostKey, printerHost);
    await preferences.setString(_prusalinkHostKey, prusalinkHost);
    await preferences.setInt(_serviceControllerPortKey, serviceControllerPort);
    await preferences.setInt(_corsProxyPortKey, corsProxyPort);
    await preferences.setInt(_mjpgStreamerPortKey, mjpgStreamerPort);
    await preferences.setString(_prusalinkUsernameKey, prusalinkUsername);

    // The built-in password is intentionally never copied to preferences.
    if (prusalinkPassword == PrinterSettings.defaults().prusalinkPassword) {
      await preferences.remove(_prusalinkPasswordKey);
    } else {
      await preferences.setString(_prusalinkPasswordKey, prusalinkPassword);
    }
  }

  Future<void> reset() async {
    final preferences = await SharedPreferences.getInstance();
    for (final key in [
      _printerHostKey,
      _prusalinkHostKey,
      _serviceControllerPortKey,
      _corsProxyPortKey,
      _mjpgStreamerPortKey,
      _prusalinkUsernameKey,
      _prusalinkPasswordKey,
    ]) {
      await preferences.remove(key);
    }
    final defaults = PrinterSettings.defaults();
    printerHost = defaults.printerHost;
    prusalinkHost = defaults.prusalinkHost;
    serviceControllerPort = defaults.serviceControllerPort;
    corsProxyPort = defaults.corsProxyPort;
    mjpgStreamerPort = defaults.mjpgStreamerPort;
    prusalinkUsername = defaults.prusalinkUsername;
    prusalinkPassword = defaults.prusalinkPassword;
  }

  String get serviceControllerAddress =>
      '$printerHost:$serviceControllerPort';
  String get corsProxyAddress => '$printerHost:$corsProxyPort';
  String get mjpgStreamAddress =>
      'http://$printerHost:$mjpgStreamerPort/?action=stream';
  String get prusalinkAddress => 'http://$prusalinkHost';
  String get prusalinkPrinterApi => '$prusalinkAddress/api/printer';
  String get prusalinkJobApi => '$prusalinkAddress/api/job';
  String get prusalinkPreheatNozzleApi =>
      '$prusalinkAddress/api/printer/tool';
  String get prusalinkPreheatBedApi => '$prusalinkAddress/api/printer/bed';
}

late PrinterSettings currentPrinterSettings;
