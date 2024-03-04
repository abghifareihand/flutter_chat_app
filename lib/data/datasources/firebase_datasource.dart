import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/data/models/channel_model.dart';
import 'package:flutter_chat_app/data/models/message_model.dart';
import 'package:flutter_chat_app/data/models/user_model.dart';

String channelid(String id1, String id2) {
  if (id1.hashCode < id2.hashCode) {
    return '$id1-$id2';
  } else {
    return '$id2-$id1';
  }
}

class FirebaseDatasource {
  FirebaseDatasource._init();
  static final FirebaseDatasource instance = FirebaseDatasource._init();

  Stream<List<UserModel>> allUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapShot) {
      List<UserModel> response = [];

      for (var element in snapShot.docs) {
        response.add(UserModel.fromDocumentSnapshot(element));
      }

      return response;
    });
  }

  Stream<List<Channel>> channelStream(String userId) {
    return FirebaseFirestore.instance
        .collection('channels')
        .where('memberIds', arrayContains: userId)
        .orderBy('lastTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<Channel> response = [];
      for (var element in querySnapshot.docs) {
        response.add(Channel.fromDocumentSnapshot(element));
      }
      return response;
    });
  }

  Future<void> updateChannel(
      String channelId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(channelId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addMessage(Message message) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<Message>> messageStream(String channelId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('channelId', isEqualTo: channelId)
        .orderBy('sendAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<Message> response = [];
      for (var element in querySnapshot.docs) {
        response.add(Message.fromDocumentSnapshot(element));
      }
      return response;
    });
  }
}
