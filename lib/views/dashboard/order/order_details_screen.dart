import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Features/layouts/responsive_layout.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Models/order_model.dart';
import '../../../components/order/invoice_button.dart';
import '../../../components/order/order_card.dart';
import '../../../components/order/tracking_timeline.dart';
import '../../../controllers/order/order_controller.dart';


class OrderDetailScreen extends StatelessWidget {
  final OrderController controller = Get.find();
  final String orderId;

  OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderModel?>(
      future: controller.getOrderDetails(orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ResponsiveLayout(
            child: Scaffold(
              appBar: AppBar(),
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return ResponsiveLayout(
            child: Scaffold(
              appBar: AppBar(),
              body: Center(child: Text('Order not found')),
            ),
          );
        }

        final order = snapshot.data!;

        return ResponsiveLayout(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Order Details', style: AppTextStyles.titleLarge(context)),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {}, // Add share functionality
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Order Summary Card
                  OrderCard(order: order),

                  // Tracking Timeline
                  TrackingTimeline(order: order),

                  // Order Items
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Items',
                          style: AppTextStyles.titleSmall(context),
                        ),
                        SizedBox(height: 10),
                        ...order.items.map((item) => Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(
                                  item.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 60,
                                    height: 60,
                                    color: AppColors.grey200,
                                    child: Icon(Icons.image_not_supported),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: AppTextStyles.bodyMedium(context),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '\$${item.price.toStringAsFixed(2)} x ${item.quantity}',
                                      style: AppTextStyles.bodySmall(context),
                                    ),
                                    if (item.size != null || item.color != null) ...[
                                      SizedBox(height: 4),
                                      Text(
                                        '${item.size ?? ''} ${item.color ?? ''}',
                                        style: AppTextStyles.bodySmall(context).copyWith(
                                          color: AppColors.grey500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Text(
                                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                style: AppTextStyles.bodyMedium(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),

                  // Invoice Button
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: InvoiceButton(order: order),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}