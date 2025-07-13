import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/cart/cart_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/order/order_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../repositories/common/cart_repository.dart';
import '../../repositories/home/home_repository.dart';
import '../../repositories/order/order_repository.dart';
import '../../repositories/profile/profile_repository.dart';
import '../../services/auth/auth_service.dart';
import '../../services/common/localstorage_service.dart';


class DependencyInjection {
  static Future<void> init() async {
    // Initialize SharedPreferences
    await Get.putAsync(() => LocalStorageService().init());

    // Initialize Firebase Services
    Get.lazyPut(() => FirebaseAuth.instance, fenix: true);
    Get.lazyPut(() => FirebaseFirestore.instance, fenix: true);

    // Initialize Auth Layer
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => AuthRepository(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);

    Get.lazyPut(()=> HomeRepository(), fenix: true);
    Get.lazyPut(()=> HomeController(), fenix: true);

    Get.lazyPut(()=> CartRepository(), fenix: true);
    Get.lazyPut(()=> CartController(), fenix: true);

    Get.lazyPut(()=> OrderController(), fenix: true);
    Get.lazyPut(()=> OrderRepository(), fenix: true);

    Get.lazyPut(()=> ProfileController(), fenix: true);
    Get.lazyPut(()=> ProfileRepository(), fenix: true);

    // Add other controllers here as needed
    // Get.lazyPut(() => OtherController(), fenix: true);
  }
}