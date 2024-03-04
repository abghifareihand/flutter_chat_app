import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/components/loading_spinkit.dart';
import 'package:flutter_chat_app/data/datasources/firebase_datasource.dart';
import 'package:flutter_chat_app/data/models/channel_model.dart';
import 'package:flutter_chat_app/data/models/message_model.dart';
import 'package:flutter_chat_app/data/models/user_model.dart';
import 'package:flutter_chat_app/presentation/widgets/chat_buble.dart';

class ChatPage extends StatefulWidget {
  final UserModel partnerUser;

  const ChatPage({
    super.key,
    required this.partnerUser,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();

  /// Function sendMessage
  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }
    // channel not created yet

    final channel = Channel(
      id: channelid(currentUser!.uid, widget.partnerUser.id),
      memberIds: [currentUser!.uid, widget.partnerUser.id],
      members: [UserModel.fromFirebaseUser(currentUser!), widget.partnerUser],
      lastMessage: _messageController.text.trim(),
      sendBy: currentUser!.uid,
      lastTime: Timestamp.now(),
      unRead: {
        currentUser!.uid: false,
        widget.partnerUser.id: true,
      },
    );

    await FirebaseDatasource.instance
        .updateChannel(channel.id, channel.toMap());

    var docRef = FirebaseFirestore.instance.collection('messages').doc();
    var message = Message(
      id: docRef.id,
      textMessage: _messageController.text.trim(),
      senderId: currentUser!.uid,
      sendAt: Timestamp.now(),
      channelId: channel.id,
    );
    FirebaseDatasource.instance.addMessage(message);

    var channelUpdateData = {
      'lastMessage': message.textMessage,
      'sendBy': currentUser!.uid,
      'lastTime': message.sendAt,
      'unRead': {
        currentUser!.uid: false,
        widget.partnerUser.id: true,
      },
    };
    FirebaseDatasource.instance.updateChannel(channel.id, channelUpdateData);

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0BCAD4),
        title: Text(widget.partnerUser.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: FirebaseDatasource.instance.messageStream(
                channelid(widget.partnerUser.id, currentUser!.uid),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingSpinkit();
                }
                final List<Message> messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No message found'),
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  reverse: true,
                  itemCount: messages.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ChatBubble(
                      direction: message.senderId == currentUser!.uid
                          ? Direction.right
                          : Direction.left,
                      message: message.textMessage,
                      messageTime: message.formattedTime(),
                      photoUrl: widget.partnerUser.name[0].toUpperCase() +
                          widget.partnerUser.name[1].toUpperCase(),
                      type: BubbleType.top,
                    );
                  },
                );
              },
            ),
          ),

          /// Chat input
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
