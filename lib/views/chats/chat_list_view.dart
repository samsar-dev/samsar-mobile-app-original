import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/chat/chat_controller.dart';
import 'package:samsar/services/chat/chat_service.dart';
import 'package:samsar/views/chats/chat_view.dart';
import 'package:samsar/widgets/chat_card/chat_card.dart';
import 'package:samsar/widgets/custom_search_bar.dart/custom_search_bar.dart';
import 'package:dio/dio.dart';

class ChatListView extends StatelessWidget {
  ChatListView({super.key});

  final ChatController chatController = Get.put(
    ChatController(chatService: ChatService(Dio())),
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          "chats".tr,
          style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: whiteColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomSearchBar(),

            SizedBox(height: screenHeight * 0.02),

            // Reactive List of Conversations
            Expanded(
              child: Obx(() {
                if (chatController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final conversations = chatController.conversations;

                if (conversations.isEmpty) {
                  return Center(child: Text("no_conversations_yet".tr));
                }

                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conv = conversations[index];

                    final otherUser = conv.participants.firstWhere(
                      (user) => user.id != chatController.chatService.dio.options.headers['userId'], // adjust if needed
                      orElse: () => conv.participants.first,
                    );

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ChatView(conversation: conv));
                      },
                      child: ChatCard(
                        username: otherUser.username,
                        lastMessage: conv.recentMessage?.content ?? '',
                        time: conv.lastMessageAt?.toLocal().toString() ?? '',
                        unreadCount: 0, // Optional: add unread count logic
                        avatarUrl: otherUser.profilePicture ?? '',
                        onTap: () {
                          chatController.selectConversation(conv);
                          // Navigate to message screen if needed
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
