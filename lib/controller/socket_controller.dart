import 'package:chat_app/domain/connection.dart';
import 'package:chat_app/domain/messenger.dart';

abstract class SocketController {
  late Connection connection;
  late Messenger messenger;

  SocketController() {
    connection = Connection();
    messenger = Messenger();
  }

  void sendMessage(String message);
}
