import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messenger/models/user.dart';
import 'package:flutter_messenger/pages/chat_list_page.dart';


// Todo delete
class LayoutTestPage extends StatefulWidget {
  @override
  State createState() => new LayoutTestPageState();
}


class LayoutTestPageState extends State<LayoutTestPage> {
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Kandersteg, Switzerland',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('41'),
        ],
      ),
    );

    Column buildButtonColumn(IconData icon, String label) {
      Color color = Theme.of(context).primaryColor;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.call, 'CALL'),
          buildButtonColumn(Icons.near_me, 'ROUTE'),
          buildButtonColumn(Icons.share, 'SHARE'),
        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        '''
Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.
        ''',
        softWrap: true,
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Top Lakes'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'images/lake.jpg',
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
    );
  }
}



/*
_________________width / hight _______________________________________________
              new SizedBox(
                width: double.infinity,
                // height: double.infinity,
                child: new FlatButton(
                  color: Colors.green,
                  onPressed: _signInIfInputsAreValid,
                  child: Text("Login", style: TextStyle(color: Colors.black)),
                ),
              ),

              new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new FlatButton(
                    color: Colors.green,
                    onPressed: _signInIfInputsAreValid,
                    child: Text("Login", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),



_________________________gewichtung__________________________________________

new Row(
  children: <Widget>[
    new Expanded(
      child: new Container(
        decoration: const BoxDecoration(color: Colors.red),
      ),
      flex: 3,
    ),
    new Expanded(
      child: new Container(
        decoration: const BoxDecoration(color: Colors.green),
      ),
      flex: 2,
    ),
    new Expanded(
      child: new Container(
        decoration: const BoxDecoration(color: Colors.blue),
      ),
      flex: 1,
    ),
  ],
),
*/
