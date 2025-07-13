import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../../controllers/profile/profile_controller.dart';
import '../../../features/Widgets/custom_text_field.dart';



class EditProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.find();
  final TextEditingController textController = TextEditingController();
  final String field;
  final String initialValue;

  EditProfileScreen({
    super.key,
    required this.field,
    required this.initialValue,
  }) {
    textController.text = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit $field', style: AppTextStyles.titleLarge(context)),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => _saveChanges(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: CustomTextField(
          controller: textController,
          labelText: field,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _saveChanges(context),
        ),
      ),
    );
  }

  void _saveChanges(BuildContext context) {
    final newValue = textController.text.trim();
    if (newValue.isEmpty) {
      Get.snackbar('Error', '$field cannot be empty');
      return;
    }

    final updatedProfile = controller.userProfile.value?.copyWith(
      name: field == 'name' ? newValue : controller.userProfile.value?.name,
      email: field == 'email' ? newValue : controller.userProfile.value?.email,
      phone: field == 'phone' ? newValue : controller.userProfile.value?.phone,
    );

    if (updatedProfile != null) {
      controller.updateProfile(updatedProfile);
      Get.back();
    }
  }
}