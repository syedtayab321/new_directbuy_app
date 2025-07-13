import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Features/layouts/responsive_layout.dart';
import '../../Features/theme/app_colors.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../features/Widgets/custom_elevated_button.dart';
import '../../features/Widgets/custom_text_field.dart';
import '../../features/Widgets/custom_text_widget.dart';
import '../../utils/routes/routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static const String routeName = '/login';
  final AuthController _authController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Pre-fill email if saved
    final savedEmail = _authController.savedEmail;
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _emailController.text = savedEmail;
    }

    return ResponsiveLayout(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                CustomTextWidget(
                  'Welcome Back!',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 8),
                CustomTextWidget(
                  'Login to your account to continue',
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Get.toNamed(AppRoutes.forgotPassword); // Add this route to your AppRoutes
                    },
                    child: const CustomTextWidget(
                      'Forgot Password?',
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() => CustomElevatedButton(
                  onPressed: _authController.isLoading.value
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await _authController.login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (success) {
                        // Clear navigation stack and go to home
                        Get.offAllNamed(AppRoutes.home);
                      } else {
                        // Show error message if login fails
                        if (_authController.errorMessage.isNotEmpty) {
                          Get.snackbar(
                            'Error',
                            _authController.errorMessage.value,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.errorContainer,
                            colorText: AppColors.onErrorContainer,
                          );
                        }
                      }
                    }
                  },
                  text: 'Login',
                  isLoading: _authController.isLoading.value,
                )),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomTextWidget(
                      'Don\'t have an account? ',
                      color: AppColors.onSurfaceVariant,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offAndToNamed(AppRoutes.signup); // Replace current screen with signup
                      },
                      child: const CustomTextWidget(
                        'Sign Up',
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}