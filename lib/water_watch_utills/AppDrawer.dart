// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controller/profile/ProfileController.dart';
// import '../page/Mobile.dart';
// import '../services/api_urls.dart';
// import '../services/user_pref_service.dart';
// import 'AppColors.dart';
//
// class AppDrawer extends StatefulWidget {
//   const AppDrawer({super.key});
//
//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }
//
// class _AppDrawerState extends State<AppDrawer> {
//   final userPrefService = UserPrefService();
//   final controller = Get.put(ProfileController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             currentAccountPicture: Container(
//               padding: EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: AppColors().app_secondary
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   Get.to(()=> Profile(isBackButton: true), transition: Transition.rightToLeft);
//                 },
//                 child: CircleAvatar(
//                   radius: 64,
//                   backgroundImage: (controller.photo.value.isNotEmpty
//                       ? NetworkImage(controller.photo.value) // Show saved image
//                       : AssetImage("assets/images/default_avatar.png") // Fallback image
//                   ) as ImageProvider, // Ensures correct type
//                 ),
//               ),
//             ),
//             accountName: Text( userPrefService.userName!.isEmpty ? userPrefService.userMobile ?? '' : userPrefService.userName ?? '' ),
//             accountEmail: Text(userPrefService.userAddress ?? ''),
//             decoration: BoxDecoration(
//               color: AppColors().app_primary
//             ),
//           ),
//
//           ListTile(
//             leading: Icon(Icons.storage),
//             title: Text('survey_data'.tr),
//             onTap: () {
//               Get.to(()=> SurveyPage(), transition: Transition.rightToLeft);
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.video_file_outlined),
//             title: Text("dashboard_sidebar_important_video".tr),
//             onTap: () { },
//           ),
//           GestureDetector(
//             onTap: () {
//               var item = {
//                 "title": "dashboard_sidebar_about_us".tr,
//                 "url": ApiURL.sidebar_contact_us
//               };
//               //Get.to(()=> WebviewView(), binding: WebviewBinding(), arguments: item, transition: Transition.rightToLeft);
//             },
//             child: ListTile(
//               leading: Icon(Icons.info),
//               title: Text("dashboard_sidebar_about_us".tr),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               var item = {
//                 "title": "dashboard_sidebar_privacy_policy".tr,
//                 "url": ApiURL.sidebar_faq
//               };
//               //Get.to(()=> WebviewView(), binding: WebviewBinding(), arguments: item, transition: Transition.rightToLeft);
//             },
//             child: ListTile(
//               leading: Icon(Icons.forum_outlined),
//               title: Text("dashboard_sidebar_privacy_policy".tr),
//             ),
//           ),
//           Divider(),
//           GestureDetector(
//             onTap: () async {
//               userPrefService.clearUserData();
//               Get.offAll(Mobile(), transition: Transition.upToDown);
//               // var response = await http.post(ApiURL.fcm, headers: { HttpHeaders.authorizationHeader: '${userPrefService.userToken ?? ''}' } );
//               // dynamic decode = jsonDecode(response.body) ;
//               //
//               // Get.defaultDialog(
//               //     title: "Alert",
//               //     middleText: decode['message'],
//               //     textCancel: 'OK',
//               //     onCancel: () async {
//               //       userPrefService.clearUserData();
//               //       Get.offAll(Mobile(), transition: Transition.upToDown);
//               //     }
//               //);
//             },
//             child: ListTile(
//               leading: Icon(Icons.logout_outlined),
//               title: Text("profile_logout".tr),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
