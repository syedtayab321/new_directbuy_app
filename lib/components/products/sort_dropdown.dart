import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product/product_controller.dart';

class SortDropdown extends StatelessWidget {
  final ProductsController controller = Get.find();
  final Map<String, String> sortOptions = {
    'name': 'Name (A-Z)',
    'price_low': 'Price (Low to High)',
    'price_high': 'Price (High to Low)',
    'rating': 'Rating',
    'newest': 'Newest',
  };
  SortDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.sortBy.value,
      decoration: InputDecoration(
        labelText: 'Sort By',
        border: OutlineInputBorder(),
      ),
      items: sortOptions.entries
          .map((entry) => DropdownMenuItem(
        value: entry.key,
        child: Text(entry.value),
      ))
          .toList(),
      onChanged: (value) => controller.updateSort(value!),
    ));
  }
}