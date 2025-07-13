import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app_project/components/products/product_card.dart';
import '../../Models/product_model.dart';
import '../../shared/empty_states.dart';

class ProductGridWidget extends StatelessWidget {
  final RxList<ProductModel> products;
  final bool isFeatured;

  const ProductGridWidget({
    super.key,
    required this.products,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (products.isEmpty) {
        return EmptyStateWidget(
          icon: Icons.shopping_bag_outlined,
          message: 'No products found',
        );
      }

      final displayProducts = isFeatured
          ? (products.length > 4 ? products.sublist(0, 4) : products)
          : products;

      return SizedBox(
        height: MediaQuery.of(context).size.height*0.40, // Adjust based on your ProductCard height
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: displayProducts.length,
          itemBuilder: (context, index) {
            final product = displayProducts[index];
            return Container(
              width: 250,
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.only(right: 12),
              child: ProductCard(product: product),
            );
          },
        ),
      );
    });
  }
}