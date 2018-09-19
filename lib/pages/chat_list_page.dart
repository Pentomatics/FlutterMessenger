import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_messenger/models/user.dart';
import 'package:flutter_messenger/pages/chat_page.dart';

// Todo dont show own user

class ChatListPage extends StatefulWidget {
  final User _user;

  ChatListPage (this._user);

  @override
  State createState() => new ChatListPageState(_user);
}


class ChatListPageState extends State<ChatListPage> {
  final User _user;
  BuildContext _buildContext;

  ChatListPageState (this._user);

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat List Page of " + _user.name),
        actions: <Widget>[
          /*
          // Todo
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.skip(2).map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),*/
        ],
      ),
      body: new Container (
        padding: EdgeInsets.all(8.0),
        child: new Stack(
          children: <Widget>[
            new StreamBuilder(
              stream: Firestore.instance.collection("chatChannels").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return new Text("Loading...");
                return Column (
                  children: <Widget>[
                    new ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) => _buildChatListItem(context, snapshot.data.documents[index]),
                    ),
                  ],
                );
              },
            ),
            new Container(
              padding: EdgeInsets.all(14.0),
              alignment: Alignment(1.0, 1.0),
              child: FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                onPressed: () => {},
                tooltip: 'Toggle',
                child: IconButton(
                  icon: new Icon(Icons.add),
                  onPressed: _showDialog,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialog() async {
    showDialog<String>(
      context: _buildContext,
      builder: (BuildContext context) => (
          new AlertDialog(
            title: new Text("Enter a chatname"),
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                    hintText: "Chatname"),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(_buildContext);
                  }),
              new FlatButton(
                  child: const Text('OPEN'),
                  onPressed: () {
                    Navigator.pop(_buildContext, "");
                  })
            ],
          )),
    ).then<void>((String value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa: " + value);
      }
    });
  }

  Widget _buildChatListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      color: Colors.white70,
      child: new InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new ChatPage(_user, document["name"]))),
        child: new Container(
          padding: EdgeInsets.all(14.0),
          child: new Row(
            children: <Widget>[
              new CircleAvatar(
                  radius: 24.0,
                  child: new Text("CHAT")
              ),
              new Container(
                padding: EdgeInsets.only(left: 14.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("iohih", style: Theme.of(context).textTheme.headline),
                    new Container(
                      margin: const EdgeInsets.only(top: 6.0),
                      child: new Text("ohawoddwa"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }










/*
  String _chatname = "";


  _handleOnPressed() {
    _askChatname(buildContext);
  }


  _askChatname(BuildContext context) {
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new AlertDialog(
          title: new Text("Enter a chatname: "),
          /*children: <Widget>[
            new Form(
              key: _formKey,
              child: new TextFormField(
                decoration: const InputDecoration(labelText: 'Chatname'),
                keyboardType: TextInputType.text,
                validator: _validateChatName,
                onSaved: (String value) {
                  _chatname = value;
                },
              ),
            ),
            new Text("jojojawd")
          ],*/
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

  String _validateChatName(String chatname) {
    if (chatname != "")
      return "Chatname must have at least one character";
    return null;
  }*/
}