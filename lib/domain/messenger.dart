import 'dart:io';

import 'package:flutter/cupertino.dart';

class Messenger extends ChangeNotifier {
  static final Messenger _cache = Messenger._internal();

  Messenger._internal();

  factory Messenger() {
    return _cache;
  }

  late Socket socket;
//  late Socket client;

  String _chatSendMessage = "";

  String get chatSendMessage => _chatSendMessage;

  String _chatReceiveMessage = "";

  String get chatReceiveMessage => _chatReceiveMessage;

  Future<void> updateChatReceiveMessage(String message) async {
    print('Receive: $message');
    _chatReceiveMessage = message;
    _chatSendMessage = "";
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _chatReceiveMessage = "";
  }

  Future<void> sendMessageToServer(String message) async {
    print('Client: $message');
    socket.write(message);
    _chatSendMessage = message;
    _chatReceiveMessage = "";
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _chatSendMessage = "";
  }

  Future<void> sendMessageToClient(Socket client, String message) async {
    print('Server: $message');
    client.write(message);
    _chatSendMessage = message;
    _chatReceiveMessage = "";
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _chatSendMessage = "";
  }
}
