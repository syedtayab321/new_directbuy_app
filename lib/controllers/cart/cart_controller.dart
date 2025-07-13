import 'package:get/get.dart';

import '../../Models/cart_items_model.dart';
import '../../repositories/common/cart_repository.dart';

class CartController extends GetxController {
  final CartRepository _repository = CartRepository();
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxDouble shippingFee = 5.99.obs;
  final RxDouble taxRate = 0.08.obs; // 8% tax

  @override
  void onInit() {
    fetchCartItems();
    super.onInit();
  }

  // Fetch cart items from Firebase
  void fetchCartItems() {
    isLoading(true);
    _repository.getCartItems().listen((items) {
      cartItems.assignAll(items);
      isLoading(false);
    });
  }

  // Add item to cart
  Future<void> addToCart(CartItemModel item) async {
    try {
      final existingItemIndex = cartItems.indexWhere(
            (i) => i.productId == item.productId && i.size == item.size && i.color == item.color,
      );

      if (existingItemIndex >= 0) {
        // Item exists, update quantity
        final newQuantity = cartItems[existingItemIndex].quantity + item.quantity;
        await _repository.updateQuantity(item.productId, newQuantity);
      } else {
        // New item, add to cart
        await _repository.addToCart(item);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item to cart');
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String productId) async {
    try {
      await _repository.removeFromCart(productId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove item from cart');
    }
  }

  // Update item quantity
  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      if (quantity > 0) {
        await _repository.updateQuantity(productId, quantity);
      } else {
        await removeFromCart(productId);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity');
    }
  }

  // Calculate subtotal
  double get subtotal => cartItems.fold(
    0,
        (sum, item) => sum + item.totalPrice,
  );

  // Calculate tax
  double get tax => subtotal * taxRate.value;

  // Calculate total
  double get total => subtotal + tax + shippingFee.value;

  // Clear cart
  Future<void> clearCart() async {
    try {
      await _repository.clearCart();
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear cart');
    }
  }
}