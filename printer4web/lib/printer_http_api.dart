import 'package:printer4web/proto/printer_data.pb.dart';
import 'package:http/http.dart' as http;

class PrinterHttpApi {
  static Future<PrinterStatus> getStatus(String address, int port) async {
    final Uri url = Uri.http("$address:$port", "statusRequest");
    StatusRequest statusRequest = StatusRequest.create();
    statusRequest.includePrintConfigs = true;

    final response = await http.post(url, body: statusRequest.writeToBuffer());
    final PrinterStatus status = PrinterStatus.fromBuffer(response.bodyBytes);
    return status;
  }
}
