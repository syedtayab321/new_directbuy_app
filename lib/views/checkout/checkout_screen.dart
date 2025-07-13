import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../Models/order_model.dart';
import '../../controllers/cart/cart_controller.dart';
import '../../controllers/order/order_controller.dart';
import '../../shared/tracking_status.dart';
import '../../utils/routes/routes.dart';

class CheckoutScreen extends StatelessWidget {
  final CartController cartController = Get.find();
  final OrderController orderController = Get.put(OrderController());
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _paymentMethod = 'Cash on Delivery'.obs;

  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: AppTextStyles.titleLarge(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address Section
            _buildSectionTitle('Shipping Address'),
            SizedBox(height: 8),
            _buildAddressForm(context),
            SizedBox(height: 24),

            // Payment Method Section
            _buildSectionTitle('Payment Method'),
            SizedBox(height: 8),
            _buildPaymentMethodSelector(context),
            SizedBox(height: 24),

            // Order Summary Section
            _buildSectionTitle('Order Summary'),
            SizedBox(height: 8),
            _buildOrderItemsList(context),
            SizedBox(height: 16),

            // Order Total Summary
            _buildOrderTotalSummary(context),
            SizedBox(height: 24),

            // Place Order Button
            _buildPlaceOrderButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium(Get.context!).copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildAddressForm(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _addressController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your complete shipping address',
              border: InputBorder.none,
              hintStyle: AppTextStyles.bodyMedium(context).copyWith(
                color: AppColors.grey400,
              ),
            ),
            style: AppTextStyles.bodyMedium(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your shipping address';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => RadioListTile<String>(
              title: Text(
                'Cash on Delivery',
                style: AppTextStyles.bodyMedium(context),
              ),
              value: 'Cash on Delivery',
              groupValue: _paymentMethod.value,
              onChanged: (value) => _paymentMethod.value = value!,
              contentPadding: EdgeInsets.zero,
            )),
            Divider(height: 1),
            Obx(() => RadioListTile<String>(
              title: Text(
                'Bank Transfer',
                style: AppTextStyles.bodyMedium(context),
              ),
              value: 'Bank Transfer',
              groupValue: _paymentMethod.value,
              onChanged: (value) => _paymentMethod.value = value!,
              contentPadding: EdgeInsets.zero,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsList(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            ...cartController.cartItems.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.grey200,
                        child: Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        if (item.size != null) Text(
                          'Size: ${item.size}',
                          style: AppTextStyles.bodySmall(context),
                        ),
                        if (item.color != null) Text(
                          'Color: ${item.color}',
                          style: AppTextStyles.bodySmall(context),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Qty: ${item.quantity}',
                          style: AppTextStyles.bodySmall(context),
                        ),
                      ],
                    ),
                  ),

                  // Product Price
                  Text(
                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTotalSummary(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Subtotal
            _buildSummaryRow(
              context,
              'Subtotal',
              '\$${cartController.subtotal.toStringAsFixed(2)}',
            ),
            SizedBox(height: 8),

            // Shipping
            _buildSummaryRow(
              context,
              'Shipping',
              '\$${cartController.shippingFee.value.toStringAsFixed(2)}',
            ),
            SizedBox(height: 8),

            // Tax
            _buildSummaryRow(
              context,
              'Tax (${(cartController.taxRate.value * 100).toInt()}%)',
              '\$${cartController.tax.toStringAsFixed(2)}',
            ),
            Divider(height: 16),

            // Total
            _buildSummaryRow(
              context,
              'Total',
              '\$${cartController.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      BuildContext context,
      String label,
      String value, {
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.titleSmall(context).copyWith(
            fontWeight: FontWeight.w600,
          )
              : AppTextStyles.bodyMedium(context),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.titleSmall(context).copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          )
              : AppTextStyles.bodyMedium(context),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return Obx(() {
      final isLoading = orderController.isLoading.value;
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : () => _placeOrder(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          ),
          child: isLoading
              ? CircularProgressIndicator(
            color: AppColors.white,
            strokeWidth: 2,
          )
              : Text(
            'Place Order',
            style: AppTextStyles.labelLarge(context).copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }

  void _placeOrder(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Create order items from cart items
      final orderItems = cartController.cartItems.map((item) => OrderItem(
        productId: item.productId,
        name: item.name,
        imageUrl: item.image,
        price: item.price,
        quantity: item.quantity,
        size: item.size,
        color: item.color,
      )).toList();

      // Create order model
      final order = OrderModel(
        id: '', // Will be generated by Firestore
        userId: FirebaseAuth.instance.currentUser!.uid,
        orderDate: DateTime.now(),
        totalAmount: cartController.total,
        paymentMethod: _paymentMethod.value,
        shippingAddress: _addressController.text,
        items: orderItems,
        status: TrackingStatus.placed, // Default status
      );

      // Place order
      await orderController.repository.placeOrder(order);

      // Clear cart
      cartController.clearCart();

      // Show success message
      Get.offAllNamed(AppRoutes.orderConfirmation, arguments: order);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to place order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    }
  }
}