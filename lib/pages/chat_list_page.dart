import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_messenger/pages/chat_page.dart';

class ChatListPage extends StatelessWidget {
  final FirebaseUser user;

  ChatListPage (this.user);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Chat List Page"),
        ),
      body: new StreamBuilder(
        stream: Firestore.instance.collection("chats").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return new Text("Loading...");
          return new ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => _buildChatListItem(context, snapshot.data.documents[index]),
          );
        },
      ),
    );
  }


  Widget _buildChatListItem(BuildContext context, DocumentSnapshot document) {
    return new FlatButton(
      color: Colors.green,
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new ChatPage())),
      child: new Text("${document["name"]}", style: TextStyle(color: Colors.black)),
    );
  }

}