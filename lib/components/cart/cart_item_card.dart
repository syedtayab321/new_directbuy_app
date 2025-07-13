import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../Models/cart_items_model.dart';
import '../../controllers/cart/cart_controller.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final CartController controller = Get.find();

  CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.white,
      shadowColor: AppColors.primary.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image with decorative border
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.grey500,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: 12),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTextStyles.titleSmall(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4),

                  // Price with accent color
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Size and color chips
                  if (item.size != null || item.color != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (item.size != null)
                          _buildAttributeChip('Size: ${item.size}', context),
                        if (item.color != null)
                          _buildAttributeChip('Color: ${item.color}', context),
                      ],
                    ),
                ],
              ),
            ),

            // Quantity controls with decorative container
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Plus button
                  _buildQuantityButton(
                    icon: Icons.add,
                    onPressed: () => controller.updateQuantity(
                      item.productId,
                      item.quantity + 1,
                    ),
                    context: context,
                  ),

                  // Quantity display
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      item.quantity.toString(),
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  // Minus button
                  _buildQuantityButton(
                    icon: Icons.remove,
                    onPressed: () => controller.updateQuantity(
                      item.productId,
                      item.quantity - 1,
                    ),
                    context: context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return IconButton(
      icon: Icon(icon, size: 18),
      color: AppColors.primary,
      onPressed: onPressed,
      splashRadius: 20,
      constraints: BoxConstraints(minWidth: 36, minHeight: 36),
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildAttributeChip(String text, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall(
          context,
        ).copyWith(color: AppColors.grey600),
      ),
    );
  }
}
