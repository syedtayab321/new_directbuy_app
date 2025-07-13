import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Features/layouts/responsive_layout.dart';
import '../../Features/styles/app_text_styles.dart';
import '../../components/products/product_card.dart';
import '../../components/products/search_&_filter_bar.dart';
import '../../controllers/product/product_controller.dart';
import '../../shared/empty_states.dart';

class ProductsScreen extends StatelessWidget {
  final ProductsController controller = Get.put(ProductsController());

  ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'All Products',
            style: AppTextStyles.titleLarge(context).copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(onPressed: (){Get.back();},icon: Icon(Icons.arrow_back_ios,color: Colors.black54,)),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue[600],
              ),
            );
          }

          return Column(
            children: [
              // Search and Filter Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: SearchAndFilterBar(),
              ),

              // Results Count and Reset
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.filteredProducts.length} Products Found',
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Obx(() => controller.filteredProducts.isEmpty
                        ? SizedBox()
                        : TextButton(
                      onPressed: controller.resetFilters,
                      child: Text(
                        'Reset Filters',
                        style: AppTextStyles.bodySmall(context).copyWith(
                          color: Colors.blue[600],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              SizedBox(height: 8),

              // Products Grid
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!controller.isLoadingMore.value &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      controller.loadMoreProducts();
                    }
                    return false;
                  },
                  child: controller.filteredProducts.isEmpty
                      ? EmptyStateWidget(
                    icon: Icons.search_off,
                    message: 'No products match your filters',
                    actionText: 'Reset Filters',
                    onAction: controller.resetFilters,
                  )
                      : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: controller.filteredProducts[index],
                      );
                    },
                  ),
                ),
              ),

              // Loading More Indicator
              Obx(() => controller.isLoadingMore.value
                  ? Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  color: Colors.blue[600],
                ),
              )
                  : SizedBox(height: 8)),
            ],
          );
        }),
      ),
    );
  }
}