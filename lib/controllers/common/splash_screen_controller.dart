import 'package:get/get.dart';
import '../auth/auth_controller.dart';
import '../../utils/routes/routes.dart';

class SplashController extends GetxController {
  final RxBool isInitialized = false.obs;
  final RxBool isCheckingAuth = false.obs;
  final RxString errorMessage = ''.obs;

  final AuthController _authController = Get.find();

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      errorMessage.value = '';
      isCheckingAuth.value = true;

      // Simulate initialization delay
      await Future.delayed(const Duration(seconds: 2));

      // Check authentication status
      await _authController.checkAuthStatus();

      // Navigate based on auth status
      if (_authController.isLoggedIn) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }

    } catch (e) {
      errorMessage.value = 'Initialization failed. Please try again.';
      Get.log('Splash initialization error: $e', isError: true);
    } finally {
      isCheckingAuth.value = false;
    }
  }
}