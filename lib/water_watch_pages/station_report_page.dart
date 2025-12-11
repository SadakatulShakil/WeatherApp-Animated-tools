import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database_helper/entity/local_parameter_entity.dart';
import '../utills/app_color.dart';
import '../water_watch_controller/dashboard/DashboardController.dart';
import '../water_watch_controller/station_report/station_record_controller.dart';
import 'add_report_page.dart';
import 'graphical_page.dart';
import 'history_page.dart';

class WaterWatchStationReportPage extends StatefulWidget {
  final int tabIndex;
  const WaterWatchStationReportPage({super.key, this.tabIndex = 0});
  @override
  State<WaterWatchStationReportPage> createState() => _WaterWatchStationReportPageState();
}

class _WaterWatchStationReportPageState extends State<WaterWatchStationReportPage> with SingleTickerProviderStateMixin {
  final StationRecordController controller = Get.put(StationRecordController());
  final dashboardController = Get.find<WaterWatchDashboardController>();
  late TabController _tabController;
  final isBangla = Get.locale?.languageCode == 'bn';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.tabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () => Get.back(),
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
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ElevatedButton(
                onPressed: () async {
                  // Add your button action here
                  final result = await Get.to(AddReportPage(),
                      arguments: {'item': controller.locationData, 'type': controller.type},
                      transition: Transition.rightToLeft);
                  if (result == 'refresh') {
                    controller.onRefresh();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text("add_record".tr, style: GoogleFonts.notoSansBengali(color: Colors.white,),),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          // Add TabBar
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5AAFE5), Color(0xFF3B8DD2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.storage),
                      SizedBox(width: 8.w),
                      Text("history_title".tr),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_graph),
                      SizedBox(width: 8.w),
                      Text("graph_title".tr),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: HistoryPage()), // Replace with your actual widgets
                Center(child: GraphicalPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown({required String title, required String value, VoidCallback? onTap}) {
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
}
