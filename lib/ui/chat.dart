import 'package:chat_app/domain/client_server_model.dart';
import 'package:chat_app/ui/chat_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_message_view.dart';


class Chat extends StatelessWidget {
  final ClientServerModel model;


  const Chat({required this.model,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text("Chat page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ChatMessageView(model: model),
          ),
          (model == ClientServerModel.client) ? const ChatBottom() : Container()
        ],
      ),
    );
  }
}
