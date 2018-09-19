import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_messenger/models/ChatChannel.dart';
import 'package:flutter_messenger/models/user.dart';
import 'package:flutter_messenger/pages/chat_page.dart';
import 'package:flutter_messenger/utils/firestore_collections.dart';
import 'package:flutter_messenger/utils/firestore_utils.dart';

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

  final _controller = TextEditingController();

  ChatListPageState (this._user);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              stream: Firestore.instance.collection(FirestoreCollections.CHAT_CHANNELS).snapshots(),
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
            title: new Text("Enter a chat name"),
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: new InputDecoration(
                    hintText: "Chat name"),
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
                    Navigator.pop(_buildContext, _controller.text);
                  })
            ],
          )),
    ).then<void>(_joinOrCreateAndJoinChatChannel);
  }

  Widget _buildChatListItem(BuildContext context, DocumentSnapshot snapshot) {
    ChatChannel chatChannel = ChatChannel.fromSnapshot(snapshot);

    return Card(
      color: Colors.white70,
      child: new InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new ChatPage(_user, chatChannel))),
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
                    new Text(chatChannel.name, style: Theme.of(context).textTheme.headline),
                    new Container(
                      margin: const EdgeInsets.only(top: 6.0),
                      child: new Text("--------Letzte Nachricht ----------- 12.20 Mock-----"),
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

  _joinOrCreateAndJoinChatChannel(String chatName) {
    if (chatName != null && chatName != "") {
      FirestoreUtils.getChatChannel(chatName).then((chatChannel) {
        if (chatChannel != null) {
          Navigator.of(_buildContext).push(MaterialPageRoute(builder: (BuildContext context) => new ChatPage(_user, chatChannel)));
        } else {
          chatChannel = FirestoreUtils.createChatChannel(chatName);
          Navigator.of(_buildContext).push(MaterialPageRoute(builder: (BuildContext context) => new ChatPage(_user, chatChannel)));
        }
      });
    }
  }
}