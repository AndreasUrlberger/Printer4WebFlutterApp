import "dart:io";
import "dart:math";
import "dart:typed_data";

import "package:flutter/foundation.dart";
import "package:printer4web/proto/printer_data.pb.dart";

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

class PrinterConnection {
  ConnectionState connectionState = ConnectionState.waitingForMessageLength;
  int currentMessageCode = MessageCodes.statusRequest; // Start value does not matter.
  int messageLength = 0; // Start value does not matter
  final List<int> messageBuffer = [];
  Socket? socket;
  Function statusUpdate = () {};
  bool stop = false;

  static Future<PrinterConnection> create(String address, int port, Function statusUpdate) async {
    PrinterConnection printerConnection = PrinterConnection();
    printerConnection.statusUpdate = statusUpdate;
    await printerConnection.connect(address, port);
    return printerConnection;
  }

  Future<void> connect(String address, int port) async {
    if (stop) {
      return;
    }

    try {
      socket = await Socket.connect(address, port);
    } catch (e) {
      print("Connecting socket failed with $e, try again shortly");
      Future.delayed(const Duration(milliseconds: 250));
    }
    print('connected');

    // Generally listen for any incoming messages.
    socket?.listen((event) {
          processByteStream(event);
        }, onError: (error) {
          print("Connection to printer died");
          socket?.close();
          print("Try connecting again");
          connect(address, port);
        }, onDone: () {
          print("Connection to printer ended");
          socket?.close();
          print("Try connecting again");
          connect(address, port);
        }) ??
        connect(address, port);
  }

  void cancel() {
    stop = true;
  }

  void sendStatusRequest() {
    if (socket == null) {
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

    socket?.add(headers);
    socket?.add(messageData);
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
    //print("PrinterStatus: insideBottom:  ${printerStatus.temperatureInsideBottom}, insideTop:  ${printerStatus.temperatureInsideTop}, outside:  ${printerStatus.temperatureOutside}, currentPrintConfig ${printerStatus.currentPrintConfig.name}");
    statusUpdate(printerStatus);
  }

  void onSocketError(Object object) {
    print("Socket Error");
  }

  void requestStatus() {}

  void receiveStatus() {}
}
