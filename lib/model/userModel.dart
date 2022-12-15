// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    this.firstname,
    this.middlename,
    this.lastname,
    this.username,
    this.password,
    this.email,
  });

  String? firstname;
  String? middlename;
  String? lastname;
  String? username;
  String? password;
  String? email;
  bool? isedit;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstname: json["firstname"],
        middlename: json["middlename"],
        lastname: json["lastname"],
        username: json["username"],
        password: json["password"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "middlename": middlename,
        "lastname": lastname,
        "username": username,
        "password": password,
        "email": email,
      };

  String userAsString() {
    return '$lastname, $firstname $middlename';
  }

  ///this method will prevent the override of toString
  bool userFilterByNames(String filter) {
    return userAsString().contains(filter);
  }

  @override
  String toString() => '$lastname, $firstname $middlename';
}
