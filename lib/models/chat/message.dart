

import 'package:samsar/models/chat/chat_user.dart';

class Message {
  final String id;
  final String content;
  final ChatUser sender;
  final String conversationId;
  final bool read;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.conversationId,
    required this.read,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      sender: ChatUser.fromJson(json['sender']),
      conversationId: json['conversationId'],
      read: json['read'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
