// controllers/product/product_dialog_controller.dart
import 'package:get/get.dart';

class ProductDialogController extends GetxController {
  var selectedQuantity = 1.obs;
  var maxQuantity = 1.obs;

  void resetQuantity(int stock) {
    selectedQuantity.value = 1;
    maxQuantity.value = stock;
  }

  void incrementQuantity() {
    if (selectedQuantity.value < maxQuantity.value) {
      selectedQuantity.value++;
    }
  }

  void decrementQuantity() {
    if (selectedQuantity.value > 1) {
      selectedQuantity.value--;
    }
  }
}