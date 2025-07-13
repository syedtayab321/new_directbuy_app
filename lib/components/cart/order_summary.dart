import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../controllers/cart/cart_controller.dart';

class OrderSummaryWidget extends StatelessWidget {
  final CartController controller = Get.find();
  OrderSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Order Summary Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Summary',
                  style: AppTextStyles.titleMedium(context),
                ),
                Text(
                  '${controller.cartItems.length} Items',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ],
            ),
            Divider(height: 14),

            // Subtotal
            _buildSummaryRow(
              context,
              'Subtotal',
              '\$${controller.subtotal.toStringAsFixed(2)}',
            ),
            SizedBox(height: 8),

            // Shipping
            _buildSummaryRow(
              context,
              'Shipping',
              '\$${controller.shippingFee.value.toStringAsFixed(2)}',
            ),
            SizedBox(height: 8),

            // Tax
            _buildSummaryRow(
              context,
              'Tax (${(controller.taxRate.value * 100).toInt()}%)',
              '\$${controller.tax.toStringAsFixed(2)}',
            ),
            Divider(height: 14),

            // Total
            _buildSummaryRow(
              context,
              'Total',
              '\$${controller.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
            SizedBox(height: 16),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.cartItems.isEmpty) {
                    Get.snackbar('Cart Empty', 'Add items to proceed');
                  } else {
                    Get.toNamed('/checkout');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Proceed to Checkout',
                  style: AppTextStyles.labelLarge(context).copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
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
              ? AppTextStyles.titleSmall(context)
              : AppTextStyles.bodyMedium(context),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.titleSmall(context).copyWith(
            fontWeight: FontWeight.bold,
          )
              : AppTextStyles.bodyMedium(context),
        ),
      ],
    );
  }
}