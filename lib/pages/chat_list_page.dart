import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  final FirebaseUser user;

  ChatListPage (this.user);

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Center(
        child: new Text("Chat list Page"),
      )
    );
  }

}