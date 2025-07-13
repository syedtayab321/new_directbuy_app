import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Models/cart_items_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get user cart stream
  Stream<List<CartItemModel>> getCartItems() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('cart')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CartItemModel.fromMap(doc.data()))
        .toList());
  }

  // Add item to cart
  Future<void> addToCart(CartItemModel item) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('cart')
        .doc(item.productId)
        .set(item.toMap());
  }

  // Remove item from cart
  Future<void> removeFromCart(String productId) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  // Update item quantity
  Future<void> updateQuantity(String productId, int newQuantity) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('cart')
        .doc(productId)
        .update({'quantity': newQuantity});
  }

  // Clear entire cart
  Future<void> clearCart() async {
    final batch = _firestore.batch();
    final cartItems = await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('cart')
        .get();

    for (var doc in cartItems.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}