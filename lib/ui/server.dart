import 'package:chat_app/controller/server_controller.dart';
import 'package:chat_app/domain/client_server_model.dart';
import 'package:chat_app/domain/connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat.dart';

final _serverReceiveMessageProvider =
    ChangeNotifierProvider((ref) => Connection());

class Server extends StatefulWidget {
  const Server({Key? key}) : super(key: key);

  @override
  State<Server> createState() => ServerPage();
}

class ServerPage extends State<Server> {
  late ServerController _serverController;
  String receive = "";
  final ClientServerModel _model = ClientServerModel.server;

  @override
  Widget build(BuildContext context) {
    _serverController = ServerController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Server'),
        ),
        body: Container(
            width: double.infinity,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    _serverController.runServer();
                  },
                  child: const Text('Run'),
                ),
                Consumer(
                  builder: (context, watch, child) {
                    if (watch
                        .watch(_serverReceiveMessageProvider)
                        .isConnected) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                                Chat(model: _model)));
                      });
                    }
                    receive = watch.watch(_serverReceiveMessageProvider).severState;
                    return Text(receive);
                  },
                )
              ],
            )));
  }
}
