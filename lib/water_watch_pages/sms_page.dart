import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database_helper/entity/local_location_entity.dart';
import '../database_helper/entity/local_parameter_entity.dart';
import '../water_watch_controller/dashboard/DashboardController.dart';
import '../water_watch_controller/sms/sms_controller.dart';

class SmsPage extends StatefulWidget {
  @override
  State<SmsPage> createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  final SmsController controller = Get.put(SmsController());

  final dashboardController = Get.find<WaterWatchDashboardController>();

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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Text(
                'send_sms_title'.tr,
                style: GoogleFonts.notoSansBengali(
                    fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Obx(() => SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDropdown(
                        title: "select_parameter".tr,
                        value: Get.locale?.languageCode == 'bn'
                            ? controller.selectedParameter.value?.titleBn ?? ''
                            : controller.selectedParameter.value?.title ?? '',
                        onTap: () => _showBottomSheet<ParameterEntity>(
                          context,
                          dashboardController.parameters,
                          controller.selectedParameter,
                              (item) => Get.locale?.languageCode == 'bn' ? item.titleBn : item.title,
                              (item) => item.id,
                          onSelected: (_) => controller.updateStationList(),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Station second
                      buildDropdown(
                        title: "select_station".tr,
                        value: controller.selectedStation.value == null
                            ? ''
                            : (Get.locale?.languageCode == 'bn'
                            ? controller.selectedStation.value.nameBn
                            : controller.selectedStation.value.name),
                        onTap: () => _showBottomSheet(
                          context,
                          controller.availableStations,
                          controller.selectedStation,
                              (item) => Get.locale?.languageCode == 'bn' ? item.nameBn : item.name,
                              (item) => item.stationId.toString(),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("select_date".tr,
                          style: GoogleFonts.notoSansBengali(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      Text("date_msg".tr),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () => controller.pickDate(context),
                        child: buildDropdown(
                          title: "select_date".tr,
                          value:  isBangla?
                          englishToBanglaNumber(controller.selectedDate.value.toLocal().toString().split(' ')[0])
                              :"${controller.selectedDate.value.toLocal()}"
                              .split(' ')[0],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Dynamic Rows
                      ...List.generate(
                        controller.timeMeasurements.length,
                            (index) {
                          final item = controller.timeMeasurements[index];
                          final isLast =
                              index == controller.timeMeasurements.length - 1;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              children: [
                                // Time Picker
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () => controller
                                        .pickTimeByItem(item, context),
                                    child: buildDropdown(
                                      title: "time".tr,
                                      value: isBangla
                                          ? englishToBanglaNumber(item['time'].toString())
                                          : item['time'] ?? '',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),

                                // Measurement input
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    onChanged: (v) =>
                                        controller.updateMeasurementByItem(
                                            item, v),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "measurement_value".tr,
                                      hintStyle: GoogleFonts.notoSansBengali(
                                          color: Colors.grey.shade600,
                                          fontSize: isBangla? 15.sp : 14.sp,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),

                                // Delete icon (only for last row)
                                isLast
                                    ? Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => controller
                                        .removeTimeMeasurementByItem(
                                        item),
                                    iconSize: 18.h,
                                    padding: EdgeInsets.zero,
                                  ),
                                )
                                    : Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white60,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.delete,
                                      color: Colors.red.shade100),
                                ),
                                SizedBox(width: 8.w),

                                // Add icon or check
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: isLast
                                        ? Colors.blue.shade900
                                        : Colors.green.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: isLast
                                      ? IconButton(
                                    icon: Icon(Icons.add,
                                        color: Colors.white),
                                    onPressed: () => controller
                                        .addTimeMeasurement(),
                                    iconSize: 20.h,
                                    padding: EdgeInsets.zero,
                                  )
                                      : Icon(Icons.check,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 24.h),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => controller.saveRecord(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r)),
                          ),
                          child: Text("send_sms_title".tr, style: GoogleFonts.notoSansBengali(fontSize: 16.sp,color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String title,
    required String value,
    VoidCallback? onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? title : value,
                style: GoogleFonts.notoSansBengali(
                  color: value.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet<T>(
      BuildContext context,
      List<T> items,
      Rx<T?> selectedValue,
      String Function(T) getLabel,
      String Function(T) getId, {
        void Function(T)? onSelected,
      }) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: items.map((item) {
            final label = getLabel(item);
            final isSelected = selectedValue.value != null &&
                getId(selectedValue.value as T) == getId(item);

            return ListTile(
              title: Text(label),
              trailing: isSelected
                  ? Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                selectedValue.value = item;
                if (onSelected != null) onSelected(item);
                Get.back();
              },
            );
          }).toList(),
        );
      },
    );
  }

}
