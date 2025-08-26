import 'package:samsar/models/chat/chat_user.dart';
import 'package:samsar/models/chat/message.dart';

class Conversation {
  final String id;
  final List<ChatUser> participants;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final Message? recentMessage;

  Conversation({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.lastMessageAt,
    this.recentMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      participants: List<ChatUser>.from(
        json['participants'].map((p) => ChatUser.fromJson(p)),
      ),
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'])
          : null,
      recentMessage:
          json['lastMessage'] != null &&
              json['lastMessage'] is Map<String, dynamic>
          ? Message.fromJson(json['lastMessage'])
          : null,
    );
  }
}
