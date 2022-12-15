// ignore_for_file: file_names

import 'package:desktop/model/userModel.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var user = UserModel().obs;
  var permissions = [].obs;

  void setUser(value) async {
    user.value = value;
  }

  void setPermission(value) async {
    permissions.value = value;
  }
}
