import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../features/widgets/custom_text_widget.dart';
import '../../features/layouts/responsive_layout.dart';
import '../../features/styles/app_text_styles.dart';
import '../../features/theme/app_colors.dart';
import '../../controllers/common/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController()); // Initialize controller

    return ResponsiveLayout(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.primary,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo/icon
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 60.w,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // App name
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Direct',
                          style: AppTextStyles.headlineLarge(context).copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: 'Buy',
                          style: AppTextStyles.headlineLarge(context).copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Tagline
                  CustomTextWidget(
                    'Shop Smarter, Not Harder',
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: AppColors.white.withOpacity(0.8),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // Loading state
                  Obx(() {
                    final controller = Get.find<SplashController>();
                    if (controller.errorMessage.isNotEmpty) {
                      return Column(
                        children: [
                          CustomTextWidget(
                            controller.errorMessage.value,
                            style: AppTextStyles.bodySmall(context).copyWith(
                              color: AppColors.errorContainer,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: controller.initializeApp,
                            child: const Text('Retry'),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        CustomTextWidget(
                          'Initializing app...',
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: AppColors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: 200.w,
                          child: LinearProgressIndicator(
                            backgroundColor: AppColors.white.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                            minHeight: 4.h,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            // Footer
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: Center(
                child: CustomTextWidget(
                  '© ${DateTime.now().year} DirectBuy. All rights reserved',
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: AppColors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}