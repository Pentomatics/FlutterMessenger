import 'package:cloud_firestore/cloud_firestore.dart';

class TextMessage {
  String author;
  String text;
  DateTime time;

  TextMessage( this.author, this.text, this.time);

  TextMessage.fromSnapshot(DocumentSnapshot snapshot) : author = snapshot["author"], text = snapshot["text"], time = snapshot["time"];

  toJson() {
    return {
      "author": author,
      "text": text,
      "time": time,
    };
  }
}