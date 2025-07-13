import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../Models/conversation_model.dart';
import '../../Models/message_model.dart';
import '../../repositories/message/message_repository.dart';
import '../auth/auth_controller.dart';

class MessageController extends GetxController {
  final MessageRepository _repository = MessageRepository();

  final RxList<Conversation> conversations = <Conversation>[].obs;
  final RxList<Message> messages = <Message>[].obs;
  final RxString currentConversationId = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final userId = Get.find<AuthController>().currentUser?.id ?? '';
    if (userId.isNotEmpty) {
      loadUserConversations(userId);
    }
  }

  void loadUserConversations(String userId) {
    _repository.getUserConversations(userId).listen((conversationsList) {
      conversations.value = conversationsList;
    });
  }

  void loadConversationMessages(String conversationId, String userId) {
    currentConversationId.value = conversationId;
    _repository.getConversationMessages(conversationId, userId).listen((messagesList) {
      messages.value = messagesList;
      if (messagesList.isNotEmpty) {
        _repository.markMessagesAsRead(conversationId, userId);
      }
    });
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    isLoading.value = true;
    try {
      await _repository.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        text: text,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startConversation(String currentUserId, String otherUserId) async {
    isLoading.value = true;
    try {
      final conversationId = await _repository.getOrCreateConversation(
        currentUserId,
        otherUserId,
      );
      currentConversationId.value = conversationId;
      loadConversationMessages(conversationId, currentUserId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to start conversation');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
    required String userId,
  }) async {
    try {
      await _repository.deleteMessage(
        conversationId: conversationId,
        messageId: messageId,
        userId: userId,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete message');
    }
  }
}