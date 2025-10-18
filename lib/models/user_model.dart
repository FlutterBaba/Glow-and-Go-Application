class UserModel {
  String uid;
  String fullName;
  String email;
  String phoneNumber;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  /// ✅ Convert UserModel to JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  /// ✅ Convert JSON (Map) to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}
