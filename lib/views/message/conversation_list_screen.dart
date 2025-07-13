import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/message/message_controller.dart';
import 'chat_screen.dart';


class ConversationListScreen extends StatelessWidget {
  final MessageController _controller = Get.put(MessageController());
  ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Obx(() {
        if (_controller.conversations.isEmpty) {
          return Center(child: Text('No conversations yet'));
        }

        return ListView.builder(
          itemCount: _controller.conversations.length,
          itemBuilder: (context, index) {
            final conversation = _controller.conversations[index];
            final otherUserId = conversation.participants.firstWhere(
                  (id) => id != AuthController.to.currentUser?.id,
            );

            return ListTile(
              title: Text('User: $otherUserId'),
              subtitle: Text(conversation.lastMessage),
              trailing: conversation.unreadCount[AuthController.to.currentUser?.id]! > 0
                  ? CircleAvatar(
                radius: 10,
                child: Text(
                  conversation.unreadCount[AuthController.to.currentUser?.id].toString(),
                  style: TextStyle(fontSize: 12),
                ),
              )
                  : null,
              onTap: () {
                Get.to(() => ChatScreen(),
                  arguments: {
                    'conversationId': conversation.id,
                    'otherUserId': otherUserId,
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}