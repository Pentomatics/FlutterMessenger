import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_messenger/models/ChatChannel.dart';
import 'package:flutter_messenger/models/text_message.dart';
import 'package:flutter_messenger/models/user.dart';
import 'package:flutter_messenger/utils/firestore_collections.dart';


abstract class FirestoreUtils {

  static const String USERS = "users";
  static const String CHAT_CHANNELS = "chatChannels";
  
  static CollectionReference _chatChannelsCollectionRef = Firestore.instance.collection(FirestoreCollections.CHAT_CHANNELS);
  
  
  static Future<ChatChannel> getChatChannel(String chatName) async {
    ChatChannel chatChannel;
    await Firestore.instance.collection(FirestoreCollections.CHAT_CHANNELS).where("name", isEqualTo: chatName).getDocuments().then((snapshots) {
      if (snapshots.documents.length >= 1)
        chatChannel = ChatChannel.fromSnapshot(snapshots.documents.first);
    });

    return chatChannel;
  }

  static Future<DocumentSnapshot> getChatChannelDocument(String chatName) async {
    DocumentSnapshot document;
    await Firestore.instance.collection(FirestoreCollections.CHAT_CHANNELS).where("name", isEqualTo: chatName).getDocuments().then((snapshots) {
      if (snapshots.documents.length >= 1)
        document = snapshots.documents.first;
    });

    return document;
  }

  static ChatChannel createChatChannel(String chatName) {
    ChatChannel chatChannel = new ChatChannel(chatName);
    Firestore.instance.collection(FirestoreCollections.CHAT_CHANNELS).add(chatChannel.toJson());

    return chatChannel;
  }
/*
  static addTextMessageToChannel(TextMessage message) {
    Firestore.instance.collection(FirestoreCollections.CHAT_CHANNELS).document("ad")?.get().then((snapshot) {
      ChatChannel channel = ChatChannel.fromSnapshot(snapshot);
      channel.messages.add(message);
      Firestore.instance.collection(FirestoreCollections.CHAT_CHANNELS).
    });
  }*/
  
  static sendMessage(TextMessage message, String channelId) {
    _chatChannelsCollectionRef.document(channelId).collection("messages").add(message.toJson());
  }
}