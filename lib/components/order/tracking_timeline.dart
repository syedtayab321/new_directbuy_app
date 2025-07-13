import 'package:flutter/material.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../Models/order_model.dart';
import '../../shared/tracking_status.dart';

class TrackingTimeline extends StatelessWidget {
  final OrderModel order;

  const TrackingTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Status',
              style: AppTextStyles.titleSmall(context),
            ),
            SizedBox(height: 10),
            ...TrackingStatus.values.map((status) {
              final isCompleted = status.index <= order.status.index;
              final isCurrent = status == order.status;

              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Icon
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? isCurrent
                            ? AppColors.primary
                            : Colors.green
                            : AppColors.grey300,
                      ),
                      child: Icon(
                        status.icon,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),

                    // Status Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status.displayName,
                            style: AppTextStyles.bodyMedium(context).copyWith(
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              color: isCurrent ? AppColors.primary : null,
                            ),
                          ),
                          if (isCurrent && _getEstimatedDate(status) != null) ...[
                            SizedBox(height: 4),
                            Text(
                              _getEstimatedDate(status)!,
                              style: AppTextStyles.bodySmall(context).copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Vertical Line
                    if (status != TrackingStatus.values.last)
                      Positioned(
                        left: 11,
                        top: 24,
                        child: Container(
                          width: 2,
                          height: 30,
                          color: isCompleted ? Colors.green : AppColors.grey300,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String? _getEstimatedDate(TrackingStatus status) {
    final orderDate = order.orderDate;
    switch (status) {
      case TrackingStatus.placed:
        return 'Placed on ${orderDate.day}/${orderDate.month}/${orderDate.year}';
      case TrackingStatus.confirmed:
        return 'Confirmed on ${orderDate.add(Duration(days: 1)).day}/${orderDate.month}/${orderDate.year}';
      case TrackingStatus.processed:
        return 'Processed on ${orderDate.add(Duration(days: 2)).day}/${orderDate.month}/${orderDate.year}';
      case TrackingStatus.shipped:
        return 'Shipped on ${orderDate.add(Duration(days: 3)).day}/${orderDate.month}/${orderDate.year}';
      case TrackingStatus.outForDelivery:
        return 'Out for delivery on ${orderDate.add(Duration(days: 4)).day}/${orderDate.month}/${orderDate.year}';
      case TrackingStatus.delivered:
        return 'Delivered on ${orderDate.add(Duration(days: 5)).day}/${orderDate.month}/${orderDate.year}';
      default:
        return null;
    }
  }
}