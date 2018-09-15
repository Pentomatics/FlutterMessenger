import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback callback;

  LoginButton(this.callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.deepOrange,
        elevation: 10.0,
        child: MaterialButton(
          minWidth: 150.0,
          height: 50.0,
          color: Colors.orange,
          child: Text('Login as Guest'),
          onPressed: callback,
        ),
      ),
    );
  }
}