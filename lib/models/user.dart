

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;

  User(this.name);

  User.fromSnapshot(DocumentSnapshot snapshot) : name = snapshot["name"];

  toJson() {
    return {
      "name": name,
    };
  }
}