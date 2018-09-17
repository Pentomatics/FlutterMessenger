import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messenger/models/user.dart';
import 'package:flutter_messenger/pages/chat_list_page.dart';


// Todo ignore multiple button presses, login needs some seconds
// Todo check internet connection

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
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            new Text("Flutter Messenger", style: new TextStyle(color: Colors.redAccent)),
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
            new FlatButton(
              color: Colors.green,
              onPressed: _signInIfInputsAreValid,
              child: Text("Login", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
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