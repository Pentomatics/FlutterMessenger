import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_messenger/models/text_message.dart';

class ChatChannel {
  String name;
  String notiz;
  List<TextMessage> messages;

  ChatChannel(this.name, this.notiz);

  ChatChannel.fromSnapshot(DocumentSnapshot snapshot) : name = snapshot["name"], messages = snapshot["messages"];

  toJson() {
    return {
      "name": name,
      "notiz": notiz,
      "messages": messages,
    };
  }
}