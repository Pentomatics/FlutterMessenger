import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messenger/UI/login_button.dart';
import 'package:flutter_messenger/UI/logout_button.dart';
import 'package:flutter_messenger/pages/home_page.dart';


class LoginPage extends StatelessWidget {
  final FirebaseAuth firebaseAuth  = FirebaseAuth.instance;
  BuildContext buildContext;

  Future<FirebaseUser> signInAnon() async {
    FirebaseUser user = await firebaseAuth.signInAnonymously();
    print("Signed in ${user.uid}");
    return user;
  }

  void signOut() {
    firebaseAuth.signOut();
    print('Signed Out!');
  }

  void signIn() {
    signInAnon().then((FirebaseUser user) {
      Navigator
          .of(buildContext)
          .push(MaterialPageRoute(
          builder: (BuildContext context) => HomePage(
            user: user,
          )))
          .catchError((e) => print(e));
    });
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            new LoginButton(signIn),
            new LogoutButton(signOut),
          ],
        ),
      ),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.greenAccent,
      child: new InkWell(
        //onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => QuizPage())),
        onTap: () => _doIt,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Lets Quizzz", style: new TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),),
            new Text("Tap to start!", style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }*/
}