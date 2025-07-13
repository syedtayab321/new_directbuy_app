import 'package:get/get.dart';
import '../../Models/user_model.dart';
import '../../services/auth/auth_service.dart';
import '../../services/common/localstorage_service.dart';


class AuthRepository {
  final AuthService _authService = Get.find();
  final LocalStorageService _localStorage = Get.find();

  Future<UserModel?> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }

  Future<UserModel?> login(String email, String password) async {
    final user = await _authService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      await _localStorage.setString('user_email', email);
      await _localStorage.setBool('is_logged_in', true);
    }
    return user;
  }

  Future<UserModel?> signUp(
      String email, String password, String name) async {
    final user = await _authService.signUpWithEmailAndPassword(
        email, password, name);
    if (user != null) {
      await _localStorage.setString('user_email', email);
      await _localStorage.setBool('is_logged_in', true);
    }
    return user;
  }

  Future<void> logout() async {
    await _authService.signOut();
    await _localStorage.remove('is_logged_in');
    await _localStorage.remove('user_email');
  }

  bool isLoggedIn() {
    return _localStorage.getBool('is_logged_in') ?? false;
  }

  String? getSavedEmail() {
    return _localStorage.getString('user_email');
  }
}