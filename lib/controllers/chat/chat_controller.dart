import 'package:get/get.dart';
import 'package:samsar/models/chat/conversation_model.dart';
import 'package:samsar/models/chat/message.dart';
import 'package:samsar/services/chat/chat_service.dart';

class ChatController extends GetxController {
  final ChatService chatService;

  ChatController({required this.chatService});

  // State
  var conversations = <Conversation>[].obs;
  var messages = <Message>[].obs;
  var isLoading = false.obs;
  var isSending = false.obs;

  Conversation? selectedConversation;

  // 🚀 Fetch all conversations
  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;
      final data = await chatService.getConversations();
      conversations.assignAll(data);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // 📩 Send a message (general or listing)
  Future<void> sendMessage({
    required String recipientId,
    required String content,
    String? listingId,
  }) async {
    try {
      isSending.value = true;
      final message = await chatService.sendMessage(
        recipientId: recipientId,
        content: content,
        listingId: listingId,
      );
      messages.add(message);
      await fetchConversations(); // Refresh conversation preview
    } catch (e) {
    } finally {
      isSending.value = false;
    }
  }

  // 💬 Fetch messages from a specific conversation
  Future<void> fetchMessages(String conversationId) async {
    try {
      isLoading.value = true;
      final data = await chatService.getMessages(conversationId);
      messages.assignAll(data);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // 📝 Create a new conversation
  Future<void> createConversation({
    required List<String> participantIds,
    String? initialMessage,
  }) async {
    try {
      isLoading.value = true;
      final conversation = await chatService.createConversation(
        participantIds: participantIds,
        initialMessage: initialMessage,
      );
      conversations.add(conversation);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // ❌ Delete a specific message
  Future<void> deleteMessage(String messageId) async {
    try {
      await chatService.deleteMessage(messageId);
      messages.removeWhere((m) => m.id == messageId);
    } catch (e) {
    }
  }

  // ❌ Delete a conversation
  Future<void> deleteConversation(String conversationId) async {
    try {
      await chatService.deleteConversation(conversationId);
      conversations.removeWhere((c) => c.id == conversationId);
    } catch (e) {
    }
  }

  // 📍 Select a conversation to open
  void selectConversation(Conversation conversation) {
    selectedConversation = conversation;
    fetchMessages(conversation.id);
  }

  void clearMessages() {
    messages.clear();
    selectedConversation = null;
  }

  Future<Conversation?> getOrCreateConversationWithUser(String userId) async {
    try {
      // Check if conversation already exists
      final existing = conversations.firstWhereOrNull(
        (conv) => conv.participants.any((user) => user.id == userId),
      );

      if (existing != null) return existing;

      // If not, create one
      final newConversation = await chatService.createConversationWithUser(
        userId,
      );
      if (newConversation != null) {
        conversations.insert(0, newConversation);
      }
      return newConversation;
    } catch (e) {
      return null;
    }
  }
}
