import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/upazila_list_model.dart';

class SelectLocationController extends GetxController {
  var upazilas = <Data>[].obs;
  var filteredUpazilas = <Data>[].obs;
  var isLoading = false.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUpazilas();
  }

  Future<void> fetchUpazilas() async {
    final jsonString =
    await rootBundle.loadString('assets/json/location_list.json');

    upazilas.value = UpazilaListModel.fromJson(json.decode(jsonString)).data ?? [];
    filteredUpazilas.value = upazilas;
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredUpazilas.value = upazilas;
    } else {
      filteredUpazilas.value = upazilas
          .where((item) =>
          (item.name ?? '').toLowerCase().contains(query.toLowerCase()) ||
          (item.name_bn ?? '').toLowerCase().contains(query.toLowerCase()) ||
          (item.district ?? '').toLowerCase().contains(query.toLowerCase()) ||
          (item.district_bn ?? '').toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }
}
