import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Features/layouts/responsive_layout.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../components/order/order_card.dart';
import '../../../components/order/order_shimmer.dart';
import '../../../controllers/order/order_controller.dart';
import '../../../utils/routes/routes.dart';


class OrdersScreen extends StatelessWidget {
  final OrderController controller = Get.find();
  OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Orders', style: AppTextStyles.titleLarge(context)),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return OrderShimmer();
          }

          if (controller.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 20, color: AppColors.grey400),
                  SizedBox(height: 16),
                  Text(
                    'No Orders Yet',
                    style: AppTextStyles.titleMedium(context),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your orders will appear here',
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.home),
                    child: Text('Continue Shopping'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => controller.fetchOrders(),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                final order = controller.orders[index];
                return OrderCard(order: order);
              },
            ),
          );
        }),
      ),
    );
  }
}