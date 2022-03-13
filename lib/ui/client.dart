import 'package:chat_app/controller/client_controller.dart';
import 'package:chat_app/domain/client_server_model.dart';
import 'package:chat_app/domain/connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:input_history_text_field/input_history_text_field.dart';
import 'package:regexed_validator/regexed_validator.dart';

import 'chat.dart';

final _clientReceiveMessageProvider =
    ChangeNotifierProvider((ref) => Connection());

class Client extends StatefulWidget {
  const Client({Key? key}) : super(key: key);

  @override
  State<Client> createState() => ClientPage();
}

class ClientPage extends State<Client> {
  late ClientController _clientController;
  String _connectIpAddress = "";
  final _formKey = GlobalKey<FormState>();
  final ClientServerModel _model = ClientServerModel.client;

  @override
  Widget build(BuildContext context) {
    _clientController = ClientController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Client'),
        ),
        body: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText:
                              'Please enter IP address to connect server',
                        ),
                        validator: (input) {
                          if (input == null || !validator.ip(input)) {
                            return "Please Input IP address";
                          }
                          return null;
                        },
                        onChanged: (text) {
                          _updateAddress(text);
                        },
                        // historyKey: '01',
                        // showHistoryIcon: true,
                        // historyIcon: Icons.history,
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _clientController.connect(
                                context, _connectIpAddress);
                          }
                        },
                        child: const Text('connect'),
                      ),
                      Consumer(
                          builder: (context, watch, child) => watch
                                  .watch(_clientReceiveMessageProvider)
                                  .isTryConnecting
                              ? _loadingView()
                              : Container()),
                      Consumer(
                        builder: (context, watch, child) {
                          if (watch
                              .watch(_clientReceiveMessageProvider)
                              .isConnected) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          Chat(model: _model))).then((value) =>
                                  _clientController.sendMessage("disconnect"));
                            });
                          }
                          return Container();
                        },
                      )
                    ],
                  ),
                ))));
  }

  void _updateAddress(String e) {
//    if (_isIp(e)) {
      setState(() {
        _connectIpAddress = e;
      });
//    }
  }

  final RegExp _ipRegex = RegExp(
      r"^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");

  bool _isIp(String input) => _ipRegex.hasMatch(input);
}

Widget _loadingView() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
