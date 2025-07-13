import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/conversation_model.dart';
import '../../Models/message_model.dart';

class MessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getConversationId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return sortedIds.join('_');
  }

  Future<String> getOrCreateConversation(String currentUserId, String otherUserId) async {
    final conversationId = _getConversationId(currentUserId, otherUserId);
    final conversationRef = _firestore.collection('conversations').doc(conversationId);

    final conversationSnap = await conversationRef.get();

    if (!conversationSnap.exists) {
      await conversationRef.set({
        'participants': [currentUserId, otherUserId],
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
        'unreadCount': {
          currentUserId: 0,
          otherUserId: 0,
        },
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    }

    return conversationId;
  }

  Future<String> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final messagesRef = _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');

    final conversationRef = _firestore.collection('conversations').doc(conversationId);

    final otherParticipant = _getOtherParticipant(conversationId, senderId);

    final messageRef = messagesRef.doc();

    await _firestore.runTransaction((transaction) async {
      transaction.set(messageRef, {
        'senderId': senderId,
        'text': text,
        'createdAt': Timestamp.now(),
        'read': false,
        'deletedFor': [],
      });

      transaction.update(conversationRef, {
        'lastMessage': text,
        'lastMessageTime': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'unreadCount.$senderId': 0,
        'unreadCount.$otherParticipant': FieldValue.increment(1),
      });
    });

    return messageRef.id;
  }

  String _getOtherParticipant(String conversationId, String currentUserId) {
    final participants = conversationId.split('_');
    return participants.firstWhere((id) => id != currentUserId);
  }

  Stream<List<Conversation>> getUserConversations(String userId) {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Conversation.fromMap({'id': doc.id, ...doc.data()}))
        .toList());
  }

  Stream<List<Message>> getConversationMessages(String conversationId, String userId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .where((doc) => !(doc.data()['deletedFor'] as List).contains(userId))
        .map((doc) => Message.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<bool> markMessagesAsRead(String conversationId, String userId) async {
    try {
      final messagesRef = _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages');

      final conversationRef = _firestore.collection('conversations').doc(conversationId);

      final unreadMessages = await messagesRef
          .where('read', isEqualTo: false)
          .where('senderId', isNotEqualTo: userId)
          .get();

      final batch = _firestore.batch();

      for (final doc in unreadMessages.docs) {
        batch.update(doc.reference, {'read': true});
      }

      batch.update(conversationRef, {
        'unreadCount.$userId': 0,
        'updatedAt': Timestamp.now(),
      });

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMessage({
    required String conversationId,
    required String messageId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageId)
          .update({
        'deletedFor': FieldValue.arrayUnion([userId]),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}