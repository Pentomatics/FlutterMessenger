import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_messenger/models/ChatChannel.dart';

class User {
  String name;
  String password;
  List<ChatChannel> chatChannels;

  User(this.name, this.password);

  User.fromSnapshot(DocumentSnapshot snapshot) : name = snapshot["name"], password = snapshot["password"];

  toJson() {
    return {
      "name": name,
      "password": password,
    };
  }
}