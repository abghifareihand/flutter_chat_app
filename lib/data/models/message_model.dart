import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Message {
  final String id;
  final String textMessage;
  final String senderId;
  final Timestamp sendAt;
  final String channelId;
  Message({
    required this.id,
    required this.textMessage,
    required this.senderId,
    required this.sendAt,
    required this.channelId,
  });

  Map<String, dynamic> toMap() {
    return {
      'textMessage': textMessage,
      'senderId': senderId,
      'sendAt': sendAt,
      'channelId': channelId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      textMessage: map['textMessage'] ?? '',
      senderId: map['senderId'] ?? '',
      sendAt: map['sendAt'],
      channelId: map['channelId'] ?? '',
    );
  }

  factory Message.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Message(
      id: snapshot.id,
      textMessage: snapshot['textMessage'] ?? '',
      senderId: snapshot['senderId'] ?? '',
      sendAt: snapshot['sendAt'],
      channelId: snapshot['channelId'] ?? '',
    );
  }

  String formattedTime() {
    // Ubah timestamp menjadi objek DateTime
    DateTime dateTime = sendAt.toDate();

    // Format waktu sesuai preferensi
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return formattedTime;
  }
}