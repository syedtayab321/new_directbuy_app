import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/category_model.dart';
import '../../Models/product_model.dart';


class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all products
  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Fetch featured products (first 4)
  Stream<List<ProductModel>> getFeaturedProducts() {
    return _firestore
        .collection('products')
        .limit(4)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Fetch all categories
  Stream<List<CategoryModel>> getCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Search products by name
  Stream<List<ProductModel>> searchProducts(String query) {
    return _firestore
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '${query}z')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}