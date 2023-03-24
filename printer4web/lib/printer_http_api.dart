import 'package:printer4web/printer_settings.dart';
import 'package:printer4web/proto/printer_data.pb.dart';
import 'package:http/http.dart' as http;

class PrinterHttpApi {

  static Future<PrinterStatus> getStatus() async {
    final Uri url = Uri.http(serviceControllerAddress, "statusRequest");
    final StatusRequest statusRequest = StatusRequest.create();
    statusRequest.includePrintConfigs = true;

    final response = await http.post(url, body: statusRequest.writeToBuffer());
    final PrinterStatus status = PrinterStatus.fromBuffer(response.bodyBytes);
    return status;
  }

  static Future<PrinterStatus> addPrintConfig(String configName, int configTemp) async {
    final Uri url = Uri.http(serviceControllerAddress, "addPrintConfig");
    AddPrintConfig addPrintConfig = AddPrintConfig.create();
    PrintConfig printConfig = PrintConfig.create();
    printConfig.temperature = configTemp;
    printConfig.name = configName;
    addPrintConfig.printConfig = printConfig;

    final response = await http.post(url, body: addPrintConfig.writeToBuffer());
    final PrinterStatus status = PrinterStatus.fromBuffer(response.bodyBytes);
    return status;
  }

  static Future<PrinterStatus> removePrintConfig(String configName, int configTemp) async {
    final Uri url = Uri.http(serviceControllerAddress, "removePrintConfig");
    final RemovePrintConfig removePrintConfig = RemovePrintConfig.create();
    PrintConfig printConfig = PrintConfig.create();
    printConfig.temperature = configTemp;
    printConfig.name = configName;
    removePrintConfig.printConfig = printConfig;

    final response = await http.post(url, body: removePrintConfig.writeToBuffer());
    final PrinterStatus status = PrinterStatus.fromBuffer(response.bodyBytes);
    return status;
  }

  static Future<PrinterStatus> changeTempControl(bool isActive, String? configName, int? configTemp) async {
    final Uri url = Uri.http(serviceControllerAddress, "changeTempControl");
    final ChangeTempControl changeTempControl = ChangeTempControl.create();
    changeTempControl.isActive = isActive;
    if(configName != null && configTemp != null) {
      PrintConfig config = PrintConfig.create();
      config.temperature = configTemp;
      config.name = configName;
      changeTempControl.selectedPrintConfig = config;
    }

    final response = await http.post(url, body: changeTempControl.writeToBuffer());
    final PrinterStatus status = PrinterStatus.fromBuffer(response.bodyBytes);
    return status;
  }

  // Requests the printer to shutdown.
  static void shutdown() async {
    final Uri url = Uri.http(serviceControllerAddress, "shutdown");
    await http.post(url);
  }
}
