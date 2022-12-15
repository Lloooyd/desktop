// To parse this JSON data, do
//
//     final rowInsertModel = rowInsertModelFromJson(jsonString);

import 'dart:convert';

RowInsertModel rowInsertModelFromJson(String str) =>
    RowInsertModel.fromJson(json.decode(str));

String rowInsertModelToJson(RowInsertModel data) => json.encode(data.toJson());

class RowInsertModel {
  RowInsertModel({
    this.insertId,
  });

  int? insertId;

  factory RowInsertModel.fromJson(Map<String, dynamic> json) => RowInsertModel(
        insertId: json["insertId"],
      );

  Map<String, dynamic> toJson() => {
        "insertId": insertId,
      };
}
