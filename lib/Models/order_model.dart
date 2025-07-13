import 'package:cloud_firestore/cloud_firestore.dart';
import '../shared/tracking_status.dart';

class OrderModel {
  final String id;
  final String userId;
  final DateTime orderDate;
  final double totalAmount;
  final String paymentMethod;
  final String shippingAddress;
  final List<OrderItem> items;
  final TrackingStatus status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.items,
    required this.status,
  });

  // Add copyWith method
  OrderModel copyWith({
    String? id,
    String? userId,
    DateTime? orderDate,
    double? totalAmount,
    String? paymentMethod,
    String? shippingAddress,
    List<OrderItem>? items,
    TrackingStatus? status,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      userId: map['userId'] as String,
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'] as String,
      shippingAddress: map['shippingAddress'] as String,
      items: (map['items'] as List<dynamic>).map((item) => OrderItem.fromMap(item as Map<String, dynamic>)).toList(),
      status: TrackingStatus.values.firstWhere(
            (e) => e.toString() == 'TrackingStatus.${map['status']}',
        orElse: () => TrackingStatus.placed,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'orderDate': Timestamp.fromDate(orderDate),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress,
      'items': items.map((item) => item.toMap()).toList(),
      'status': status.toString().split('.').last,
    };
  }
}

class OrderItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String? size;
  final String? color;

  OrderItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.size,
    this.color,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      size: map['size'] as String?,
      color: map['color'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }
}