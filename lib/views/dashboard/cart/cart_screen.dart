import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Features/layouts/responsive_layout.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../../components/cart/cart_item_card.dart';
import '../../../components/cart/empty_cart.dart';
import '../../../components/cart/order_summary.dart';
import '../../../controllers/cart/cart_controller.dart';


class CartScreen extends StatelessWidget {
  final CartController controller = Get.find();
  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Cart', style: AppTextStyles.titleLarge(context)),
          centerTitle: true,
          actions: [
            if (controller.cartItems.isNotEmpty)
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () => _showClearCartDialog(context),
              ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.cartItems.isEmpty) {
            return EmptyCartWidget();
          }

          return Column(
            children: [
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.cartItems[index];
                    return CartItemCard(item: item);
                  },
                ),
              ),

              // Order Summary
              OrderSummaryWidget(),
            ],
          );
        }),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Clear Cart'),
        content: Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
            },
            child: Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}