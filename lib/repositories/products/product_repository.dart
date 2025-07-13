import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Models/filter_options_model.dart';
import '../../Models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get products with pagination and filtering support
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    DocumentSnapshot? lastDocument,
    FilterOptions? filters,
  }) async {
    try {
      Query query = _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      // Apply filters if provided
      if (filters != null) {
        if (filters.minPrice != null) {
          query = query.where('price', isGreaterThanOrEqualTo: filters.minPrice);
        }
        if (filters.maxPrice != null) {
          query = query.where('price', isLessThanOrEqualTo: filters.maxPrice);
        }
        if (filters.selectedCategories.isNotEmpty) {
          query = query.where('category', whereIn: filters.selectedCategories);
        }
        if (filters.inStockOnly) {
          query = query.where('stock', isGreaterThan: 0);
        }
        if (filters.statuses.isNotEmpty) {
          query = query.where('status', whereIn: filters.statuses);
        }
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final QuerySnapshot snapshot = await query.get();

      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>, document: doc))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Failed to load products: ${e.message}';
    } catch (e) {
      throw 'Failed to fetch products: $e';
    }
  }

  // Get featured products (first 4)
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('isFeatured', isEqualTo: true)
          .where('status', isEqualTo: 'published')
          .limit(4)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>, document: doc))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Failed to load featured products: ${e.message}';
    } catch (e) {
      throw 'Failed to fetch featured products: $e';
    }
  }

  // Search products by name or category (with pagination)
  Future<List<ProductModel>> searchProducts(
      String query, {
        int limit = 20,
        DocumentSnapshot? lastDocument,
        FilterOptions? filters,
      }) async {
    try {
      if (query.isEmpty) return [];

      // Base query for search
      Query searchQuery = _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .limit(limit);

      // Apply additional filters
      if (filters != null) {
        if (filters.minPrice != null) {
          searchQuery = searchQuery.where('price', isGreaterThanOrEqualTo: filters.minPrice);
        }
        if (filters.maxPrice != null) {
          searchQuery = searchQuery.where('price', isLessThanOrEqualTo: filters.maxPrice);
        }
        if (filters.selectedCategories.isNotEmpty) {
          searchQuery = searchQuery.where('category', whereIn: filters.selectedCategories);
        }
        if (filters.inStockOnly) {
          searchQuery = searchQuery.where('stock', isGreaterThan: 0);
        }
        if (filters.statuses.isNotEmpty) {
          searchQuery = searchQuery.where('status', whereIn: filters.statuses);
        }
      }

      if (lastDocument != null) {
        searchQuery = searchQuery.startAfterDocument(lastDocument);
      }

      final QuerySnapshot snapshot = await searchQuery.get();

      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>, document: doc))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Failed to search products: ${e.message}';
    } catch (e) {
      throw 'Search failed: $e';
    }
  }

  // Get products by category (with pagination and filtering)
  Future<List<ProductModel>> getProductsByCategory(
      String category, {
        int limit = 20,
        DocumentSnapshot? lastDocument,
        FilterOptions? filters,
      }) async {
    try {
      Query categoryQuery = _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      // Apply additional filters
      if (filters != null) {
        if (filters.minPrice != null) {
          categoryQuery = categoryQuery.where('price', isGreaterThanOrEqualTo: filters.minPrice);
        }
        if (filters.maxPrice != null) {
          categoryQuery = categoryQuery.where('price', isLessThanOrEqualTo: filters.maxPrice);
        }
        if (filters.inStockOnly) {
          categoryQuery = categoryQuery.where('stock', isGreaterThan: 0);
        }
        if (filters.statuses.isNotEmpty) {
          categoryQuery = categoryQuery.where('status', whereIn: filters.statuses);
        }
      }

      if (lastDocument != null) {
        categoryQuery = categoryQuery.startAfterDocument(lastDocument);
      }

      final QuerySnapshot snapshot = await categoryQuery.get();

      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>, document: doc))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Failed to load category products: ${e.message}';
    } catch (e) {
      throw 'Failed to fetch category products: $e';
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final DocumentSnapshot doc =
      await _firestore.collection('products').doc(productId).get();
      return doc.exists
          ? ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>, document: doc)
          : null;
    } on FirebaseException catch (e) {
      throw 'Failed to load product: ${e.message}';
    } catch (e) {
      throw 'Failed to fetch product details: $e';
    }
  }

  // Get similar products (same category)
  Future<List<ProductModel>> getSimilarProducts({
    required String productId,
    required String category,
    int limit = 4,
  }) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .where('status', isEqualTo: 'published')
          .where(FieldPath.documentId, isNotEqualTo: productId)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>, document: doc))
          .toList();
    } on FirebaseException catch (e) {
      throw 'Failed to load similar products: ${e.message}';
    } catch (e) {
      throw 'Failed to fetch similar products: $e';
    }
  }

  // Get on-sale products (where price < costPrice)
  Future<List<ProductModel>> getOnSaleProducts({int limit = 4}) async {
    try {
      // Note: Firestore doesn't support direct price comparisons in queries
      // So we need to filter client-side after fetching
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('status', isEqualTo: 'published')
          .limit(limit * 2) // Fetch extra to account for client-side filtering
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>, document: doc))
          .where((product) => product.price < product.costPrice)
          .take(limit)
          .toList();
    } on FirebaseException catch (e) {
      throw 'Failed to load on-sale products: ${e.message}';
    } catch (e) {
      throw 'Failed to fetch on-sale products: $e';
    }
  }

  // Get all unique categories
  Future<List<String>> getAllCategories() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('status', isEqualTo: 'published')
          .get();

      final categories = snapshot.docs
          .map((doc) => doc['category'] as String?)
          .where((category) => category != null)
          .toSet()
          .toList();

      return categories.cast<String>();
    } on FirebaseException catch (e) {
      throw 'Failed to load categories: ${e.message}';
    } catch (e) {
      throw 'Failed to fetch categories: $e';
    }
  }
}