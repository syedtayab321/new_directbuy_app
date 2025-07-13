import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_app_project/components/products/sort_dropdown.dart';
import '../../controllers/product/product_controller.dart';
import 'filter_bottom_sheet.dart';


class SearchAndFilterBar extends StatelessWidget {
  final ProductsController controller = Get.find();
  SearchAndFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => controller.searchQuery.value = '',
              ) : SizedBox.shrink()),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: controller.searchProducts,
          ),
          SizedBox(height: 8.h),

          // Filter & Sort Row
          Row(
            children: [
              // Filter Button
              OutlinedButton.icon(
                icon: Icon(Icons.filter_alt_outlined),
                label: Text('Filters'),
                onPressed: () => _showFilterBottomSheet(context),
              ),
              SizedBox(width: 8.w),

              // Sort Dropdown
              Expanded(child: SortDropdown()),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(),
    );
  }
}