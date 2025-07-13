import 'package:get/get.dart';
import '../../Models/user_model.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../shared/logout_dialog.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  final AuthRepository _authRepository = Get.find();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  UserModel? get currentUser => _currentUser.value;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Auth status getters
  bool get isLoggedIn => _authRepository.isLoggedIn();
  String? get savedEmail => _authRepository.getSavedEmail();

  @override
  void onInit() {
    checkAuthStatus();
    super.onInit();
  }

  Future<void> checkAuthStatus() async {
    isLoading.value = true;
    try {
      if (_authRepository.isLoggedIn()) {
        _currentUser.value = await _authRepository.getCurrentUser();
      }
    } catch (e) {
      errorMessage.value = 'Error checking auth status: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _authRepository.login(email, password);
      if (user != null) {
        _currentUser.value = user;
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _authRepository.signUp(email, password, name);
      if (user != null) {
        _currentUser.value = user;
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepository.logout();
      _currentUser.value = null;
      Get.offAllNamed('/login'); // Navigate to login screen
    } catch (e) {
      errorMessage.value = 'Error logging out: ${e.toString()}';
      Get.snackbar(
        'Logout Failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to show logout confirmation dialog
  void showLogoutConfirmation() {
    Get.dialog(
      LogoutDialog(
        onLogout: () async {
          await logout();
        },
      ),
      barrierDismissible: true,
    );
  }
}