import 'dart:developer';

class UserModel {
  String username;
  String displayname;
  String email;
  String password;
  int contact;
  List contacts;

  UserModel({
    required this.username,
    required this.displayname,
    required this.email,
    required this.password,
    required this.contact,
    required this.contacts,
  });

  UserModel.getInstance(
      {this.displayname = "NO name",
      this.username = "No Name",
      this.email = "name23@gmail.com",
      this.contact = 0,
      this.contacts = const [],
      this.password = "name@123"});

  factory UserModel.fromMap({required Map data}) {
    return UserModel(
        username: data['user_name'],
        displayname: data['display_name'],
        email: data['email'],
        password: data['password'],
        contact: data['contact_no'],
        contacts: data['contacts']);
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? image;
}
