import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_messenger/models/text_message.dart';

class ChatChannel {
  String name;
  List<TextMessage> messages;

  ChatChannel(this.name);

  ChatChannel.fromSnapshot(DocumentSnapshot snapshot) : name = snapshot["name"], messages = snapshot["messages"];

  toJson() {
    return {
      "name": name,
      "messages": messages,
    };
  }
}