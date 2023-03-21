import 'dart:math';
import 'dart:typed_data';

import 'package:printer4web/proto/printer_data.pb.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class MessageCodes {
  static const int statusRequest = 0;
  static const int addPrintConfig = 1;
  static const int removePrintConfig = 2;
  static const int changeTempControlL = 3;
  static const int keepAlive = 4;
  static const int status = 5;
}

enum ConnectionState {
  waitingForMessageLength,
  waitingForMessageCode,
  waitingForMessageContents,
}

class PrinterConnectionWeb {
  WebSocketChannel? channel;

  Function statusUpdate = () {};
  ConnectionState connectionState = ConnectionState.waitingForMessageLength;
  int currentMessageCode = MessageCodes.statusRequest; // Start value does not matter.
  int messageLength = 0; // Start value does not matter
  final List<int> messageBuffer = [];
  bool stop = false;

  static Future<PrinterConnectionWeb> create(String address, int port, Function statusUpdate) async {
    PrinterConnectionWeb printerConnection = PrinterConnectionWeb();
    printerConnection.statusUpdate = statusUpdate;
    await printerConnection.connect(address, port);
    return printerConnection;
  }

  Future<void> connect(String address, int port) async {
    if (stop) {
      return;
    }

    try {
      channel = WebSocketChannel.connect(Uri(scheme: "ws", host: address, port: port));
      await channel?.ready;
    } catch (e) {
      print("Connecting socket failed with $e, try again shortly");
      await Future.delayed(const Duration(milliseconds: 250));
    }

    if (channel != null) {
      print('connected');
    }

    // Generally listen for any incoming messages.
    channel?.stream.listen((event) {
          processByteStream(event);
        }, onError: (error) {
          print("Connection to printer died with error: $error");
          channel?.sink.close(status.abnormalClosure);
          print("Try connecting again");
          connect(address, port);
        }, onDone: () {
          print("Connection to printer ended");
          channel?.sink.close(status.normalClosure);
          print("Try connecting again");
          connect(address, port);
        }) ??
        connect(address, port);
  }

  void processByteStream(Uint8List input) {
    int readIndex = 0;
    while (readIndex < input.length) {
      switch (connectionState) {
        case ConnectionState.waitingForMessageLength:
          messageLength = input[readIndex];
          readIndex += 1;
          connectionState = ConnectionState.waitingForMessageCode;
          //print("Read message length: $messageLength");
          break;
        case ConnectionState.waitingForMessageCode:
          currentMessageCode = input[readIndex];
          readIndex += 1;
          connectionState = ConnectionState.waitingForMessageContents;
          //print("Read message code: $currentMessageCode");
          break;
        case ConnectionState.waitingForMessageContents:
          final int contentLength = messageLength - 1;
          final int leftToRead = contentLength - messageBuffer.length;
          final int availableToRead = min(leftToRead, input.length - readIndex);
          messageBuffer.addAll(input.sublist(readIndex, readIndex + availableToRead));
          if (messageBuffer.length < contentLength) {
            // Finished this chunk.
          } else {
            // Finished this message.
            //print("message buffer length: ${messageBuffer.length}, expected contentLength: $contentLength, bufferContent: ");
            //messageBuffer.forEach((element) {print("$element, ");});
            if (stop) {
              return;
            }

            switch (currentMessageCode) {
              case MessageCodes.status:
                processStatusMessage();
                break;
              default:
                print("Invalid message code $currentMessageCode");
            }

            // Clear data.
            messageBuffer.clear();
            connectionState = ConnectionState.waitingForMessageLength;
            // Input chunk might not be finished.
            readIndex += availableToRead;
          }
          break;
      }
    }
  }

  void processStatusMessage() {
    PrinterStatus printerStatus = PrinterStatus.fromBuffer(messageBuffer);
    /*print("PrinterStatus: insideBottom:  ${printerStatus.temperatureInsideBottom}, insideTop:  ${printerStatus.temperatureInsideTop}, outside:  ${printerStatus.temperatureOutside}, currentPrintConfig ${printerStatus.currentPrintConfig.name}");
    if (printerStatus.printConfigs.isNotEmpty) {
      print("PrintConfigs: ${printerStatus.printConfigs}");
    }*/
    statusUpdate(printerStatus);
  }

  void sendStatusRequest() {
    if (channel == null) {
      return;
    }

    StatusRequest statusRequest = StatusRequest.create();
    statusRequest.includePrintConfigs = true;

    // Send StatusRequest.
    var messageData = statusRequest.writeToBuffer();
    var headers = Uint8List(2);
    headers[0] = messageData.length + 1;
    headers[1] = MessageCodes.statusRequest;

    //print("message contents: ${messageData[0]} ${messageData[1]}");
    //print("length of headers: ${headers.length}, length of message: ${messageData.length}");

    var b = BytesBuilder();
    b.add(headers);
    b.add(messageData);

    channel?.sink.add(b.toBytes());

    //channel?.sink.add(headers);
    //channel?.sink.add(messageData);
  }
}
