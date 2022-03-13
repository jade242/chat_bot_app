import 'package:chat_app/controller/client_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBottom extends StatefulWidget {
  const ChatBottom({Key? key}) : super(key: key);

  @override
  State<ChatBottom> createState() => ChatBottomWidget();
}

class ChatBottomWidget extends State<ChatBottom> {
  final ClientController _clientController = ClientController();
  String _sendMessage = "";

  @override
  Widget build(BuildContext context) {

    return Row(children: [
      IconButton(onPressed: () {}, icon: const Icon(Icons.photo_camera)),
      IconButton(onPressed: () {}, icon: const Icon(Icons.photo_outlined)),
      Expanded(
        child: TextFormField(
          validator: (input) {
            if (input == null) {
              return "input message";
            } else {
              return null;
            }
          },
          onChanged: (text) {
            _updateSendMessage(text);
          },
        ),
      ),
      IconButton(
          onPressed: () {
              _clientController.sendMessage(_sendMessage);
          },
          icon: const Icon(Icons.send)),
      IconButton(onPressed: () {}, icon: const Icon(Icons.mic))
    ]);
  }

  void _updateSendMessage(String message) {
    setState(() {
      _sendMessage = message;
    });
  }
}
