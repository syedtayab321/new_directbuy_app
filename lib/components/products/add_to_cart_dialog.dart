// widgets/product/add_to_cart_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product/product_dialog_controller.dart';

class AddToCartDialog extends StatelessWidget {
  final String productName;
  final int stock;
  final double price;
  final String image;
  final String productId;

  const AddToCartDialog({
    super.key,
    required this.productName,
    required this.stock,
    required this.price,
    required this.image,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDialogController());
    controller.resetQuantity(stock);

    return AlertDialog(
      title: const Text('Add to Cart'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(productName, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Obx(
                () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: controller.decrementQuantity,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${controller.selectedQuantity.value}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: controller.incrementQuantity,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Available: $stock',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // You can return the selected quantity here or handle it in the controller
            Get.back(result: controller.selectedQuantity.value);
          },
          child: const Text('Add to Cart'),
        ),
      ],
    );
  }
}