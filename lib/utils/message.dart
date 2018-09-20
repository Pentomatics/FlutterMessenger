enum MessageType { TEXT, IMAGE }

// Todo
abstract class Message {
  DateTime time;
  String senderId;
  MessageType messageType;
}