import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_messenger/UI/message_widget.dart';
import 'package:flutter_messenger/models/ChatChannel.dart';
import 'package:flutter_messenger/models/text_message.dart';
import 'package:flutter_messenger/models/user.dart';

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

  final List<Message> _messageWidgets = <Message>[];
  final TextEditingController _textController = new TextEditingController();

  bool _isWriting = false;

  ChatPageState(this._currentUser, this._chatChannel);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_chatChannel.name),
      ),
      body: new Column(
        children: <Widget>[
          new FlatButton(
            color: Colors.green,
            onPressed: () => _createMessage,
            child: new Text("do it", style: TextStyle(color: Colors.black)),
          ),
          new Flexible(
            child: new ListView.builder(
              itemBuilder: (context, index) => _messageWidgets[index],
                  //(context, int index) => _messages[index], // _ means nothing or null?... it doesn't matter
              itemCount: _messageWidgets.length,
              reverse: true,
              padding: new EdgeInsets.all(6.0),
            )
          ),
          new Divider(height: 1.0),
          new Container(
            child: _buildComposer(),
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          ),
        ],
      ),
    );
  }

  _createMessage() {
    //TextMessage textMessage = new TextMessage("ein text", _currentUser.name, new DateTime.now());
    //Firestore.instance.collection("users").add(user.toJson());
  }

  // The (input) Container at the bottom
  Widget _buildComposer() {
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

  @override
  void dispose() {
    for (Message message in _messageWidgets) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  void _submitMessage(String text) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });

    Message message = new Message(
        _currentUser.name,
        text,
        new AnimationController(
            vsync: this, duration: new Duration(milliseconds: 800)));
    setState(() {
      _messageWidgets.insert(0, message);
    });
    message.animationController.forward();
  }
}
