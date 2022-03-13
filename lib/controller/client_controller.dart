import 'package:chat_app/controller/socket_controller.dart';
import 'package:flutter/cupertino.dart';

class ClientController extends SocketController{

  void connect(BuildContext context, String ipaddress) {
    connection.connectToServer(context, ipaddress);
  }

  @override
  void sendMessage(String message) {
    messenger.sendMessageToServer(message);
  }
}