import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final DateTime joinedDate;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.joinedDate,
  });

  factory UserProfileModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfileModel(
      uid: uid,
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      photoUrl: map['photoUrl']?.toString(),
      joinedDate: _parseTimestamp(map['joinedDate']),
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is DateTime) return timestamp;
    if (timestamp is String) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'joinedDate': Timestamp.fromDate(joinedDate),
    };
  }

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    DateTime? joinedDate,
  }) {
    return UserProfileModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserProfileModel &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              name == other.name &&
              email == other.email &&
              phone == other.phone &&
              photoUrl == other.photoUrl &&
              joinedDate == other.joinedDate;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      photoUrl.hashCode ^
      joinedDate.hashCode;
}