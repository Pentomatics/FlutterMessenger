import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_messenger/models/ChatChannel.dart';
import 'package:flutter_messenger/models/text_message.dart';
import 'package:flutter_messenger/models/user.dart';
import 'package:flutter_messenger/utils/firestore_utils.dart';

class ChatPage extends StatefulWidget {
  final User _currentUser;
  final ChatChannel _chatChannel;

  ChatPage(this._currentUser, this._chatChannel);

  @override
  State createState() => new ChatPageState(_currentUser, _chatChannel);
}

class ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final ChatChannel _chatChannel;
  final User _currentUser;

  final TextEditingController _textController = new TextEditingController();

  bool _isWriting = false;
  String _channelID = "";

  ChatPageState(this._currentUser, this._chatChannel) {
    FirestoreUtils.getChatChannelDocument(_chatChannel.name).then((document) {
      _channelID = document.documentID;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_chatChannel.name),
      ),
      body: new Column(
        children: <Widget>[
          new StreamBuilder(
            stream: Firestore.instance.collection(FirestoreUtils.CHAT_CHANNELS).document(_channelID).collection("messages").orderBy("time", descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return new Text("Loading...");
              return Flexible (
                  child: new ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) => _buildMessageItem(context, snapshot.data.documents[index]),
                    reverse: true,
                    padding: new EdgeInsets.all(6.0),
                  ),
              );
            },
          ),
          new Divider(height: 1.0),
          new Container(
            child: _buildMessageInputContainer(),
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, DocumentSnapshot snapshot) {
    TextMessage message = TextMessage.fromSnapshot(snapshot);

    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: new CircleAvatar(child: new Text(message.author)),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(message.author, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 6.0),
                  child: new Text(message.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInputContainer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 9.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isWriting = text.length > 0;
                  });
                },
                onSubmitted: _submitMessage,
                decoration:
                    new InputDecoration.collapsed(hintText: "Enter Message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 3.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new CupertinoButton(
                      child: new Text("Submit"),
                      onPressed: _isWriting
                          ? () => _submitMessage(_textController.text)
                          : null,
                    )
                  : new IconButton(
                      icon: new Icon(Icons.message),
                      onPressed: _isWriting
                          ? () => _submitMessage(_textController.text)
                          : null,
                    ),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? new BoxDecoration(
                border: new Border(top: new BorderSide(color: Colors.brown)))
            : null,
      ),
    );
  }

  void _submitMessage(String text) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });

    TextMessage textMessage = new TextMessage(_currentUser.name, text, new DateTime.now());

    FirestoreUtils.getChatChannelDocument(_chatChannel.name).then((document) {
      FirestoreUtils.sendMessage(textMessage, document.documentID);
    });
  }
}
