import 'package:chat_app/controller/socket_controller.dart';

class ServerController extends SocketController {
  void runServer() {
    connection.runServer();
  }

  @override
  void sendMessage(String message) {
    //messenger.sendMessageToClient(message);
  }
}
