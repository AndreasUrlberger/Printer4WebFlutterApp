import 'dart:convert';

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
  print(
    'PrusaLink response parsing failed for $endpoint '
    '(HTTP ${response.statusCode}): $error',
  );
  print('PrusaLink raw response: ${response.body}');
  print(stackTrace);
}

Future<PrusalinkPrinterData?> makePrinterRequest() async {
  final Uri uri = Uri.http(corsProxyAddress, prusalinkPrinterApi);
  final client = http.Client();
  final headers = {
    'x-api-key': prusalinkPassword,
    "x-requested-with": "XMLHttpRequest"
  };

  return client.get(uri, headers: headers).then(
        (response) {
      PrusalinkPrinterData? data;
      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          if (jsonData is! Map) {
            throw const FormatException('Expected a JSON object');
          }
          data = PrusalinkPrinterData.fromJson(
            jsonData.cast<String, dynamic>(),
          );
        } catch (error, stackTrace) {
          _logParsingFailure(
            prusalinkPrinterApi,
            response,
            error,
            stackTrace,
          );
        }
      }

      return data;
    },
    onError: (error, stack) {
      print("Http api request error: $error, stack: $stack");
    },
  );
}

Future<PrusalinkJobData?> makeJobRequest() async {
  final client = http.Client();
  final Uri uri = Uri.http(corsProxyAddress, prusalinkJobApi);
  final headers = {
    'x-api-key': prusalinkPassword,
    "x-requested-with": "XMLHttpRequest"
  };

  return client.get(uri, headers: headers).then(
        (response) {
      PrusalinkJobData? data;
      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          if (jsonData is! Map) {
            throw const FormatException('Expected a JSON object');
          }
          data = PrusalinkJobData.fromJson(
            jsonData.cast<String, dynamic>(),
          );
        } catch (error, stackTrace) {
          _logParsingFailure(
            prusalinkJobApi,
            response,
            error,
            stackTrace,
          );
        }
      }

      return data;
    },
    onError: (error, stack) {
      print("Http api request error: $error, stack: $stack");
    },
  );
}

// Request to preheat printer nozzle.
Future<bool> makePreheatNozzleRequest(int targetTemp) async {
  final Uri uri = Uri.http(corsProxyAddress, prusalinkPreheatNozzleApi);
  final client = http.Client();
  final headers = {
    'x-api-key': prusalinkPassword,
    "x-requested-with": "XMLHttpRequest",
    "Content-Type":"application/json"
  };
  final String json = "{\"command\":\"target\",\"targets\":{\"tool0\":$targetTemp}}";

  return client.post(uri, headers: headers, body: json).then(
        (response) {
      return (200 <= response.statusCode && response.statusCode <= 299);
    },
    onError: (error, stack) {
      print("Http api request to preheat printer nozzle: $error, stack: $stack");
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
    "Content-Type":"application/json"
  };
  final String json = "{\"command\": \"target\",\"target\": $targetTemp}";

  return client.post(uri, headers: headers, body: json).then(
        (response) {
      return (200 <= response.statusCode && response.statusCode <= 299);
    },
    onError: (error, stack) {
      print("Http api request to preheat printer heatbed: $error, stack: $stack");
      return false;
    },
  );
}