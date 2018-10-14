import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_messenger/models/ChatChannel.dart';
import 'package:flutter_messenger/models/text_message.dart';


abstract class FirestoreUtils {

  static const String USERS = "users";
  static const String CHAT_CHANNELS = "chatChannels";
  
  static CollectionReference _chatChannelsCollectionRef = Firestore.instance.collection(CHAT_CHANNELS);
  
  
  static Future<ChatChannel> getChatChannel(String chatName) async {
    ChatChannel chatChannel;
    await Firestore.instance.collection(CHAT_CHANNELS).where("name", isEqualTo: chatName).getDocuments().then((snapshots) {
      if (snapshots.documents.length >= 1)
        chatChannel = ChatChannel.fromSnapshot(snapshots.documents.first);
    });

    return chatChannel;
  }

  static Future<DocumentSnapshot> getChatChannelDocument(String chatName) async {
    DocumentSnapshot document;
    await Firestore.instance.collection(CHAT_CHANNELS).where("name", isEqualTo: chatName).getDocuments().then((snapshots) {
      if (snapshots.documents.length >= 1)
        document = snapshots.documents.first;
    });

    return document;
  }

  static ChatChannel createChatChannel(String chatName) {
    ChatChannel chatChannel = new ChatChannel(chatName);
    Firestore.instance.collection(CHAT_CHANNELS).add(chatChannel.toJson());

    return chatChannel;
  }





  static Future<DocumentSnapshot> getOrCreateChatChannel(String chatName) async {
    DocumentSnapshot chatChannelSnapshot;
    await Firestore.instance.collection(CHAT_CHANNELS).where("name", isEqualTo: chatName).getDocuments().then((snapshots) {
      if (snapshots.documents.isEmpty) {
        ChatChannel chatChannel = new ChatChannel(chatName);
        Firestore.instance.collection(CHAT_CHANNELS).add(chatChannel.toJson()).then((documentReference) {
          documentReference.get().then((snapshot) {
            chatChannelSnapshot = snapshot;
          });
        });
      } else {
        chatChannelSnapshot = snapshots.documents.first;
      }
    });
    return chatChannelSnapshot;
  }
/*
  static Future<DocumentSnapshot> createChatChannel(String chatName) async {
    ChatChannel chatChannel = new ChatChannel(chatName);
    DocumentSnapshot chatChannelSnapshot;

    await Firestore.instance.collection(CHAT_CHANNELS).add(chatChannel.toJson()).then((documentReference) {
      documentReference.get().then((snapshot) {
        chatChannelSnapshot = snapshot;
      });
    });

    return chatChannelSnapshot;


    Firestore.instance.runTransaction((transaction) async {
      transaction.
      DocumentSnapshot freshSnap = await transaction.get(document.reference);
      await transaction.update(
          freshSnap.reference, {'votes': freshSnap['votes'] + 1});
    }),
  }*/




  
  static sendMessage(TextMessage message, String channelId) {
    _chatChannelsCollectionRef.document(channelId).collection("messages").add(message.toJson());
  }
}