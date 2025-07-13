import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home/home_controller.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../Models/category_model.dart';
import '../../shared/empty_states.dart';

class CategoryListWidget extends StatelessWidget {
  final HomeController controller = Get.find();

  CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.categories.isEmpty) {
        return EmptyStateWidget(
          icon: Icons.category_outlined,
          message: 'No categories available',
          padding: const EdgeInsets.symmetric(vertical: 24),
        );
      }

      return SizedBox(
        height: 120, // Fixed height for better consistency
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return CategoryCard(category: category);
          },
        ),
      );
    });
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90, // Fixed width for better consistency
      margin: const EdgeInsets.only(right: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Add your onTap logic here
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Image
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey200,
                border: Border.all(
                  color: AppColors.grey300,
                  width: 1,
                ),
              ),
              child: ClipOval(
                child:Center(
                  child: Icon(
                    Icons.category,
                    size: 28,
                    color: AppColors.grey500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Category Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                category.name,
                style: AppTextStyles.labelSmall(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Center(
      child: Icon(
        Icons.category,
        size: 28,
        color: AppColors.grey500,
      ),
    );
  }
}