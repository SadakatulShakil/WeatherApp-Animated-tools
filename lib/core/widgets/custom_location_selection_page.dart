import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/location_pick_controller.dart';
import '../../utills/app_color.dart';


class SelectLocationPage extends StatelessWidget {
  final controller = Get.put(SelectLocationController());
  final isBangla = Get.locale?.languageCode == 'bn';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8.w, 50.h, 16.w, 16.h),
                height: 150.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B8CBE), Color(0xFF09228F)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.w, top: 11.h, bottom: 12.h),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        isBangla ? 'লোকেশন নির্বাচন করুন' : 'Select Location',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSansBengali(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: Colors.white,
                          letterSpacing: 0.3.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Positioned(
                top: 100.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.r),
                    topLeft: Radius.circular(16.r),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.r,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search bar
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12.withOpacity(0.05),
                                    blurRadius: 4.r,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: controller.searchController,
                                textInputAction: TextInputAction.search,
                                onChanged: (value) {
                                  // Call search method when text changes
                                  controller.search(value);
                                },
                                decoration: InputDecoration(
                                  hintText: isBangla
                                      ? "উপজেলা বা জেলা খুঁজুন..."
                                      : "Search upazila or district...",
                                  hintStyle: GoogleFonts.notoSansBengali(
                                    color: Colors.grey,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  label: Text(isBangla
                                      ? "উপজেলা বা জেলা খুঁজুন"
                                      : "Search upazila or district",),
                                  labelStyle: GoogleFonts.notoSansBengali(
                                    color: AppColors().app_primary,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  suffixIcon: Icon(Icons.search, size: 22.sp),
                                  suffixIconColor: AppColors().app_primary,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              )
                          ),

                          SizedBox(height: 10.h),

                          Expanded(
                            child: Obx(() {
                              if (controller.isLoading.value) {
                                return Center(
                                    child: Lottie.asset('assets/json/loading_anim.json', width: 80, height: 80));
                              }

                              if (controller.filteredUpazilas.isEmpty) {
                                return Center(
                                  child: Text(
                                    isBangla
                                        ? "কোন ফলাফল পাওয়া যায়নি"
                                        : "No results found",
                                    style: GoogleFonts.notoSansBengali(
                                      color: Colors.black54,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: EdgeInsets.only(top: 5.h),
                                itemCount: controller.filteredUpazilas.length,
                                itemBuilder: (context, index) {
                                  final item =
                                  controller.filteredUpazilas[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.05),
                                          blurRadius: 4.r,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.r),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 6.h),
                                      title: Text(
                                        isBangla
                                            ? (item.name_bn ?? "")
                                            : (item.name ?? ""),
                                        style: GoogleFonts.notoSansBengali(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                          color: Colors.black87
                                        ),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isBangla
                                                ? (item.district_bn ?? "")
                                                : (item.district ?? ""),
                                            style: GoogleFonts.notoSansBengali(
                                              fontSize: 14.sp,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text('(${item.lat.toStringAsFixed(5)}, ${item.lng.toStringAsFixed(5)})',
                                            style: GoogleFonts.notoSansBengali(
                                              fontSize: 14.sp,
                                              color: Colors.lightBlueAccent.withValues(alpha: 600, red: 0, green: 400, blue: 300),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: SvgPicture.asset(
                                        'assets/svg/location_icon.svg',
                                        width: 16.w,
                                        height: 20.h,
                                        color: AppColors().app_primary,
                                      ),
                                      onTap: () => Get.back(result: item),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}