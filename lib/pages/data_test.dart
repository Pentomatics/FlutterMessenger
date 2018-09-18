import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messenger/models/ChatChannel.dart';
import 'package:flutter_messenger/models/user.dart';
import 'package:flutter_messenger/pages/login_page.dart';

class DataTestPage extends StatefulWidget {

  @override
  State createState() => new DataTestPageState();
}

class DataTestPageState extends State<DataTestPage> {
  String data = "awdwaadwd";
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            new FlatButton(
              color: Colors.green,
              onPressed: _createNewChatChannel,
              child: Text("do it", style: TextStyle(color: Colors.black)),
            ),
            new Text(number.toString()),
          ],
        ),
      ),
    );
  }


  _createNewChatChannel() {

    ChatChannel chatChannel = new ChatChannel("Chat 01", "oho");
    Firestore.instance.collection("chatChannels").add(chatChannel.toJson());
    /*
    Firestore.instance.collection("chatChannels").where("name", isEqualTo: chatName).getDocuments().then((snapshot) {
      if (snapshot.documents.length >= 1) {
        "A Chat with that name already exists";
      }
      int l = documents.documents.length;
      bool bla = true;

      setState(() {
        data = new User.fromSnapshot(documents.documents[0]).name;
      });
    });
    Firestore.instance.collection("")
    Firestore.instance.collection("user").where("chatChannel", isEqualTo: )
    Firestore.instance.collection("user").snapshots().first.co
    Firestore.instance.collection("ChatChannels").where("user", isEqualTo: user.name)*/
  }









  _saveAndShowObject() {
    /*
    // store a new user
    User user = new User("Berta");
    Firestore.instance.collection("users").add(user.toJson());

    // get a user
    Firestore.instance.collection("users").getDocuments().then((value) {
      user = User.fromSnapshot(value.documents[0]);

      setState(() {
        data = user.name;
      });
    });*/

    /* // Query if Berta exists
    User user = new User("Berta");
    Firestore.instance.collection("users").where("name", isEqualTo: "Berta").getDocuments().then((snapshot) {
      int l = documents.documents.length;
      bool bla = true;

      setState(() {
        data = new User.fromSnapshot(documents.documents[0]).name;
      });
    });*/

    // UserUpdateInfor gibt es nicht
    /*
    UserUpdateInfo userInfo = new UserUpdateInfo();
    userInfo.displayName='fred';
    FirebaseAuth.instance.currentUser().then((value) {
      value.displayName.
    })*/

    //fuser.updateProfile(userInfo);

  }
}