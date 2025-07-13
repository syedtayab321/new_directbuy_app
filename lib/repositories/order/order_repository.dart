import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Models/order_model.dart';
import '../../shared/tracking_status.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser?.uid ?? '';

  Stream<List<OrderModel>> getOrders() {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return OrderModel.fromMap(doc.id, doc.data());
        } catch (e) {
          throw Exception('Failed to parse order: $e');
        }
      }).toList();
    });
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (!doc.exists) return null;
      return OrderModel.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  Future<String> placeOrder(OrderModel order) async {
    try {
      final docRef = _firestore.collection('orders').doc();
      final orderData = order.toMap();
      await docRef.set(orderData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  Future<bool> updateOrderStatus({
    required String orderId,
    required TrackingStatus status,
  }) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<List<OrderModel>> getOrdersByStatus(TrackingStatus status) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: currentUserId)
          .where('status', isEqualTo: status.toString().split('.').last)
          .orderBy('orderDate', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to get orders by status: $e');
    }
  }
}