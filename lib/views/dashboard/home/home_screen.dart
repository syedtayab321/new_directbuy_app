import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Features/layouts/responsive_layout.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../components/category/category_list.dart';
import '../../../components/products/product_grid.dart';
import '../../../controllers/home/home_controller.dart';
import '../../../features/Widgets/custom_search_bar.dart';
import '../../../utils/routes/routes.dart';


class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.find();
   HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text('DirectBuy', style: AppTextStyles.titleLarge(context)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                SearchBarWidget(),

                // Featured Products Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Products',
                        style: AppTextStyles.titleMedium(context),
                      ),
                      TextButton(
                        onPressed: (){
                          Get.toNamed(AppRoutes.products);
                        },
                        child: Text(
                          'View All',
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ProductGridWidget(products: controller.featuredProducts, isFeatured: true),
                SizedBox(height: 30,),
                // Categories Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Text(
                    'Categories',
                    style: AppTextStyles.titleMedium(context),
                  ),
                ),
                CategoryListWidget(),

                // Search Results (if any)
                if (controller.searchQuery.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Text(
                      'Search Results for "${controller.searchQuery}"',
                      style: AppTextStyles.titleMedium(context),
                    ),
                  ),
                if (controller.searchQuery.isNotEmpty)
                  ProductGridWidget(products: controller.products),
              ],
            ),
          );
        }),
      ),
    );
  }
}