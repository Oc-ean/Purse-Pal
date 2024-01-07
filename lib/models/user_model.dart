import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  final String email;
  final String password;
  final String id;
  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['email'] = email;
    data['password'] = password;
    data['id'] = id;
    return data;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      id: json['id'] ?? '',
    );
  }

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    var documentSnapShot = snapshot.data() as Map<String, dynamic>;
    print('==========>$documentSnapShot<========');
    return UserModel(
      email: documentSnapShot['email'],
      fullName: documentSnapShot['fullName'],
      password: documentSnapShot['password'],
      id: documentSnapShot['id'],
    );
  }
}
