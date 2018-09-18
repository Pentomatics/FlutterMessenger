

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_messenger/models/ChatChannel.dart';

class User {
  String name;
  List<ChatChannel> chatChannels;

  User(this.name);

  User.fromSnapshot(DocumentSnapshot snapshot) : name = snapshot["name"];

  toJson() {
    return {
      "name": name,
    };
  }



}