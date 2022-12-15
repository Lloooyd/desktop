import 'package:flutter/cupertino.dart';

class MenuModel {
  MenuModel(
      {required this.title,
      required this.header,
      required this.icon,
      required this.index});

  String title;
  String header;
  IconData icon;
  int index;
}
