import 'package:flutter/material.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../Models/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressCard({super.key,
    required this.address,
    required this.isDefault,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  address.title,
                  style: AppTextStyles.titleSmall(context),
                ),
                if (isDefault)
                  Chip(
                    label: Text('Default'),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(address.fullName),
            Text(address.phone),
            Text(address.addressLine1),
            if (address.addressLine2.isNotEmpty) Text(address.addressLine2),
            Text('${address.city}, ${address.state} ${address.postalCode}'),
            Text(address.country),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isDefault)
                  TextButton(
                    onPressed: onSetDefault,
                    child: Text('Set as Default'),
                  ),
                TextButton(
                  onPressed: onEdit,
                  child: Text('Edit'),
                ),
                TextButton(
                  onPressed: onDelete,
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}