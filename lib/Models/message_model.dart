import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final bool read;
  final List<String> deletedFor;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
    required this.read,
    required this.deletedFor,
  });

  factory Message.fromMap(Map<String, dynamic> map, String id) {
    return Message(
      id: id,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      read: map['read'] ?? false,
      deletedFor: List<String>.from(map['deletedFor'] ?? []),
    );
  }
}