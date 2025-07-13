import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile/profile_controller.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Features/styles/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController controller = Get.find();
  ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.userProfile.value;
      if (user == null) return SizedBox();

      return Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
              FloatingActionButton.small(
                onPressed: controller.updateProfilePicture,
                child: Icon(Icons.camera_alt),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            user.name,
            style: AppTextStyles.titleLarge(context),
          ),
          Text(
            user.email,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.grey500,
            ),
          ),
          Text(
            'Member since ${user.joinedDate.year}',
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      );
    });
  }
}