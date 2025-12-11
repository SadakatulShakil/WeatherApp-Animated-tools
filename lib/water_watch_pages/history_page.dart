import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../water_watch_controller/station_report/station_record_controller.dart';
import '../water_watch_models/station_history_model.dart';
import 'add_report_page.dart';

class HistoryPage extends StatelessWidget {

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StationRecordController>();
    controller.fetchStationHistory();
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

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: Lottie.asset('assets/json/loading_anim.json', width: 80, height: 80));
      }
      if (controller.errorMessage.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }
      final grouped = controller.groupedRecordsByDate;
      if (grouped.isEmpty) {
        return Center(child: Text('no_results_found'.tr));
      }

      return RefreshIndicator(
        onRefresh: controller.fetchStationHistory,
        child: ListView(
          padding: EdgeInsets.all(16.r),
          children: grouped.entries.map((entry) {
            final date = entry.key;
            final records = entry.value;
            final isExpanded = controller.isDateExpanded(date);

            return Card(
              color: Color(0xFFE1F4FF),
              margin: EdgeInsets.only(bottom: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('কালেকশনের তারিখঃ'.tr, style: GoogleFonts.notoSansBengali(fontSize: 12.sp, color: Colors.black54),),
                        Text(
                          isBangla
                              ?englishToBanglaNumber(date)
                              :date,
                          style: GoogleFonts.notoSansBengali(
                              fontSize: 18.sp, fontWeight: FontWeight.bold, color: Color(0xFF0D6EA8)),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Color(0xFF0D6EA8)
                    ),
                    onTap: () => controller.toggleExpand(date),
                  ),
                  if (isExpanded) ...[
                    _buildTableHeader(),
                    ...records.map((record) => _buildRecordRow(record, controller)),
                  ]
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  void _confirmDelete(StationHistoryModel record, StationRecordController controller) {
    Get.dialog(
      AlertDialog(
        title: Text("confirm_delete_title".tr),
        content: Text("confirm_delete_msg".tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("no".tr),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.deleteRecord(record.id); // implement this
            },
            child: Text("yes".tr, style: GoogleFonts.notoSansBengali(color: Colors.red,)),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Color(0xFFCDE7F7),
      child: Row(
        children: [
          Expanded(child: Text("time_header".tr, style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, color: Colors.black,),)),
          Expanded(child: Text("water_level_heder".tr, style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center)),
          Expanded(child: Text("status_header".tr, style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildRecordRow(StationHistoryModel record, StationRecordController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.blue.shade100),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              Get.locale?.languageCode == 'bn'
                  ?englishToBanglaNumber(DateFormat('hh:mm a').format(record.observationDate).toString())
                  :DateFormat('hh:mm a').format(record.observationDate).toString(),
              style: GoogleFonts.notoSansBengali(color: Colors.black87 ),
            ),
          ),
          Expanded(
            child: Text(
              Get.locale?.languageCode == 'bn'
                  ?englishToBanglaNumber(record.waterLevel)
                  :record.waterLevel,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansBengali(color: Colors.black87 ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // Navigate to AddRecordPage with prefilled data
                      final result = await Get.to(
                        AddReportPage(),
                        arguments: {
                          'item': controller.locationData,
                          'record': record,
                          'mode': 'update',
                          'type': controller.type
                        },
                        transition: Transition.rightToLeft,
                      );
                      if (result == 'refresh') {
                        controller.onRefresh();
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/svg/edit.svg',
                      width: 22.w,
                      height: 22.h,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      _confirmDelete(record, controller);
                    },
                    child: SvgPicture.asset(
                      'assets/svg/delete.svg',
                      width: 22.w,
                      height: 22.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String englishToBanglaNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bangla  = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], bangla[i]);
    }
    return output;
  }
}
