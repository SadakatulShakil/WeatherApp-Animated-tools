import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';
import '../../w_citizen_science_pages/home_page.dart';

class CitizenScienceOtpController extends GetxController {
  final mobile = Get.arguments['mobile'] ?? "";
  final otp = Get.arguments['otp'] ?? "";

  final TextEditingController otp1 = TextEditingController();
  final TextEditingController otp2 = TextEditingController();
  final TextEditingController otp3 = TextEditingController();
  final TextEditingController otp4 = TextEditingController();

  final userService = UserPrefService();

  late Timer timer;
  var second = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  void startTimer() {
    //Get.snackbar("success_snack".tr, "otp_bypass".tr + otp, backgroundColor: Colors.red, colorText: Colors.white);

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      second.value = 120 - t.tick;
      if (t.tick >= 120) {
        second.value = 0;
        timer.cancel();
      }
    });
  }

  bool get isOtpFilled =>
      otp1.text.isNotEmpty &&
          otp2.text.isNotEmpty &&
          otp3.text.isNotEmpty &&
          otp4.text.isNotEmpty;

  Future<void> loginClick() async {
    if (!isOtpFilled) {
      Get.defaultDialog(
        title: "Alert",
        middleText: "All OTP inputs are required!",
        textCancel: 'Ok',
      );
      return;
    }

    isLoading.value = true;

    try {
      var params = jsonEncode({
        "mobile": mobile,
        "otp": '${otp1.text}${otp2.text}${otp3.text}${otp4.text}',
      });

      print('body: $params');

      final response = await http.post(
          Uri.parse(ApiURL.VERIFY_OTP),
          body: params,
          headers: {"Content-Type": "application/json"}
      );
      final decode = jsonDecode(response.body);

      print("Otp_response: $decode");
      print("Otp_response: ${response.statusCode}");

      if (response.statusCode != 200) {
        Get.defaultDialog(
          title: "Alert",
          middleText: decode['message'] ?? 'Verification failed',
          textCancel: 'Ok',
        );
        return;
      }

      //final user = decode['user'];

      await userService.saveUserData(
        decode['token'],
        '',
        DateTime.now().add(Duration(days: 7)).toIso8601String(),
        '',
        '',
        mobile,
        '',
        '',
        '',
      );

      /// Send FCM Token
      // var fcmBody = jsonEncode({
      //   "token": userService.fcmToken,
      //   "device": "android",
      // });
      //
      // final fcmResponse = await http.post(
      //   ApiURL.fcm,
      //   body: fcmBody,
      //   headers: {
      //     HttpHeaders.authorizationHeader: '${decode['access']}',
      //   },
      // );
      //
      // print("Fcm_response: ${jsonDecode(fcmResponse.body)}");
      // print("Fcm_body: $fcmBody");

      ///Remove the login page from back stack by using offUntil
      Get.offUntil( GetPageRoute(
          page: () => CitizenSciencePage(),
          //binding: WaterWatchNavigationBinding(),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      print("OTP login error: $e}");
      Get.snackbar("Error", "An unexpected error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOTP() async {
    try {
      final params = jsonEncode({"mobile": mobile});
      final response = await http.post(Uri.parse(ApiURL.SEND_OTP), body: params, headers: {"Content-Type": "application/json"});
      final decode = jsonDecode(response.body);

      if (response.statusCode != 200) {
        Get.defaultDialog(
          title: "Alert",
          middleText: decode['message'] ?? 'Could not resend OTP',
          textCancel: 'Ok',
        );
        return;
      }

      startTimer(); // Restart timer
    } catch (e) {
      print("Resend OTP error: $e");
      Get.snackbar("Error", "Failed to resend OTP.");
    }
  }
}
