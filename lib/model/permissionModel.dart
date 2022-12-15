// To parse this JSON data, do
//
//     final unitModel = unitModelFromJson(jsonString);

import 'dart:convert';

List<PermissionModel> permissionModelFromJson(String str) =>
    List<PermissionModel>.from(
      json.decode(str).map(
            (x) => PermissionModel.fromJson(x),
          ),
    );

String permissionModelToJson(List<PermissionModel> data) => json.encode(
      List<dynamic>.from(
        data.map((x) => x.toJson()),
      ),
    );

class PermissionModel {
  PermissionModel({
    this.module,
    this.username,
    this.allowed,
  });

  String? module;
  String? username;
  int? allowed;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel(
        module: json["module"],
        username: json["username"],
        allowed: json["allowed"],
      );

  Map<String, dynamic> toJson() => {
        "module": module,
        "username": username,
        "allowed": allowed,
      };
}
