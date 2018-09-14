import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_messenger/UI/message.dart';



class ChatPage extends StatefulWidget {
  @override
  State createState() => new ChatPageState();
}

class ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
    final String defaultUsername = "Mr. Default";

    final List<Message> _messages = <Message>[];
    final TextEditingController _textController = new TextEditingController();

    bool _isWriting = false;

    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Chat name"),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
        ),
        body: new Column(
          children: <Widget>[
            new Flexible(
                child: new ListView.builder(
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
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
                    decoration: new InputDecoration.collapsed(hintText: "Enter Message"),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                      child: new Text("Submit"),
                      onPressed: _isWriting ? () => _submitMessage(_textController.text) : null,
                  )
                      : new IconButton(
                      icon: new Icon(Icons.message),
                      onPressed: _isWriting ? () => _submitMessage(_textController.text) : null,
                  ),
                ),
              ],
            ),
            decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border: new Border(top: new BorderSide(color: Colors.brown))) : null,
          ),
      );
    }

    @override
    void dispose() {
      for (Message message in _messages) {
        message.animationController.dispose();
      }
      super.dispose();
    }

    void _submitMessage(String text) {
      _textController.clear();
      setState(() {
        _isWriting = false;
      });

      Message message = new Message(defaultUsername, text, new AnimationController(vsync: this, duration: new Duration(milliseconds: 800)));
      setState(() {
        _messages.insert(0, message);
      });
      message.animationController.forward();
    }
}





















class Message extends StatelessWidget {
  Message (this.username, this.text, this.animationController);
  final String username;
  final String text;
  final AnimationController animationController;



  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut,
      ),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: new CircleAvatar(child: new Text(username)),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(username, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}