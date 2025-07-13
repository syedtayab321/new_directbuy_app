import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../../components/profile/address_card.dart';
import '../../../controllers/profile/profile_controller.dart';
import 'add_edit_address_screen.dart';

class AddressManagementScreen extends StatelessWidget {
  final ProfileController controller = Get.find();
   AddressManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Addresses', style: AppTextStyles.titleLarge(context)),
      ),
      body: Obx(() {
        if (controller.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Addresses Saved',
                  style: AppTextStyles.titleMedium(context),
                ),
                SizedBox(height: 8),
                Text(
                  'Add your first address to get started',
                  style: AppTextStyles.bodyMedium(context),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.to(() => AddEditAddressScreen()),
                  child: Text('Add Address'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            final address = controller.addresses[index];
            return AddressCard(
              address: address,
              isDefault: address.isDefault,
              onEdit: () => Get.to(
                    () => AddEditAddressScreen(),
                arguments: address,
              ),
              onDelete: () => _showDeleteDialog(address.id),
              onSetDefault: () => controller.setDefaultAddress(address.id),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddEditAddressScreen()),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(String addressId) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAddress(addressId);
              Get.back();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}