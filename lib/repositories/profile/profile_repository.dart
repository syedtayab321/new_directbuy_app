import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../Models/address_model.dart';
import '../../Models/user_profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User Profile
  Stream<UserProfileModel> getUserProfile() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .snapshots()
        .map((snapshot) => UserProfileModel.fromMap(snapshot.id, snapshot.data()!));
  }

  Future<void> updateProfile(UserProfileModel profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .update(profile.toMap());
  }

  Future<String> uploadProfileImage(String filePath) async {
    final ref = _storage.ref().child('profile_images/${_auth.currentUser?.uid}');
    await ref.putFile(File(filePath));
    return await ref.getDownloadURL();
  }

  // Addresses
  Stream<List<AddressModel>> getAddresses() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('addresses')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => AddressModel.fromMap(doc.id, doc.data()))
        .toList());
  }

  Future<void> addAddress(AddressModel address) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('addresses')
        .add(address.toMap());
  }

  Future<void> updateAddress(AddressModel address) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('addresses')
        .doc(address.id)
        .update(address.toMap());
  }

  Future<void> deleteAddress(String addressId) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }

  Future<void> setDefaultAddress(String addressId) async {
    // Reset all addresses to non-default first
    final batch = _firestore.batch();
    final addresses = await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('addresses')
        .get();

    for (var doc in addresses.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }

    // Set the selected address as default
    batch.update(
      _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('addresses')
          .doc(addressId),
      {'isDefault': true},
    );

    await batch.commit();
  }
}