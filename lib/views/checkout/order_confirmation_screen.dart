import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../Models/order_model.dart';
import '../../shared/tracking_status.dart';
import '../../utils/routes/routes.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderModel? order;

  const OrderConfirmationScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    // Safe defaults if order is null
    final orderId = order?.id ?? 'N/A';
    final orderDate = order?.orderDate ?? DateTime.now();
    final totalAmount = order?.totalAmount ?? 0.0;
    final paymentMethod = order?.paymentMethod ?? 'Not specified';
    final status = order?.status ?? TrackingStatus.placed;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 80.r,
              ),
              SizedBox(height: 14),

              // Success Message
              Text(
                'Order Placed Successfully!',
                style: AppTextStyles.titleLarge(context)?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),

              // Order Number with safe substring
              Text(
                orderId.isEmpty
                    ? 'Order Processing...'
                    : 'Order #${orderId.length >= 8 ? orderId.substring(0, 8).toUpperCase() : orderId.toUpperCase()}',
                style: AppTextStyles.bodyMedium(context)?.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              SizedBox(height: 24.h),

              // Order Summary Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildOrderDetailRow(
                        context,
                        'Date',
                        '${orderDate.day}/${orderDate.month}/${orderDate.year}',
                      ),
                      SizedBox(height: 8),
                      _buildOrderDetailRow(
                        context,
                        'Total',
                        '\$${totalAmount.toStringAsFixed(2)}',
                      ),
                      SizedBox(height: 8),
                      _buildOrderDetailRow(
                        context,
                        'Payment',
                        paymentMethod,
                      ),
                      SizedBox(height: 8),
                      _buildOrderDetailRow(
                        context,
                        'Status',
                        status.toString().split('.').last,
                        isStatus: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Continue Shopping Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.home),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    'Continue Shopping',
                    style: AppTextStyles.labelLarge(context).copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(
      BuildContext context,
      String label,
      String value, {
        bool isStatus = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: AppColors.grey600,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium(context).copyWith(
            fontWeight: FontWeight.w500,
            color: isStatus ? _getStatusColor(value) : AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return AppColors.primary;
      case 'confirmed':
        return AppColors.success;
      case 'shipped':
        return AppColors.info;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.grey600;
    }
  }
}