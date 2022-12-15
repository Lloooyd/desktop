// ignore_for_file: file_names

import 'package:desktop/common/constant.dart';
import 'package:desktop/model/lookupModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BarangayController extends GetxController {
  var loading = false.obs;
  var barangays = <LookUpModel>[].obs;

  Future<void> setRecords() async {
    try {
      loading.value = true;
      var client = http.Client();
      var url = Uri.parse("$kUrl/barangay/list");
      var resp = await client.get(url, headers: kHeader);
      if (resp.statusCode == 200) {
        barangays.value = lookUpModelFromJson(resp.body);
      }
      loading.value = false;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> getRecords() async {
    try {
      loading.value = true;

      if (barangays.isEmpty) {
        var client = http.Client();
        var url = Uri.parse("$kUrl/barangay/list");
        var resp = await client.get(url, headers: kHeader);
        if (resp.statusCode == 200) {
          barangays.value = lookUpModelFromJson(resp.body);
        }
      }

      loading.value = false;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<String>> getListString() async {
    try {
      List<String> list = [];
      if (barangays.isEmpty) {
        var client = http.Client();
        var url = Uri.parse("$kUrl/barangay/list");
        var resp = await client.get(url, headers: kHeader);
        if (resp.statusCode == 200) {
          barangays.value = lookUpModelFromJson(resp.body);
        }
      }

      for (var item in barangays) {
        list.add(item.description!);
      }
      return list;
    } catch (error) {
      throw Exception(error);
    }
  }
}
