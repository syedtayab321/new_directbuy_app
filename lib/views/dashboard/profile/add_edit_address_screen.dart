import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Features/styles/app_text_styles.dart';
import '../../../Features/theme/app_colors.dart';
import '../../../Models/address_model.dart';
import '../../../controllers/profile/profile_controller.dart';
import '../../../features/Widgets/custom_text_field.dart';


class AddEditAddressScreen extends StatefulWidget {
  final AddressModel? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final ProfileController _controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isDefault = false;
  XFile? _locationImage;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _titleController.text = widget.address!.title;
      _fullNameController.text = widget.address!.fullName;
      _phoneController.text = widget.address!.phone;
      _address1Controller.text = widget.address!.addressLine1;
      _address2Controller.text = widget.address!.addressLine2;
      _cityController.text = widget.address!.city;
      _stateController.text = widget.address!.state;
      _postalCodeController.text = widget.address!.postalCode;
      _countryController.text = widget.address!.country;
      _isDefault = widget.address!.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.address == null ? 'Add Address' : 'Edit Address',
          style: AppTextStyles.titleLarge(context),
        ),
        actions: [
          if (widget.address != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _showDeleteDialog,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Location Photo (Optional)
              GestureDetector(
                onTap: _pickLocationImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: _locationImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_locationImage!.path),
                      fit: BoxFit.cover,
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 40, color: AppColors.grey500),
                      SizedBox(height: 8),
                      Text(
                        'Add Location Photo',
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Address Type
              CustomTextField(
                controller: _titleController,
                labelText: 'Address Title (e.g., Home, Office)',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),

              // Full Name
              CustomTextField(
                controller: _fullNameController,
                labelText: 'Full Name',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),

              // Phone Number
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),

              // Address Line 1
              CustomTextField(
                controller: _address1Controller,
                labelText: 'Address Line 1',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),

              // Address Line 2
              CustomTextField(
                controller: _address2Controller,
                labelText: 'Address Line 2 (Optional)',
              ),
              SizedBox(height: 16),

              // City, State, Postal Code Row
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      controller: _cityController,
                      labelText: 'City',
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: _stateController,
                      labelText: 'State',
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Postal Code & Country
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: _postalCodeController,
                      labelText: 'Postal Code',
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      controller: _countryController,
                      labelText: 'Country',
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Set as Default
              SwitchListTile(
                title: Text(
                  'Set as Default Address',
                  style: AppTextStyles.bodyMedium(context),
                ),
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
                activeColor: AppColors.primary,
              ),
              SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  child: Text(
                    widget.address == null ? 'ADD ADDRESS' : 'UPDATE ADDRESS',
                    style: AppTextStyles.labelLarge(context).copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickLocationImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _locationImage = image);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    final address = AddressModel(
      id: widget.address?.id ?? '',
      title: _titleController.text,
      fullName: _fullNameController.text,
      phone: _phoneController.text,
      addressLine1: _address1Controller.text,
      addressLine2: _address2Controller.text,
      city: _cityController.text,
      state: _stateController.text,
      postalCode: _postalCodeController.text,
      country: _countryController.text,
      isDefault: _isDefault,
    );

    if (widget.address == null) {
      _controller.addAddress(address);
    } else {
      _controller.updateAddress(address);
    }

    Get.back();
  }

  void _showDeleteDialog() {
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
              _controller.deleteAddress(widget.address!.id);
              Get.back();
              Get.back(); // Close both dialog and screen
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