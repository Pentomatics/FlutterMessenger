import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback callback;

  LogoutButton(this.callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: FlatButton(
        color: Colors.white,
        onPressed: callback,
        child: Text(
          "Sign Out",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}