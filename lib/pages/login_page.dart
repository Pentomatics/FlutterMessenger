import 'dart:convert';
import 'package:convert/convert.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messenger/pages/chat_list_page.dart';
import 'package:flutter_messenger/utils/firestore_utils.dart';


// Todo ignore multiple button presses, login needs some seconds
// Todo check internet connection
// Todo transaction for creating a user

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}


class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;

  String _username;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.all(48.0),
              child: new Column(
                children: <Widget>[
                  new Text("Flutter", style: new TextStyle(fontSize: 48.0, color: Colors.lightBlueAccent)),
                  new Text("Messenger", style: new TextStyle(fontSize: 48.0, color: Colors.lightBlueAccent)),
                  new Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    constraints: BoxConstraints(maxWidth: 200.0),
                    child: new Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: new Column(
                        children: <Widget>[
                          new TextFormField(
                            decoration: new InputDecoration(labelText: 'Username'),
                            keyboardType: TextInputType.text,
                            validator: _validateName,
                            onSaved: (String value) {
                              _username = value;
                            },
                          ),
                          new TextFormField(
                            obscureText: true,
                            decoration: new InputDecoration(labelText: 'Password'),
                            validator: _validatePassword,
                            onSaved: (String value) {
                              _password = generateMd5(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: new FlatButton(
                            color: Colors.green,
                            onPressed: _onSignInButtonPress,
                            child: Text("Sign in", style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        new Container(
                          padding: EdgeInsets.all(8.0),
                          child: new FlatButton(
                            color: Colors.green,
                            onPressed: _onSignUpButtonPress,
                            child: Text("Sign up", style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String generateMd5(String data) {
    List<int> content = utf8.encode(data);
    Digest digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  _onSignInButtonPress() {
    if (_validateInputs()) {
      FirestoreUtils.getUserByName(_username).then((user) {
        if (user != null) {
          if (_password == user.password) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new ChatListPage(user)));
          } else {
            _showDialog("Wrong password");
          }
        } else {
          _showDialog("User does not exist");
        }
      });
    }
  }

  _onSignUpButtonPress() {
    if (_validateInputs()) {
      FirestoreUtils.getUserByName(_username).then((user) {
        if (user == null) {
          FirestoreUtils.createUser(_username, _password).then((user) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new ChatListPage(user)));
          });
        } else {
          _showDialog("Username does already exist");
        }
      });
    }
  }


  _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
      return 'Name must contain at least 3 charaters';
    else if (username.length > 19)
      return 'Name must contain less than 20 charaters';
    else {
      return null;
    }
  }

  String _validatePassword(String password) {
    if (password.length < 3)
      return 'Password must contain at least 3 charaters';
    else if (password.length > 19)
      return 'Password must contain less than 20 charaters';
    else {
      return null;
    }
  }
}