import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../water_watch_controller/dashboard/DashboardController.dart';
import '../water_watch_controller/my_record/my_record_conttroller.dart';
import '../water_watch_models/station_history_model.dart';

class MyRecordPage extends StatefulWidget {
  MyRecordPage({super.key});

  @override
  State<MyRecordPage> createState() => _MyRecordPageState();
}

class _MyRecordPageState extends State<MyRecordPage>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(MyRecordController(), permanent: true);
  final _expandedDates = <String>{};

  late TabController _tabController;
  var isBangla = Get.locale?.languageCode == 'bn';

  String englishToBanglaNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bangla  = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], bangla[i]);
    }
    return output;
  }

  String formatTime(DateTime dateTime) {
    print('check_format: $dateTime');
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String amPm = hour >= 12 ? "PM" : "AM";
    int hour12 = hour % 12;
    if (hour12 == 0) hour12 = 12; // handle 12 AM/PM
    return "${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $amPm";
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'my_record'.tr,
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF5AAFE5),
                        Color(0xFF3B8DD2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.water, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            "water_level".tr,
                            style: GoogleFonts.notoSansBengali(
                              letterSpacing: 0.3.sp,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloudy_snowing,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "rainfall".tr,
                            style: GoogleFonts.notoSansBengali(
                              letterSpacing: 0.3.sp,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Water Level
                    Obx(() {
                      final waterLevel = controller.waterLevelGroupedRecordsByDate;
                      print('objecttive1: ${waterLevel.length}');
                      return _buildRecordList(waterLevel);
                    }),

                    // Tab 2: Rainfall
                    Obx(() {
                      final rainfall = controller.rainfallGroupedRecordsByDate;
                      print('objecttive2: ${rainfall.length}');
                      return _buildRecordList(rainfall);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordList(RxMap<String, List<StationHistoryModel>> grouped) {
    if (grouped.isEmpty) {
      return Center(
        child: Text(
          'empty_data'.tr,
          style: GoogleFonts.notoSansBengali(fontSize: 16.sp, ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        final date = entry.key;
        final records = entry.value;
        final isExpanded = _expandedDates.contains(date);

        return Card(
          margin: EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  isBangla
                      ?englishToBanglaNumber(date)
                      :date,
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedDates.remove(date);
                    } else {
                      _expandedDates.add(date);
                    }
                  });
                },
              ),
              if (isExpanded) ...[
                _buildTableHeader(),
                ...records.map(
                      (record) => _buildRecordRow(
                    record,
                    records.indexOf(record),
                    records.length,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border.all(color: Colors.blue),
        color: Colors.blue.shade50,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'time'.tr,
                style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, fontSize: 14.sp),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  'measurement'.tr,
                  style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold,fontSize: isBangla?14.sp:10.sp),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'station'.tr,
                style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                'status'.tr,
                style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, fontSize: 14.sp,),
                textAlign: TextAlign.center,
              ),
            ),
            // Expanded(
            //   child: Text(
            //     'media'.tr,
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordRow(StationHistoryModel record, int index, int totalRecords) {
    final dashboardController = Get.find<WaterWatchDashboardController>();
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blue),
          top: BorderSide(color: Colors.blue),
          right: BorderSide(color: Colors.blue),
          bottom: BorderSide(
            color: Colors.blue,
            width:
            index == totalRecords - 1
                ? 1.0
                : 0.0, // Only show bottom border for last item
          ),
        ),
        borderRadius:
        index == totalRecords - 1
            ? BorderRadius.only(
          bottomLeft: Radius.circular(8.r),
          bottomRight: Radius.circular(8.r),
        )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Row(
          children: [
            // Time
            Expanded(
              child: Text(
                isBangla
                    ?englishToBanglaNumber(formatTime(record.observationDate))
                    :formatTime(record.observationDate),
                style: GoogleFonts.notoSansBengali(fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
            ),

            // Quantity
            Text(
              isBangla
                  ?englishToBanglaNumber(record.waterLevel)
                  :record.waterLevel,
              style: GoogleFonts.notoSansBengali(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),

            //Location
            Expanded(
              child: Text(
                dashboardController.getStationNameById(record.station.toString()),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 12.sp,
                  color: Colors.blueGrey,
                ),
              ),
            ),

            // Media
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      record.isAcepted ? Icons.check_circle : Icons.sync_problem,
                      color: record.isAcepted ? Colors.green : Colors.orange,
                      size: 18.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaImage(String filePath) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w),
      child: GestureDetector(
        onTap: () {
          Get.dialog(
            Dialog(
              backgroundColor: Colors.black,
              insetPadding: EdgeInsets.all(10.r),
              child: InteractiveViewer(
                child: Image.file(
                  File(Uri.parse(filePath).path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.file(
            File(Uri.parse(filePath).path), // Important: convert URI to path
            width: 20.w,
            height: 20.h,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

