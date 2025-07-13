import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app_project/controllers/auth/auth_controller.dart';
import '../../components/message/chat_input.dart';
import '../../components/message/message_bubble.dart';
import '../../controllers/message/message_controller.dart';


class ChatScreen extends StatelessWidget {
  final MessageController _controller = Get.find();
  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final conversationId = args['conversationId'];
    final otherUserId = args['otherUserId'];
    final currentUserId = AuthController.to.currentUser!.id;

    _controller.loadConversationMessages(conversationId, currentUserId!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with User $otherUserId'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                itemCount: _controller.messages.length,
                itemBuilder: (context, index) {
                  final message = _controller.messages[index];
                  return MessageBubble(
                    message: message,
                    isMe: message.senderId == currentUserId,
                  );
                },
              );
            }),
          ),
          ChatInput(
            onSend: (text) => _controller.sendMessage(
              conversationId: conversationId,
              senderId: currentUserId,
              text: text,
            ),
          ),
        ],
      ),
    );
  }
}