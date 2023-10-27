import 'dart:developer';

class UserModel {
  int id;
  String username;
  String email;
  String password;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  factory UserModel.fromMap({required Map data}) {
    return UserModel(
      id: data['Id'],
      username: data['username'],
      email: data['email'],
      password: data["password"],
    );
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? image;
}
