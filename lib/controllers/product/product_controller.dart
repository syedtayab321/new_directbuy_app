import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../Models/filter_options_model.dart';
import '../../Models/product_model.dart';
import '../../repositories/products/product_repository.dart';

class ProductsController extends GetxController {
  final ProductRepository _repository = ProductRepository();

  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<FilterOptions> filterOptions = FilterOptions().obs;
  final RxString sortBy = 'name'.obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final int limit = 20;
  DocumentSnapshot? lastDocument;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      lastDocument = null; // Reset for fresh load
      final products = await _repository.getProducts(
        limit: limit,
        lastDocument: lastDocument,
      );
      allProducts.assignAll(products);
      if (products.isNotEmpty) {
        lastDocument = products.last.document;
      }
      _applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore.value || lastDocument == null) return;

    try {
      isLoadingMore(true);
      final products = await _repository.getProducts(
        limit: limit,
        lastDocument: lastDocument,
      );
      if (products.isNotEmpty) {
        allProducts.addAll(products);
        lastDocument = products.last.document;
        _applyFilters();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load more products');
    } finally {
      isLoadingMore(false);
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void updateFilters(FilterOptions newFilters) {
    filterOptions.value = newFilters;
    _applyFilters();
  }

  void updateSort(String newSort) {
    sortBy.value = newSort;
    _applyFilters();
  }

  void _applyFilters() {
    // Apply search
    var results = allProducts.where((product) {
      return product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          product.category.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();

    // Apply price filter
    if (filterOptions.value.minPrice != null) {
      results = results.where((p) => p.price >= filterOptions.value.minPrice!).toList();
    }
    if (filterOptions.value.maxPrice != null) {
      results = results.where((p) => p.price <= filterOptions.value.maxPrice!).toList();
    }

    // Apply cost price filter (if needed)
    if (filterOptions.value.minCostPrice != null) {
      results = results.where((p) => p.costPrice >= filterOptions.value.minCostPrice!).toList();
    }
    if (filterOptions.value.maxCostPrice != null) {
      results = results.where((p) => p.costPrice <= filterOptions.value.maxCostPrice!).toList();
    }

    // Apply category filter
    if (filterOptions.value.selectedCategories.isNotEmpty) {
      results = results.where((p) =>
          filterOptions.value.selectedCategories.contains(p.category)).toList();
    }

    // Apply stock filter
    if (filterOptions.value.inStockOnly) {
      results = results.where((p) => p.stock > 0).toList();
    }

    // Apply status filter
    if (filterOptions.value.statuses.isNotEmpty) {
      results = results.where((p) =>
          filterOptions.value.statuses.contains(p.status)).toList();
    }

    // Apply sorting
    switch (sortBy.value) {
      case 'price_low':
        results.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        results.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'cost_price_low':
        results.sort((a, b) => a.costPrice.compareTo(b.costPrice));
        break;
      case 'cost_price_high':
        results.sort((a, b) => b.costPrice.compareTo(a.costPrice));
        break;
      case 'stock_low':
        results.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case 'stock_high':
        results.sort((a, b) => b.stock.compareTo(a.stock));
        break;
      case 'newest':
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        results.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      default: // 'name' or 'name_desc'
        if (sortBy.value == 'name_desc') {
          results.sort((a, b) => b.name.compareTo(a.name));
        } else {
          results.sort((a, b) => a.name.compareTo(b.name));
        }
    }

    filteredProducts.assignAll(results);
  }

  void resetFilters() {
    searchQuery.value = '';
    filterOptions.value = FilterOptions();
    sortBy.value = 'name';
    _applyFilters();
  }

  // Helper to get all unique categories from products
  List<String> get allCategories {
    return allProducts.map((p) => p.category).toSet().toList();
  }

  // Helper to get all unique statuses from products
  List<String> get allStatuses {
    return allProducts.map((p) => p.status).toSet().toList();
  }
}