import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Features/layouts/responsive_layout.dart';
import '../../Features/theme/app_colors.dart';
import '../../Features/styles/app_text_styles.dart';
import '../../controllers/common/bottom_nav_bar_controller.dart';

class BottomBarScreen extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  BottomBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Obx(() => Scaffold(
        body: controller.pages[controller.selectedIndex.value],
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
            BoxShadow(
            color: AppColors.grey300.withOpacity(0.5),
            blurRadius: 8.r,
            spreadRadius: 2.r,
            offset: Offset(0, -2.h),
            ),
            ],
        borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          backgroundColor: AppColors.white,
          onTap: controller.changeTabIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey500,
          selectedLabelStyle: AppTextStyles.labelSmall(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyles.labelSmall(context),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          iconSize: 5.w,
          selectedFontSize: 10.sp,
          unselectedFontSize: 10.sp,
          items: [
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.house,
                size: 5.w,
              ),
              activeIcon: FaIcon(
                FontAwesomeIcons.house,
                size: 5.w,
                color: AppColors.primary,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.shop,
                size: 5.w,
              ),
              activeIcon: FaIcon(
                FontAwesomeIcons.shop,
                size: 5.w,
                color: AppColors.primary,
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.calendarCheck,
                size: 5.w,
              ),
              activeIcon: FaIcon(
                FontAwesomeIcons.calendarCheck,
                size: 5.w,
                color: AppColors.primary,
              ),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.user,
                size: 5.w,
              ),
              activeIcon: FaIcon(
                FontAwesomeIcons.user,
                size: 5.w,
                color: AppColors.primary,
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    ),
    )),
    );
  }
}