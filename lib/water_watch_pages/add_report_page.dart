import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utills/app_color.dart';
import '../water_watch_controller/add_record/add_record_controller.dart';
import '../water_watch_controller/dashboard/DashboardController.dart';
import '../water_watch_models/station_history_model.dart';

class AddReportPage extends StatefulWidget {
  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final AddRecordController controller = Get.put(AddRecordController());
  final dashboardController = Get.find<WaterWatchDashboardController>();

  late final StationHistoryModel? record;
  late final String mode;

  final isBangla = Get.locale?.languageCode == 'bn';
  String englishToBanglaNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bangla  = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], bangla[i]);
    }
    return output;
  }

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    record = args['record'] as StationHistoryModel?;
    mode = args['mode'] ?? 'add';

    if (mode == 'update' && record != null) {
      controller.loadRecord(record!); // new method
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: 'refresh');
        return false; // prevent default pop
      },
      child: Scaffold(
        backgroundColor: AppColors().app_secondary,
        resizeToAvoidBottomInset: true,
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
                  onPressed: () => Get.back(result: 'refresh'),
                  padding: EdgeInsets.only(left: 8.w),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.cyan,
                    size: 22,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(isBangla
                    ?"${controller.locationData.name}"
                    :"${controller.locationData.name}",
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 18.sp, fontWeight: FontWeight.bold, color: Color(0xFF0D6EA8),),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() => SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text("select_date".tr,
                        style: GoogleFonts.notoSansBengali(
                            fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text("date_msg".tr, style: GoogleFonts.notoSansBengali(fontSize: 14.sp, color: Colors.grey.shade600)),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () => controller.pickDate(context),
                      child: buildDropdown(
                        title: "select_date".tr,
                        value:
                        isBangla?
                        englishToBanglaNumber(controller.selectedDate.value.toLocal().toString().split(' ')[0])
                        :"${controller.selectedDate.value.toLocal()}"
                            .split(' ')[0],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Dynamic Rows
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "time".tr,
                            style: GoogleFonts.notoSansBengali(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "measurement_value".tr,
                            style: GoogleFonts.notoSansBengali(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                        if (mode == "add") SizedBox(width: 96.w), // Reserve space only in add mode
                      ],
                    ),
                    SizedBox(height: 8),

                    ...List.generate(
                      controller.timeMeasurements.length,
                          (index) {
                        final item = controller.timeMeasurements[index];
                        final isLast = index == controller.timeMeasurements.length - 1;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            children: [
                              // Time Picker
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () => controller.pickCupertinoTime(item, context),
                                  //pickTimeByItem(item, context),
                                  child: buildDropdown(
                                    title: "time".tr,
                                    value: isBangla
                                        ? englishToBanglaNumber(item['time'].toString())
                                        : item['time'] ?? '',
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),

                              // Measurement input → expands differently based on mode
                              Expanded(
                                flex: mode == "add" ? 3 : 5, // take more space if no buttons
                                child: TextField(
                                  controller: controller.measurementControllers[item],
                                  onChanged: (v) => controller.updateMeasurementByItem(item, v),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "measurement_value".tr,
                                    hintStyle: GoogleFonts.notoSansBengali(color: Colors.grey.shade600, fontSize: isBangla?15.sp:14.sp),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),

                              // Action buttons → only in add mode
                              if (mode == "add")
                                SizedBox(
                                  width: 90.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Delete
                                      CircleAvatar(
                                        radius: 20.r,
                                        backgroundColor: Colors.red.shade100,
                                        child: IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red, size: 18.h),
                                          onPressed: () =>
                                              controller.removeTimeMeasurementByItem(item),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                      // Add / Check
                                      CircleAvatar(
                                        radius: 20.r,
                                        backgroundColor: isLast
                                            ? Colors.blue.shade900
                                            : Colors.green.shade400,
                                        child: IconButton(
                                          icon: Icon(
                                            isLast ? Icons.add : Icons.check,
                                            color: Colors.white,
                                            size: 20.h,
                                          ),
                                          onPressed: isLast
                                              ? () => controller.addTimeMeasurement()
                                              : null,
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),

                    ///Photo upload Part
                    // Text("ছবি আপলোড করুন (সর্বোচ্চ ৩টি)"),
                    // SizedBox(height: 8),
                    // Obx(() => Wrap(
                    //   spacing: 10,
                    //   runSpacing: 10,
                    //   children: [
                    //     ...controller.selectedImages.asMap().entries.map((entry) {
                    //       final index = entry.key;
                    //       final file = entry.value;
                    //
                    //       return Stack(
                    //         children: [
                    //           ClipRRect(
                    //             borderRadius: BorderRadius.circular(8),
                    //             child: Image.file(
                    //               file,
                    //               width: 100,
                    //               height: 100,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //           Positioned(
                    //             top: 0,
                    //             right: 0,
                    //             child: GestureDetector(
                    //               onTap: () => controller.removeImage(index),
                    //               child: CircleAvatar(
                    //                 radius: 12,
                    //                 backgroundColor: Colors.red,
                    //                 child: Icon(Icons.close, size: 16, color: Colors.white),
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       );
                    //     }).toList(),
                    //     if (controller.selectedImages.length < 3)
                    //       GestureDetector(
                    //         onTap: () => controller.pickImage(),
                    //         child: Container(
                    //           width: 100,
                    //           height: 100,
                    //           decoration: BoxDecoration(
                    //             border: Border.all(color: Colors.grey),
                    //             borderRadius: BorderRadius.circular(8),
                    //             color: Colors.grey.shade200,
                    //           ),
                    //           child: Icon(Icons.add_a_photo, color: Colors.grey.shade700),
                    //         ),
                    //       )
                    //   ],
                    // )),
                    SizedBox(height: 24.h),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.saveRecord(mode: mode, record: record);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.w, vertical: 16.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r)),
                        ),
                        child: Text("send_record_btn".tr,
                            style: GoogleFonts.notoSansBengali(
                                fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? title : value,
                style: GoogleFonts.notoSansBengali(
                  color: value.isEmpty ? Colors.grey : Colors.black
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
