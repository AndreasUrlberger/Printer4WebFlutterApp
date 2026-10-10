import 'dart:convert';
import 'dart:developer' as developer;

import 'package:printer4web/auth/keys.dart';
import 'package:printer4web/printer_settings.dart';
import 'package:printer4web/prusalink_data.dart';
import 'package:http/http.dart' as http;

void _logParsingFailure(
  String endpoint,
  http.Response response,
  Object error,
  StackTrace stackTrace,
) {
  developer.log(
    'PrusaLink response parsing failed for $endpoint '
    '(HTTP ${response.statusCode}): $error\n'
    '--- server response ---\n${response.body}\n'
    '--- end server response ---',
    name: 'printer4web.prusalink',
    error: error,
    stackTrace: stackTrace,
  );
}

void _logUnexpectedResponse(String endpoint, http.Response response) {
  developer.log(
    'PrusaLink request returned HTTP ${response.statusCode} for $endpoint\n'
    '--- server response ---\n${response.body}\n'
    '--- end server response ---',
    name: 'printer4web.prusalink.response',
  );
}

Future<PrusalinkPrinterData?> makePrinterRequest() async {
  final Uri uri = Uri.http(corsProxyAddress, prusalinkPrinterApi);
  final client = http.Client();
  final headers = {
    'x-api-key': prusalinkPassword,
    "x-requested-with": "XMLHttpRequest"
  };

  try {
    final response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      _logUnexpectedResponse(prusalinkPrinterApi, response);
      return null;
    }

    try {
      final jsonData = json.decode(response.body);
      if (jsonData is! Map) {
        throw const FormatException('Expected a JSON object');
      }
      return PrusalinkPrinterData.fromJson(jsonData.cast<String, dynamic>());
    } catch (error, stackTrace) {
      _logParsingFailure(prusalinkPrinterApi, response, error, stackTrace);
      return null;
    }
  } catch (error, stackTrace) {
    developer.log(
      'HTTP request failed: $error',
      name: 'printer4web.prusalink',
      error: error,
      stackTrace: stackTrace,
    );
    return null;
  } finally {
    client.close();
  }
}

Future<PrusalinkJobData?> makeJobRequest() async {
  final client = http.Client();
  final Uri uri = Uri.http(corsProxyAddress, prusalinkJobApi);
  final headers = {
    'x-api-key': prusalinkPassword,
    "x-requested-with": "XMLHttpRequest"
  };

  try {
    final response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      _logUnexpectedResponse(prusalinkJobApi, response);
      return null;
    }

    try {
      final jsonData = json.decode(response.body);
      if (jsonData is! Map) {
        throw const FormatException('Expected a JSON object');
      }
      return PrusalinkJobData.fromJson(jsonData.cast<String, dynamic>());
    } catch (error, stackTrace) {
      _logParsingFailure(prusalinkJobApi, response, error, stackTrace);
      return null;
    }
  } catch (error, stackTrace) {
    developer.log(
      'HTTP request failed: $error',
      name: 'printer4web.prusalink',
      error: error,
      stackTrace: stackTrace,
    );
    return null;
  } finally {
    client.close();
  }
}

// Request to preheat printer nozzle.
Future<bool> makePreheatNozzleRequest(int targetTemp) async {
  final Uri uri = Uri.http(corsProxyAddress, prusalinkPreheatNozzleApi);
  final client = http.Client();
  final headers = {
    'x-api-key': prusalinkPassword,
    "x-requested-with": "XMLHttpRequest",
    "Content-Type": "application/json"
  };
  final String json =
      "{\"command\":\"target\",\"targets\":{\"tool0\":$targetTemp}}";

  return client.post(uri, headers: headers, body: json).then(
    (response) {
      return (200 <= response.statusCode && response.statusCode <= 299);
    },
    onError: (error, stack) {
      developer.log(
        'HTTP request to preheat printer nozzle failed: $error',
        name: 'printer4web.prusalink',
        error: error,
        stackTrace: stack,
      );
      return false;
    },
  );
}

// Request to preheat printer heatbed.
Future<bool> makePreheatHeatbedRequest(int targetTemp) async {
  final Uri uri = Uri.http(corsProxyAddress, prusalinkPreheatBedApi);
  final client = http.Client();
  final headers = {
    'x-api-key': prusalinkPassword,
    "x-requested-with": "XMLHttpRequest",
    "Content-Type": "application/json"
  };
  final String json = "{\"command\": \"target\",\"target\": $targetTemp}";

  return client.post(uri, headers: headers, body: json).then(
    (response) {
      return (200 <= response.statusCode && response.statusCode <= 299);
    },
    onError: (error, stack) {
      developer.log(
        'HTTP request to preheat printer heatbed failed: $error',
        name: 'printer4web.prusalink',
        error: error,
        stackTrace: stack,
      );
      return false;
    },
  );
}
