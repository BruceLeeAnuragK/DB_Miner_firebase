import 'dart:developer';

class ChatModel {
  Map recieved;
  Map sent;
  String message;
  String time;

  ChatModel(
      {required this.recieved,
      required this.sent,
      required this.message,
      required this.time});

  factory ChatModel.fromMap({required Map data}) {
    return ChatModel(
        recieved: data['recieved'],
        sent: data['sent'],
        message: data['message'],
        time: data['time']);
  }
}
