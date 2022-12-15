// ignore_for_file: file_names

import 'package:get/get.dart';

class LoadingController extends GetxController {
  var loading = false.obs;

  void setValue(value) async {
    print('setValue: ' + value.toString());
    loading.value = value;
  }
}
