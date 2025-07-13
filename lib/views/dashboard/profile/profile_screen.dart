import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Features/layouts/responsive_layout.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../../components/profile/address_card.dart';
import '../../../components/profile/editable_fields.dart';
import '../../../components/profile/profile_header.dart';
import '../../../components/profile/settings_option.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/profile/profile_controller.dart';
import '../../../shared/logout_dialog.dart';
import '../../../utils/routes/routes.dart';
import 'address_management_screen.dart';
import 'edit_profile_screen.dart';


class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.find();
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Profile', style: AppTextStyles.titleLarge(context)),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          final user = controller.userProfile.value;
          if (user == null) {
            return Center(child: Text('Failed to load profile'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Padding(
                  padding: EdgeInsets.all(24),
                  child: ProfileHeader(),
                ),

                // Personal Info Section
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      EditableField(
                        label: 'Full Name',
                        value: user.name,
                        icon: Icons.person,
                        onTap: () => Get.to(
                              () => EditProfileScreen(field: '', initialValue: '',),
                          arguments: {'field': 'name', 'value': user.name},
                        ),
                      ),
                      Divider(height: 1),
                      EditableField(
                        label: 'Email',
                        value: user.email,
                        icon: Icons.email,
                        onTap: () => Get.to(
                              () => EditProfileScreen(field: '', initialValue: '',),
                          arguments: {'field': 'email', 'value': user.email},
                        ),
                      ),
                      Divider(height: 1),
                      EditableField(
                        label: 'Phone',
                        value: user.phone,
                        icon: Icons.phone,
                        onTap: () => Get.to(
                              () => EditProfileScreen(field: '',initialValue: '',),
                          arguments: {'field': 'phone', 'value': user.phone},
                        ),
                      ),
                    ],
                  ),
                ),

                // Addresses Section
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Addresses',
                        style: AppTextStyles.titleMedium(context),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => AddressManagementScreen()),
                        child: Text('Manage'),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  final defaultAddress = controller.addresses.firstWhereOrNull(
                        (addr) => addr.isDefault,
                  );
                  return defaultAddress != null
                      ? AddressCard(
                    address: defaultAddress,
                    isDefault: true,
                    onEdit: () => Get.to(
                          () => AddressManagementScreen(),
                      arguments: defaultAddress,
                    ),
                    onDelete: () => controller.deleteAddress(defaultAddress.id),
                    onSetDefault: () {},
                  )
                      : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('No default address set'),
                  );
                }),

                // Settings Section
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Text(
                    'Account Settings',
                    style: AppTextStyles.titleMedium(context),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      SettingsOption(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        onTap: () => Get.toNamed(AppRoutes.orders),
                      ),
                      Divider(height: 1),
                      SettingsOption(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage your notifications',
                        onTap: () {},
                      ),
                      Divider(height: 1),
                      SettingsOption(
                        icon: Icons.lock_outlined,
                        title: 'Change Password',
                        onTap: () {}
                      ),
                      Divider(height: 1),
                      SettingsOption(
                        icon: Icons.logout,
                        title: 'Logout',
                        iconColor: Colors.red,
                        onTap: AuthController.to.showLogoutConfirmation,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}