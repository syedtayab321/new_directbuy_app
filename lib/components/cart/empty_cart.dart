import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Features/styles/app_text_styles.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80.w,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text(
            'Your Cart is Empty',
            style: AppTextStyles.titleMedium(context),
          ),
          SizedBox(height: 8.h),
          Text(
            'Browse products and add items to get started',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.grey500,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/home'),
            child: Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}