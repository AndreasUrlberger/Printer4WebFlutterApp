import 'dart:convert';

import 'package:printer4web/auth/keys.dart';
import 'package:printer4web/printer_settings.dart';
import 'package:printer4web/prusalink_data.dart';
import 'package:http_auth/http_auth.dart';

Future<PrusalinkPrinterData?> makePrinterRequest() async {
  final Uri uri = Uri.http(corsProxyAddress, prusalinkPrinterApi);
  var client = DigestAuthClient(prusalinkUsername, prusalinkPassword);

  return client.get(uri, headers: {"x-requested-with": "XMLHttpRequest"}).then(
    (response) {
      PrusalinkPrinterData? data;
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        data = PrusalinkPrinterData.fromJson(jsonData);
      }

      return data;
    },
    onError: (error, stack) {
      print("Http api request error: $error, stack: $stack");
    },
  );
}

Future<PrusalinkJobData?> makeJobRequest() async {
  final Uri uri = Uri.http(corsProxyAddress, prusalinkJobApi);
  var client = DigestAuthClient(prusalinkUsername, prusalinkPassword);

  return client.get(uri, headers: {"x-requested-with": "XMLHttpRequest"}).then(
    (response) {
      PrusalinkJobData? data;
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        data = PrusalinkJobData.fromJson(jsonData);
      }

      return data;
    },
    onError: (error, stack) {
      print("Http api request error: $error, stack: $stack");
    },
  );
}

// Request to printer files api
Future<PrusalinkFilesData?> makeFilesRequest(String filesLink) async {
  final Uri uri = Uri.http(corsProxyAddress, filesLink);
  var client = DigestAuthClient(prusalinkUsername, prusalinkPassword);

  return client.get(uri, headers: {"x-requested-with": "XMLHttpRequest"}).then(
    (response) {
      PrusalinkFilesData? data;
      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
        var jsonData = json.decode(response.body);
        data = PrusalinkFilesData.fromJson(jsonData);
      }

      return data;
    },
    onError: (error, stack) {
      print("Http api request error: $error, stack: $stack");
    },
  );
}