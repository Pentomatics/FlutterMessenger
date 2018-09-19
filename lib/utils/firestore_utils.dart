import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_messenger/models/ChatChannel.dart';
import 'package:flutter_messenger/models/user.dart';
import 'package:flutter_messenger/utils/firestore_collections.dart';


abstract class FirestoreUtils {
  static Future<ChatChannel> getChatChannel(String chatName) async {
    ChatChannel chatChannel;
    await Firestore.instance.collection(FirestoreCollections.CHAT_CHANNELS).where("name", isEqualTo: chatName).getDocuments().then((snapshot) {
      if (snapshot.documents.length >= 1)
        chatChannel = ChatChannel.fromSnapshot(snapshot.documents.first);
    });

    return chatChannel;
  }

  static ChatChannel createChatChannel(String chatName) {
    ChatChannel chatChannel = new ChatChannel(chatName);
    Firestore.instance.collection(FirestoreCollections.CHAT_CHANNELS).add(chatChannel.toJson());

    return chatChannel;
  }
}