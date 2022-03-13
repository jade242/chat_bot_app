import 'package:chat_app/domain/client_server_model.dart';
import 'package:chat_app/domain/messenger.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chat_app/ui/received_message.dart';
import 'package:chat_app/ui/sent_message.dart';

final _messageProvider = ChangeNotifierProvider((ref) => Messenger());

class ChatMessageView extends StatelessWidget {
  final List<String> messages = [];

  ClientServerModel model;

  ChatMessageView({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          String sentMessage = ref.watch(_messageProvider).chatSendMessage;
          print("chatSentMessage $sentMessage");
          if (sentMessage != "") {
            messages.add(sentMessage);
            return Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  print("index $index");
                  return _messageView(index);
                },
              ),
            );
          }
          String receiveMessage =
              ref.watch(_messageProvider).chatReceiveMessage;
          print("receiveMessage $receiveMessage");
          if (receiveMessage != "") {
            messages.add(receiveMessage);
            return Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  print("index $index");
                  return _messageView(index);
                },
              ),
            );
          }
          // return Expanded(
          //   child: ListView.builder(
          //     itemCount: messages.length,
          //     itemBuilder: (context, index) {
          //       if (index % 2 == 0) {
          //         return ReceivedMessage(message: messages[index]);
          //       } else {
          //         return SentMessage(message: messages[index]);
          //       }
          //     },
          //   ),
          // );
          return Container();
        },
      ),
    ]);
  }

  Widget _messageView(int index) {
    if (index % 2 != 0) {
      if (model == ClientServerModel.client) {
        return ReceivedMessage(message: messages[index]);
      } else {
        return SentMessage(message: messages[index]);
      }
    } else {
      if (model == ClientServerModel.client) {
        return SentMessage(message: messages[index]);
      } else {
        return ReceivedMessage(message: messages[index]);
      }
    }
  }
}
