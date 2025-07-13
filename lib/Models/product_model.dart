import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final double costPrice;
  final double price;
  final String images;
  final String status;
  final int stock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DocumentSnapshot? document;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.costPrice,
    required this.price,
    required this.images,
    required this.status,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
    this.document,
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> map, {DocumentSnapshot? document}) {
    return ProductModel(
      id: id,
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      costPrice: _parseDouble(map['costPrice']),
      price: _parseDouble(map['price']),
      images: map['images']?.toString() ?? '',
      status: map['status']?.toString() ?? 'draft',
      stock: _parseInt(map['stock']),
      createdAt: _parseTimestamp(map['createdAt']),
      updatedAt: _parseTimestamp(map['updatedAt']),
      document: document,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    try {
      if (timestamp == null) return DateTime.now();

      // Handle Firestore Timestamp
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      }

      // Handle DateTime directly
      if (timestamp is DateTime) {
        return timestamp;
      }

      // Handle ISO String format
      if (timestamp is String) {
        // Handle if it's already a parsed string with timezone
        if (timestamp.contains('T') && timestamp.endsWith('Z')) {
          return DateTime.parse(timestamp);
        }
        // Handle if it's a milliseconds string
        else if (RegExp(r'^\d+$').hasMatch(timestamp)) {
          return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
        }
      }

      // Handle if it's a Map (sometimes Firestore returns this in web)
      if (timestamp is Map && timestamp['_seconds'] != null) {
        return DateTime.fromMillisecondsSinceEpoch(
          (timestamp['_seconds'] as int) * 1000,
          isUtc: true,
        );
      }

      return DateTime.now();
    } catch (e) {
      print('Error parsing timestamp: $e');
      return DateTime.now();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'costPrice': costPrice,
      'price': price,
      'images': images,
      'status': status,
      'stock': stock,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    double? costPrice,
    double? price,
    String? images,
    String? status,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
    DocumentSnapshot? document,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      costPrice: costPrice ?? this.costPrice,
      price: price ?? this.price,
      images: images ?? this.images,
      status: status ?? this.status,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      document: document ?? this.document,
    );
  }
}