import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../services/api_urls.dart';
import '../../services/user_pref_service.dart';
import '../../water_watch_pages/mobile.dart';

class WaterWatchProfileController extends GetxController with GetSingleTickerProviderStateMixin {

  late TabController tabController = TabController(length: 3, vsync: this);

  final userService = UserPrefService(); //User service for replacement of Shared pref

  Future logout() async{
    await userService.clearUserData();
    //Get.offAll(() => WaterWatchMobile(), transition: Transition.upToDown);
    Get.offUntil(
      GetPageRoute(page: () => WaterWatchMobile(), transition: Transition.upToDown),
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
  late var first_name = "".obs;
  late var last_name = "".obs;
  late var mobile = "".obs;
  late var email = "".obs;
  late var address = "".obs;
  late var type = "".obs;
  late var photo = "assets/images/profile.jpg".obs;

  var selectedImagePath = ''.obs;
  var isConfirmVisible = false.obs; // To show/hide the confirm button

  final ImagePicker picker = ImagePicker();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
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
    first_name.value = userService.firstName ?? '';
    last_name.value = userService.lastName ?? '';
    mobile.value = userService.userMobile ?? '';
    email.value = userService.userEmail ?? '';
    address.value = userService.userAddress ?? '';
    type.value = userService.userType ?? '';

    if (userService.userPhoto != null && userService.userPhoto != '') {
      // Case 1: Already a full URL, use it as is.
      photo.value = 'https://api3.ffwc.gov.bd${userService.userPhoto!}';
      print('imageUrl: ${photo.value}');
      print('imageUrl2: ${userService.userPhoto}');
    }else {
      // Case 2: Handle null or empty userPhoto (fallback)
      photo.value = "assets/images/profile.jpg"; // Use default image
    }

    print('userMobile: ${mobile.value}');

    firstNameController.text = first_name.value;
    lastNameController.text = last_name.value;
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

  Future updateProfile() async {
    String? token = userService.userToken; // Get current access token
    print("Updating profile with token: $token");

    try {
      var request = http.MultipartRequest('PUT', Uri.parse(ApiURL.USER_PROFILE_UPDATE));

      // Add headers
      request.headers['Authorization'] = "Bearer $token";

      // Add form-data text fields
      request.fields['first_name'] = firstNameController.text;
      request.fields['last_name'] = lastNameController.text;
      request.fields['address'] = addressController.text;

      // Add image if selected
      if (selectedImagePath.value.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_image',
            selectedImagePath.value,
          ),
        );
      }

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decode = jsonDecode(responseBody);

      print("Profile Update Response: $decode");
      print("Profile Update Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        String? updatedPhotoUrl;

        if (decode != null && decode['profile_image'] != null) {
          updatedPhotoUrl = "https://api3.ffwc.gov.bd${decode['profile_image']}";
          photo.value = updatedPhotoUrl;
        }

        if (decode != null && decode['profile_image'] != null && (decode['profile_image'] as String).isNotEmpty) {
          photo.value = "https://api3.ffwc.gov.bd${decode['profile_image']}";
          await userService.updateUserPhoto(photo.value);
        }

        //Update shared pref with latest values
        await userService.saveProfileData(
          firstNameController.text,
          lastNameController.text,
          '${firstNameController.text} ${lastNameController.text}',
          addressController.text,
          userService.lat != null? userService.lat.toString() : '23.4567',
          userService.lon != null? userService.lon.toString() : '89.7567',
          updatedPhotoUrl ?? photo.value,
        );

        // Save updated image if available
        if (decode != null && decode['profile_image'].isNotEmpty) {
          photo.value = decode['profile_image'];
          await userService.updateUserPhoto(photo.value);
        }

        // Refresh local state
        await getSharedPrefData();

        return Get.defaultDialog(
          title: "Success",
          middleText: 'Profile Update Successfully',
          textCancel: 'Ok',
        );
      } else if (response.statusCode == 401) {
        // Token expired, try refreshing
        bool refreshed = await userService.refreshAccessToken();
        if (refreshed) {
          return updateProfile(); // Retry
        } else {
          await userService.clearUserData();
          Get.off(WaterWatchMobile(), transition: Transition.upToDown);
        }
      } else {
        return Get.defaultDialog(
          title: "Error",
          middleText: decode['message'] ?? "Server error",
          textCancel: 'Ok',
        );
      }
    } catch (e) {
      print("Profile update error: $e");
      return Get.defaultDialog(
        title: "Error",
        middleText: "Something went wrong!",
        textCancel: 'Ok',
      );
    }
  }

}