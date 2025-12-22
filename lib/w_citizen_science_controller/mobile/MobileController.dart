import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


import '../../services/api_urls.dart';
import '../../services/location_service.dart';
import '../../services/user_pref_service.dart';
import '../../w_citizen_science_pages/home_page.dart';
import '../../w_citizen_science_pages/otp.dart';

class CitizenScienceMobileController extends GetxController{
  final TextEditingController mobile = TextEditingController();
  final userPrefService = UserPrefService();
  var isChecking = true.obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }


  gotoOTP() async {
    if (mobile.value.text.isEmpty || mobile.value.text.length != 11) {
      Get.snackbar("error".tr, "mobile_error_msg".tr, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
      isLoading.value = true;

      var locationId = userPrefService.locationId;
      print('shakil locationId: $locationId');
      if (locationId == null || locationId.isEmpty) {
        await LocationService().getLocation(
          onSettingsOpened: () {
            print("User opened location settings.");
          },
        );
      }

      Future.delayed(const Duration(seconds: 1), () {
        print('shakil locationId after delay: ${userPrefService.locationId}');
      });

      var params = jsonEncode({ "mobile": mobile.value.text });
      var response = await http.post(
          Uri.parse(ApiURL.SEND_OTP),
          body: params,
          headers: {"Content-Type": "application/json"}
      );
      dynamic decode = jsonDecode(response.body);
      print('shakil mobile: $decode');

      if (response.statusCode != 200) {
        Get.defaultDialog(
          title: "Alert",
          middleText: decode['message'] ?? 'Something went wrong',
          textCancel: 'Ok',
        );
      } else {
        decode['status'] != true
            ? Get.snackbar("warning".tr, "${decode['message']}", backgroundColor: Colors.red, colorText: Colors.white):
        Get.to(CitizenScienceOtp(), arguments: {'mobile': mobile.value.text,}, transition: Transition.leftToRight);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future checkLogin() async {
    print('shakil token#1: ${userPrefService.userToken}');
    if(userPrefService.userToken != null && userPrefService.userToken!.isNotEmpty) {
      Get.off(
            () => CitizenSciencePage(),
        transition: Transition.downToUp,
        //binding: WaterWatchNavigationBinding(),
      );
    }else {
      isChecking.value = false; // Stop loading, show login page
    }
  }
}