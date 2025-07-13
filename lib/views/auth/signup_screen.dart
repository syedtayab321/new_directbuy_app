import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Features/layouts/responsive_layout.dart';
import '../../Features/theme/app_colors.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../features/Widgets/custom_elevated_button.dart';
import '../../features/Widgets/custom_text_field.dart';
import '../../features/Widgets/custom_text_widget.dart';
import '../../utils/routes/routes.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final AuthController _authController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                const CustomTextWidget(
                  'Create Account',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 8),
                const CustomTextWidget(
                  'Fill your details to create an account',
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
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
                const SizedBox(height: 24),
                Obx(() => CustomElevatedButton(
                  onPressed: _authController.isLoading.value
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await _authController.signUp(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        _nameController.text.trim(),
                      );
                      if (!success && _authController.errorMessage.isNotEmpty) {
                        Get.snackbar(
                          'Error',
                          _authController.errorMessage.value,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.errorContainer,
                          colorText: AppColors.onErrorContainer,
                        );
                      }
                    }
                  },
                  text: 'Sign Up',
                  isLoading: _authController.isLoading.value,
                )),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomTextWidget(
                      'Already have an account? ',
                      color: AppColors.onSurfaceVariant,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.login);
                      },
                      child: const CustomTextWidget(
                        'Login',
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