import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messenger/models/user.dart';
import 'package:flutter_messenger/pages/chat_list_page.dart';


// Todo ignore multiple button presses, login needs some seconds
// Todo check internet connection
// Todo transaction for creating a user

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}


class LoginPageState extends State<LoginPage> {
  BuildContext _buildContext;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;

  String _username;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;

    Widget authentication = new Container(
      padding: EdgeInsets.all(48.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: new TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              keyboardType: TextInputType.text,
              validator: _validateName,
              onSaved: (String value) {
                _username = value;
              },
            ),
          ),
          new Container(
            padding: EdgeInsets.symmetric(vertical: 48.0),
            child: new FlatButton(
              color: Colors.green,
              onPressed: _signInIfInputsAreValid,
              child: Text("Login", style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: new ListView(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("Flutter", style: new TextStyle(fontSize: 48.0, color: Colors.lightBlueAccent)),
              new Text("Messenger", style: new TextStyle(fontSize: 48.0, color: Colors.lightBlueAccent)),
              authentication,
            ],
          ),
        ],
      ),
    );
  }

  _signInIfInputsAreValid() {
    if (_validateInputs()) {
      _usernameExists(_username).then((exists) {
        if (exists)
          _signIn();
        else {
          _addNewUserAccount();
          _signIn();
        }
      });
    }
  }


  bool _validateInputs() {
    bool inputsValid = _formKey.currentState.validate();

    if (inputsValid) {
      _formKey.currentState.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }

    return inputsValid;
  }


  String _validateName(String username) {
    if (username.length < 3)
      return 'Name must have at least 3 charaters';
    else if (username.length > 19)
      return 'Name must be less than 20 charaters';
    else {
      return null;
    }
  }


  _signIn() {
    User user;

    Firestore.instance.collection("users").where("name", isEqualTo: _username).getDocuments().then((snapshot) {
      user = User.fromSnapshot(snapshot.documents.first);
      Navigator.of(_buildContext).push(MaterialPageRoute(builder: (BuildContext context) => new ChatListPage(user)));
    });
  }

  _addNewUserAccount() {
    User user = new User(_username);
    Firestore.instance.collection("users").add(user.toJson());
  }


  Future<bool> _usernameExists(String username) async {
    bool exists = false;

    await Firestore.instance.collection("users").where("name", isEqualTo: username).getDocuments().then((snapshot) {
      exists = (snapshot.documents.length >= 1);
    });

    return exists;
  }
}