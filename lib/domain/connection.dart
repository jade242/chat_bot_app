import 'dart:io';

import 'dart:typed_data';

import 'package:chat_app/domain/messenger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';



class Connection extends ChangeNotifier {


  final Messenger _messenger = Messenger();

  bool _isTryConnecting = false;
  bool get isTryConnecting => _isTryConnecting;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  late ServerSocket _server;

//  File _serverReceiveImage = File('');
//   File get serverReceiveImage => _serverReceiveImage;

  static final Connection _cache = Connection._internal();

  Connection._internal();

  factory Connection() {
    return _cache;
  }

  String _serverState = "";
  String get severState => _serverState;

  void connectToServer(BuildContext context, String ipaddress) async {
    // connect to the socket server
    final socket = await Socket.connect(ipaddress, 4567);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    // listen for responses from the server
    socket.listen(
      // handle data from the server
          (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        print('message from Server: $serverResponse');
        if (serverResponse == "Success") {
          _messenger.socket = socket;
          _isTryConnecting = false;
          print("client _isConnect = true");
          _isConnected = true;
          notifyListeners();
        } else {
          _messenger.updateChatReceiveMessage(serverResponse);
        }
      },

      // handle errors
      onError: (error) {
        print(error);
        _isConnected = false;
        socket.destroy();
        notifyListeners();
      },

      // handle server ending connection
      onDone: () {
        print('call onDone.');
        _isTryConnecting = false;
        _isConnected = false;
        notifyListeners();
        socket.destroy();
      },
    );

    // send some messages to the server
//    await sendMessage('Connect Request.');
    socket.write('Connect Request.');
    _isTryConnecting = true;
    notifyListeners();
//    final ByteData bytes = await rootBundle.load('assets/hide');
//    final Uint8List list = bytes.buffer.asUint8List();
  }



  void runServer() async {
    // bind the socket server to an address and port
    String? wifiIP = await NetworkInfo().getWifiIP();
    final server = await ServerSocket.bind(wifiIP, 4567);
    _server = server;
    _serverState = "listening";
    notifyListeners();

    // listen for client connections to the server
    server.listen((client) {
      print("server listen");
//      _messenger.client = client;
      _handleConnection(client);
    });

  }

  void _handleConnection(Socket client) {
    print('Connection from'
        ' ${client.remoteAddress.address}:${client.remotePort}');

    // listen for events from the client
    client.listen(
      // handle data from the client
          (Uint8List data) async {
        await Future.delayed(const Duration(seconds: 1));
        final message = String.fromCharCodes(data);
        if (message == 'Connect Request.') {
          print("server _isConnected = true");
          _isConnected = true;
          client.write("Success");
          notifyListeners();

        } else if (message == 'disconnect'){
//          client.write('disconnect');
          client.close();
          _serverState = 'disconnect';
          _isConnected = false;
          _stopServer();

        } else {
          print("_serverReceiveImage server receive data = $message");
//          _serverReceiveImage = File.fromRawPath(data);
          _messenger.updateChatReceiveMessage(message);
          await Future.delayed(const Duration(seconds: 2));
          _messenger.sendMessageToClient(client, "receive message");

        }
      },

      // handle errors
      onError: (error) {
        print(error);
        client.close();
        _isConnected = false;
        _serverState = "disconnect";
      },

      onDone: () {
        print('Client onDone');
//        notifyListeners();
        client.close();
      },
    );
  }

  void _stopServer() {
    _server.close();
    notifyListeners();
  }


}