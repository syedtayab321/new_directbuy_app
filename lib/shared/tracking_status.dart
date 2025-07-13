import 'package:flutter/material.dart';

enum TrackingStatus {
  placed('Order Placed', Icons.shopping_bag_outlined),
  confirmed('Confirmed', Icons.verified_outlined),
  processed('Processed', Icons.local_shipping_outlined),
  shipped('Shipped', Icons.delivery_dining),
  outForDelivery('Out for Delivery', Icons.directions_bike),
  delivered('Delivered', Icons.check_circle_outlined),
  cancelled('Cancelled', Icons.cancel_outlined);

  final String displayName;
  final IconData icon;

  const TrackingStatus(this.displayName, this.icon);
}