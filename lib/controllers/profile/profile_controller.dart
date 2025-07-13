import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../Models/address_model.dart';
import '../../Models/user_profile_model.dart';
import '../../repositories/profile/profile_repository.dart';


class ProfileController extends GetxController {
  final ProfileRepository _repository = ProfileRepository();
  final Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    fetchProfileData();
    super.onInit();
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading(true);
      _repository.getUserProfile().listen((profile) {
        userProfile.value = profile;
      });
      _repository.getAddresses().listen((addresses) {
        this.addresses.assignAll(addresses);
      });
      errorMessage('');
    } catch (e) {
      errorMessage.value = 'Failed to load profile data';
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfile(UserProfileModel updatedProfile) async {
    try {
      await _repository.updateProfile(updatedProfile);
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }

  Future<void> updateProfilePicture() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null && userProfile.value != null) {
        final imageUrl = await _repository.uploadProfileImage(image.path);
        await updateProfile(userProfile.value!.copyWith(photoUrl: imageUrl));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile picture');
    }
  }

  // Address Management
  Future<void> addAddress(AddressModel address) async {
    try {
      await _repository.addAddress(address);
      Get.snackbar('Success', 'Address added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add address');
    }
  }

  Future<void> updateAddress(AddressModel address) async {
    try {
      await _repository.updateAddress(address);
      Get.snackbar('Success', 'Address updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address');
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _repository.deleteAddress(addressId);
      Get.snackbar('Success', 'Address deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete address');
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    try {
      await _repository.setDefaultAddress(addressId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to set default address');
    }
  }
}