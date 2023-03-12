import 'dart:convert';

import 'package:http_auth/http_auth.dart';
import 'package:printer4web/auth/keys.dart';
import 'package:printer4web/prusalink_data.dart';

Future<PrusalinkData?> makeRequest() async {
  final Uri uri =
      Uri(scheme: 'http', host: '192.168.178.129', path: 'api/printer');

  var client = DigestAuthClient(prusalinkUsername, prusalinkPassword);

  final url = uri;

  return client.get(url).then(
    (response) {
      PrusalinkData? data;
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        data = PrusalinkData.fromJson(jsonData);
      }

      return data;
    },
  );
}
