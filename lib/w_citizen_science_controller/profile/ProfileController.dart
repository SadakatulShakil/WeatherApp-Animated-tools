import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';
import '../../w_citizen_science_pages/mobile.dart';

class CitizenScienceProfileController extends GetxController with GetSingleTickerProviderStateMixin {

  late TabController tabController = TabController(length: 3, vsync: this);

  final userService = UserPrefService(); //User service for replacement of Shared pref

  Future logout() async{
    await userService.clearUserData();
    //Get.offAll(() => WaterWatchMobile(), transition: Transition.upToDown);
    Get.offUntil(
      GetPageRoute(page: () => CitizenScienceMobile(), transition: Transition.upToDown),
          (route) => route.isFirst,
    );
    // var response = await http.post(ApiURL.fcm, headers: { HttpHeaders.authorizationHeader: '${userService.userToken}' } );
    // dynamic decode = jsonDecode(response.body) ;
    //
    // Get.defaultDialog(
    //     title: "Alert",
    //     middleText: decode['message'],
    //     textCancel: 'OK',
    //     onCancel: () async {
    //       await userService.clearUserData();
    //       Get.offAll(Mobile(), transition: Transition.upToDown);
    //     }
    // );
  }

  late var id = "".obs;
  late var name = "".obs;
  late var full_name = "".obs;
  late var last_name = "".obs;
  late var mobile = "".obs;
  late var email = "".obs;
  late var address = "".obs;
  late var type = "".obs;
  late var photo = "assets/icons/profile.jpg".obs;

  var selectedImagePath = ''.obs;
  var isConfirmVisible = false.obs; // To show/hide the confirm button

  final ImagePicker picker = ImagePicker();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getSharedPrefData();
  }

  Future getSharedPrefData() async {
    id.value = userService.userId ?? '';
    name.value = userService.userName ?? '';
    full_name.value = userService.userName ?? '';
    last_name.value = userService.lastName ?? '';
    mobile.value = userService.userMobile ?? '';
    email.value = userService.userEmail ?? '';
    address.value = userService.userAddress ?? '';
    type.value = userService.userType ?? '';

    if (userService.userPhoto != null && userService.userPhoto != '') {
      // Case 1: Already a full URL, use it as is.
      photo.value = userService.userPhoto!;
      print('imageUrl: ${photo.value}');
      print('imageUrl2: ${userService.userPhoto}');
    }else {
      // Case 2: Handle null or empty userPhoto (fallback)
      photo.value = "assets/icons/profile.jpg"; // Use default image
    }

    print('userMobile: ${mobile.value}');

    fullNameController.text = full_name.value;
    // lastNameController.text = last_name.value;
    emailController.text = email.value;
    addressController.text = address.value;
    mobileController.text = mobile.value == '' ? '01751330394' : mobile.value;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // 📸 Function to pick image from gallery or camera
  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: await _showImagePickerDialog(),
      imageQuality: 80,
    );

    if (image != null) {
      selectedImagePath.value = image.path;
      isConfirmVisible.value = true; // Show confirm button
    }
  }

  // 📋 Show Dialog to choose Camera or Gallery
  Future<ImageSource> _showImagePickerDialog() async {
    return await Get.dialog(
      AlertDialog(
        title: Text("Select Image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Camera"),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Gallery"),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    ) ?? ImageSource.gallery; // Default to gallery if canceled
  }

  Future<void> updateProfile() async {
    String? token = userService.userToken;
    print("Updating profile with token: $token");

    try {
      // 1. Prepare the JSON Body
      Map<String, dynamic> body = {
        "fullname": fullNameController.text,
        "email": emailController.text,
        "address": addressController.text,
        // Sending current lat/lon from preferences, or default/empty if null
        "lat": userService.lat ?? "23.012",
        "lon": userService.lon ?? "90.123"
      };

      print("Profile Update Body: $body");

      // 2. Send PUT Request
      final response = await http.put(
        Uri.parse(ApiURL.USER_PROFILE_UPDATE),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json', // Crucial for JSON payload
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      var decode = jsonDecode(response.body);
      print("Profile Update Response: $decode");
      print("Profile Update Code: ${response.statusCode}");

      // 3. Handle Success
      if (response.statusCode == 200) {

        // Update shared preferences with the new text data
        await userService.saveProfileData(
          fullNameController.text,
          emailController.text,
          mobileController.text, // Keep existing mobile
          addressController.text,
          userService.lat ?? "23.012",
          userService.lon ?? "90.123",
          userService.userType ?? 'common',
          userService.userPhoto ?? '', // Keep existing photo URL since we didn't upload a new one
        );

        // Refresh local controller variables
        await getSharedPrefData();

        Get.defaultDialog(
          title: "Success",
          middleText: 'Profile Updated Successfully',
          textConfirm: 'Ok',
          onConfirm: () => Get.back(),
        );

      }
      // 4. Handle Token Expiry
      else if (response.statusCode == 401) {
        bool refreshed = await userService.refreshAccessToken();
        if (refreshed) {
          return updateProfile(); // Recursively retry
        } else {
          await userService.clearUserData();
          Get.offAll(() => CitizenScienceMobile(), transition: Transition.upToDown);
        }
      }
      // 5. Handle Other Errors
      else {
        Get.defaultDialog(
          title: "Error",
          middleText: decode['message'] ?? "Server error occurred",
          textCancel: 'Ok',
        );
      }
    } catch (e) {
      print("Profile update error: $e");
      Get.defaultDialog(
        title: "Error",
        middleText: "Something went wrong! Check your connection.",
        textCancel: 'Ok',
      );
    }
  }

}