// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

List<StudentModel> studentModelFromJson(String str) => List<StudentModel>.from(
    json.decode(str).map((x) => StudentModel.fromJson(x)));

String studentModelToJson(List<StudentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentModel {
  StudentModel({
    this.id,
    this.sno,
    this.lastname,
    this.firstname,
    this.middlename,
    this.program,
    this.major,
    this.yearlevel,
    this.email,
    this.mobile,
    this.address,
    this.username,
    this.password,
  });

  int? id;
  String? sno;
  String? lastname;
  String? firstname;
  String? middlename;
  String? program;
  String? major;
  String? yearlevel;
  String? email;
  String? mobile;
  String? address;
  String? username;
  String? password;
  bool? isEdit;

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        id: json["id"],
        sno: json["sno"],
        lastname: json["lastname"],
        firstname: json["firstname"],
        middlename: json["middlename"],
        program: json["program"],
        major: json["major"],
        yearlevel: json["yearlevel"],
        email: json["email"],
        mobile: json["mobile"],
        address: json["address"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sno": sno,
        "lastname": lastname,
        "firstname": firstname,
        "middlename": middlename,
        "program": program,
        "major": major,
        "yearlevel": yearlevel,
        "email": email,
        "mobile": mobile,
        "address": address,
        "username": username,
        "password": password,
      };
}
