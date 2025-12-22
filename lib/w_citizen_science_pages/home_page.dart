import 'package:bmd_weather_app/w_citizen_science_controller/dashboard/DashboardController.dart';
import 'package:bmd_weather_app/w_citizen_science_pages/profile_page.dart';
import 'package:bmd_weather_app/w_citizen_science_pages/webview_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../utills/app_color.dart';
import '../w_citizen_science_controller/webview/webview_binding.dart';

class CitizenSciencePage extends StatefulWidget {
  const CitizenSciencePage({super.key});

  @override
  State<CitizenSciencePage> createState() => _CitizenSciencePageState();
}

class _CitizenSciencePageState extends State<CitizenSciencePage> {
  // Use Get.find if initialized earlier, otherwise Get.put
  final CitizenScienceDashboardController controller = Get.put(CitizenScienceDashboardController());

  @override
  void initState() {
    super.initState();
    // Ensure data is fetched when page opens
    if(controller.dashboardModules.isEmpty){
      controller.fetchDashboardData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().app_secondary,

      // ------------ APP BAR ------------
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: AppColors().app_secondary,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                padding: EdgeInsets.only(left: 8.w),
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.cyan, size: 22),
              ),
              SizedBox(width: 8.w),
              Text(
                "সিটিজেন সাইন্স",
                style: GoogleFonts.notoSansBengali(
                  color: Color(0xFF0D6EA8),
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () => Get.to(() => CitizenScienceProfilePage()),
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.black12,
                  backgroundImage: AssetImage("assets/icons/profile.png"),
                ),
              ),
            )
          ],
        ),
      ),

      // ------------ BODY ------------
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.dashboardModules.isEmpty) {
          return Center(child: Text("No data available"));
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: controller.dashboardModules.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final module = controller.dashboardModules[index];

            return GestureDetector(
              onTap: () {
                if (module.url != null && module.url!.isNotEmpty) {
                  var item = {
                    "title": module.name ?? "Citizen Science",
                    "url": module.url!
                  };
                  Get.to(() => WebviewView(),
                      binding: WebviewBinding(), arguments: item, transition: Transition.rightToLeft);
                } else {
                  Get.snackbar("Error", "Invalid URL");
                }
              },
              child: _cardItem(
                iconUrl: module.icon ?? "",
                title: module.name ?? "",
              ),
            );
          },
        );
      }),
    );
  }

  // ------------ UPDATED CARD WIDGET ------------
  Widget _cardItem({required String iconUrl, required String title}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFE1F4FF),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Color(0xFFD6F0FF)),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white, // White background for the icon
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                iconUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, color: Colors.grey);
                },
              ),
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Text(
              title,
              style: GoogleFonts.notoSansBengali(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey,)
        ],
      ),
    );
  }
}