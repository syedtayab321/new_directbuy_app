import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Models/filter_options_model.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/product/product_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  final ProductsController productController = Get.find();
  final HomeController homeController = Get.find(); // Add this line
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 1000.0.obs;
  final RxDouble minRating = 0.0.obs;
  final RxList<String> selectedCategories = <String>[].obs;
  final RxBool inStockOnly = false.obs;

  FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize with current filters
    minPrice.value = productController.filterOptions.value.minPrice ?? 0.0;
    maxPrice.value = productController.filterOptions.value.maxPrice ?? 1000.0;
    minRating.value = productController.filterOptions.value.minRating ?? 0.0;
    selectedCategories.assignAll(productController.filterOptions.value.selectedCategories);
    inStockOnly.value = productController.filterOptions.value.inStockOnly;

    return Container(
      padding: EdgeInsets.all(16.w),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Text('Filter Products', style: Get.textTheme.titleLarge),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  Text('Price Range', style: Get.textTheme.titleMedium),
                  Obx(() => RangeSlider(
                    values: RangeValues(minPrice.value, maxPrice.value),
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    labels: RangeLabels(
                      '\$${minPrice.value.toInt()}',
                      '\$${maxPrice.value.toInt()}',
                    ),
                    onChanged: (values) {
                      minPrice.value = values.start;
                      maxPrice.value = values.end;
                    },
                  )),
                  SizedBox(height: 16.h),

                  // Minimum Rating
                  Text('Minimum Rating', style: Get.textTheme.titleMedium),
                  Obx(() => Slider(
                    value: minRating.value,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: minRating.value.toStringAsFixed(1),
                    onChanged: (value) => minRating.value = value,
                  )),
                  SizedBox(height: 16.h),

                  // Categories
                  Text('Categories', style: Get.textTheme.titleMedium),
                  Obx(() {
                    if (homeController.categories.isEmpty) {
                      return Text('No categories available');
                    }

                    return Wrap(
                      spacing: 8.w,
                      children: homeController.categories
                          .map((category) => Obx(() => FilterChip(
                        label: Text(category.name),
                        selected: selectedCategories.contains(category.name),
                        onSelected: (selected) {
                          if (selected) {
                            selectedCategories.add(category.name);
                          } else {
                            selectedCategories.remove(category.name);
                          }
                        },
                      )))
                          .toList(),
                    );
                  }),
                  SizedBox(height: 16.h),

                  // In Stock Only
                  Obx(() => SwitchListTile(
                    title: Text('In Stock Only'),
                    value: inStockOnly.value,
                    onChanged: (value) => inStockOnly.value = value,
                  )),
                ],
              ),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => productController.resetFilters(),
                child: Text('Reset All'),
              ),
              ElevatedButton(
                onPressed: () {
                  productController.updateFilters(FilterOptions(
                    minPrice: minPrice.value,
                    maxPrice: maxPrice.value,
                    minRating: minRating.value,
                    selectedCategories: selectedCategories.toList(),
                    inStockOnly: inStockOnly.value,
                  ));
                  Get.back();
                },
                child: Text('Apply Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}