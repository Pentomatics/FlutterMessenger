import 'package:flutter/material.dart';
import 'package:flutter_messenger/pages/account_creation_page.dart';
import 'package:flutter_messenger/pages/login_page.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            new Text("Flutter Messenger", style: new TextStyle(color: Colors.redAccent)),
            new FlatButton(
              color: Colors.green,
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new LoginPage())),
              child: Text("Login", style: TextStyle(color: Colors.black)),
            ),
            new FlatButton(
              color: Colors.green,
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new AccountCreationPage())),
              child: Text("Create Account", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}