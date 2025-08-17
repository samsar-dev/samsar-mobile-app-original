import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/chat/chat_controller.dart';
import 'package:samsar/models/chat/conversation_model.dart';


class ChatView extends StatefulWidget {
  final Conversation conversation;

  const ChatView({super.key, required this.conversation});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController chatController = Get.find();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatController.selectConversation(widget.conversation);
  }

  @override
  Widget build(BuildContext context) {
    final userId = chatController.chatService.dio.options.headers['userId'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.conversation.participants
              .firstWhere((u) => u.id != userId)
              .username,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final messages = chatController.messages;
              if (messages.isEmpty) {
                return Center(child: Text("no_messages_yet".tr));
              }

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMine = msg.sender.id == userId;

                  return MessageBubble(
                    text: msg.content,
                    isMine: isMine,
                    timestamp: msg.createdAt?.toLocal(),
                    avatarUrl: msg.sender.profilePicture,
                  );
                },
              );
            }),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "type_a_message".tr,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Obx(() => chatController.isSending.value
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            final content = messageController.text.trim();
                            if (content.isNotEmpty) {
                              await chatController.sendMessage(
                                recipientId: widget.conversation.participants
                                    .firstWhere((u) => u.id != userId)
                                    .id,
                                content: content,
                              );
                              messageController.clear();
                            }
                          },
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMine;
  final DateTime? timestamp;
  final String? avatarUrl;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMine,
    this.timestamp,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMine && avatarUrl != null)
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(avatarUrl!),
              ),
            const SizedBox(width: 6),
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: isMine ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft:
                        isMine ? const Radius.circular(12) : Radius.zero,
                    bottomRight:
                        isMine ? Radius.zero : const Radius.circular(12),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isMine ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

