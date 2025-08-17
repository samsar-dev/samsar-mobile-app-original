import 'package:dio/dio.dart';
import 'package:samsar/constants/api_route_constants.dart';
import 'package:samsar/models/chat/conversation_model.dart';
import 'package:samsar/models/chat/message.dart';

class ChatService {
  final Dio dio;

  ChatService(this.dio);

  /// 🔐 Get all conversations for authenticated user
  Future<List<Conversation>> getConversations() async {
    final response = await dio.get(getConversationsRoute);
    final data = response.data['data']['items'];
    return List<Conversation>.from(
      data.map((json) => Conversation.fromJson(json)),
    );
  }

  /// 📝 Create a new conversation
  Future<Conversation> createConversation({
    required List<String> participantIds,
    String? initialMessage,
  }) async {
    final response = await dio.post(
      createConversationRoute,
      data: {
        'participantIds': participantIds,
        if (initialMessage != null) 'initialMessage': initialMessage,
      },
    );
    return Conversation.fromJson(response.data['data']);
  }

  /// 📩 Send a message (general or listing-based)
  Future<Message> sendMessage({
    required String recipientId,
    required String content,
    String? listingId,
  }) async {
    final response = await dio.post(
      sendMessageRoute,
      data: {
        'recipientId': recipientId,
        'content': content,
        if (listingId != null) 'listingId': listingId,
      },
    );
    return Message.fromJson(response.data['data']['message']);
  }

  /// 📩 Send a listing message (uses listing-specific endpoint)
  Future<Message> sendListingMessage({
    required String recipientId,
    required String content,
    required String listingId,
  }) async {
    final response = await dio.post(
      sendListingMessageRoute,
      data: {
        'recipientId': recipientId,
        'content': content,
        'listingId': listingId,
      },
    );
    return Message.fromJson(response.data['data']['message']);
  }

  /// 💬 Get messages in a conversation
  Future<List<Message>> getMessages(String conversationId) async {
    final response = await dio.get(getMessagesRoute(conversationId));
    final messages = response.data['messages'];
    return List<Message>.from(messages.map((json) => Message.fromJson(json)));
  }

  /// ❌ Delete a specific message
  Future<void> deleteMessage(String messageId) async {
    await dio.delete(deleteMessageRoute(messageId));
  }

  /// ❌ Delete a specific conversation
  Future<void> deleteConversation(String conversationId) async {
    await dio.delete(deleteConversationRoute(conversationId));
  }

  Future<Conversation?> createConversationWithUser(String userId) async {
  try {
    final response = await dio.post(
      createConversationRoute,
      data: {"receiverId": userId},
    );

    if (response.data['success']) {
      return Conversation.fromJson(response.data['data']);
    }
    return null;
  } catch (e) {
    print("Create conversation error: $e");
    return null;
  }
}
}
