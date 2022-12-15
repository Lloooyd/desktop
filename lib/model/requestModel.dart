// To parse this JSON data, do
//
//     final requestModel = requestModelFromJson(jsonString);

import 'dart:convert';

List<RequestModel> requestModelFromJson(String str) => List<RequestModel>.from(
    json.decode(str).map((x) => RequestModel.fromJson(x)));

String requestModelToJson(List<RequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestModel {
  RequestModel({
    this.id,
    this.sno,
    this.docid,
    this.status,
    this.reqdate,
    this.appdate,
    this.copies,
    this.description,
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
  int? docid;
  int? status;
  String? reqdate;
  String? appdate;
  int? copies;
  String? description;
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

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json["id"],
        sno: json["sno"],
        docid: json["docid"],
        status: json["status"],
        reqdate: json["reqdate"],
        appdate: json["appdate"],
        copies: json["copies"],
        description: json["description"],
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
        "docid": docid,
        "status": status,
        "reqdate": reqdate,
        "appdate": appdate,
        "copies": copies,
        "description": description,
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
