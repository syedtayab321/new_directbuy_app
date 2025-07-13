import 'package:get/get.dart';
import '../../Models/category_model.dart';
import '../../Models/product_model.dart';
import '../../repositories/home/home_repository.dart';


class HomeController extends GetxController {
  final HomeRepository _repository = HomeRepository();

  // Observables
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchInitialData();
    super.onInit();
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading(true);

      // Fetch featured products
      _repository.getFeaturedProducts().listen((products) {
        featuredProducts.assignAll(products);
      });

      // Fetch categories
      _repository.getCategories().listen((categories) {
        this.categories.assignAll(categories);
      });

      errorMessage('');
    } catch (e) {
      errorMessage('Failed to load data. Please try again.');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      products.clear();
    } else {
      _repository.searchProducts(query).listen((results) {
        products.assignAll(results);
      });
    }
  }
}