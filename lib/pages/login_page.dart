import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messenger/pages/chat_list_page.dart';
import 'package:flutter_messenger/utils/username_utils.dart';

// Todo ignore multiple button presses, login needs some seconds

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}


class LoginPageState extends State<LoginPage> {
  final FirebaseAuth firebaseAuth  = FirebaseAuth.instance;
  BuildContext buildContext;

  String signInErrorText = "";

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;

  String _username;
  String _password;


  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            children: <Widget>[
              new TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                keyboardType: TextInputType.text,
                validator: _validateName,
                onSaved: (String value) {
                  _username = value;
                },
              ),
              new TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                keyboardType: TextInputType.text,
                obscureText: true,
                validator: _validatePassword,
                onSaved: (String value) {
                  _password = value;
                },
              ),
              new Text(signInErrorText),
              new FlatButton(
                color: Colors.green,
                onPressed: _signInIfInputsValid,
                child: Text("Sign in", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
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
      return 'Name must have at least 3 charaters';
    else if (username.length > 19)
      return 'Name must be less than 20 charaters';
    else
      return null;
  }
// Todo login just say wrong password
  String _validatePassword(String password) {
    if (password.length < 6)
      return 'Password must have at least 6 charaters';
    else if (password.length > 19)
      return 'Password must be less than 20 charaters';
    else
      return null;
  }


  void _signInIfInputsValid() {
    if (_validateInputs()) {
      signIn().then((FirebaseUser user) {
        if (user != null) {
          Navigator.of(buildContext).push(MaterialPageRoute(builder: (BuildContext context) => new ChatListPage(user))).catchError((e) => print(e));
        }
      });
    }
  }

  //Todo check internet connection
  Future<FirebaseUser> signIn() async {
    FirebaseUser user = await firebaseAuth.signInWithEmailAndPassword(
        email: UsernameUtils.convertUsernameToEmail(_username),
        password: _password
    ).then((user) {return user;}).catchError((e) {
          if (e.message == "There is no user record corresponding to this identifier. The user may have been deleted.") {
            signInErrorText = "Username does not exist";
          } else if (e.message == "The password is invalid or the user does not have a password.") {
            signInErrorText = "The password is invalid";
          } else {
            signInErrorText = e.message;
            print(e);
          }

          setState(() {});
        });

    return user;
  }
}