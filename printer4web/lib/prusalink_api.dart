import 'dart:convert';

import 'package:printer4web/auth/keys.dart';
import 'package:printer4web/printer_settings.dart';
import 'package:printer4web/prusalink_data.dart';
import 'package:http_auth/http_auth.dart';

Future<PrusalinkData?> makeRequest() async {
  final Uri uri = Uri.http(corsProxyAddress, prusalinkPrinterApi);
  var client = DigestAuthClient(prusalinkUsername, prusalinkPassword);

  return client.get(uri, headers: {"x-requested-with": "XMLHttpRequest"}).then(
    (response) {
      PrusalinkData? data;
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        data = PrusalinkData.fromJson(jsonData);
      }

      return data;
    },
    onError: (error, stack) {
      print("Http api request error: $error, stack: $stack");
    },
  );
}
