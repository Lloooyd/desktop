// To parse this JSON data, do
//
//     final unitModel = unitModelFromJson(jsonString);

import 'dart:convert';

List<LookUpModel> lookUpModelFromJson(String str) => List<LookUpModel>.from(
      json.decode(str).map(
            (x) => LookUpModel.fromJson(x),
          ),
    );

String lookUpModelToJson(List<LookUpModel> data) => json.encode(
      List<dynamic>.from(
        data.map((x) => x.toJson()),
      ),
    );

class LookUpModel {
  LookUpModel({
    this.id,
    this.description,
    this.isEdit,
  });

  int? id;
  String? description;
  bool? isEdit;
  bool? isOK;

  factory LookUpModel.fromJson(Map<String, dynamic> json) => LookUpModel(
        id: json["id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
      };

  String lookUpAsString() {
    return description == null ? '' : '$description';
  }

  ///this method will prevent the override of toString
  bool lookUpFilterByDescription(String filter) {
    return lookUpAsString().contains(filter);
  }

  @override
  String toString() => description == null ? '' : '$description';
}
