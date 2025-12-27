import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/home_controller.dart';
import '../../utills/app_color.dart';

class NotificationPage extends GetView<HomeController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Refresh data when entering the page (optional)
    controller.fetchNotifications();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: AppColors().app_secondary,
          elevation: 0,
          automaticallyImplyLeading: false, // remove default back
          titleSpacing: 0,

          title: Row(
            children: [
              // iOS back button
              IconButton(
                onPressed: () => Get.back(),
                padding: EdgeInsets.only(left: 8.w),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.cyan,
                  size: 22,
                ),
              ),

              SizedBox(width: 8.w),

              // Custom title
              Text(
                "notification".tr,
                style: GoogleFonts.notoSansBengali(
                  color: Color(0xFF0D6EA8),
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        // 1. Loading State
        if (controller.isNotificationLoading.value) {
          return Center(
            child: Lottie.asset('assets/json/loading_anim.json', width: 80.w, height: 80.h),
          );
        }

        // 2. Error State
        if (controller.isNotificationError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 50, color: Colors.red.shade300),
                SizedBox(height: 10.h),
                Text("তথ্য লোড করতে সমস্যা হয়েছে", style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () => controller.fetchNotifications(),
                  child: Text("পুনরায় চেষ্টা করুন"),
                )
              ],
            ),
          );
        }

        // 3. Empty State
        if (controller.notificationList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey.shade400),
                SizedBox(height: 10.h),
                Text("কোনো বিজ্ঞপ্তি নেই", style: GoogleFonts.notoSansBengali(fontSize: 16.sp, color: Colors.grey)),
              ],
            ),
          );
        }

        // 4. Data List
        return RefreshIndicator(
          onRefresh: () async => await controller.fetchNotifications(),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: controller.notificationList.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final item = controller.notificationList[index];
              final isActive = item.isActive;

              return Container(
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ] : [],
                  border: Border.all(
                    color: isActive ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0xFFE3F2FD) : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_active_outlined,
                              color: isActive ? AppColors().app_primary : Colors.grey,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Title & Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title ?? "Title N/A",
                                  style: GoogleFonts.notoSansBengali(
                                    fontSize: 15.sp,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                    color: isActive ? Colors.black87 : Colors.grey.shade600,
                                    height: 1.3,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 12.sp, color: Colors.grey),
                                    SizedBox(width: 4.w),
                                    Text(
                                      controller.formatNotificationDate(item.createdAt),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}