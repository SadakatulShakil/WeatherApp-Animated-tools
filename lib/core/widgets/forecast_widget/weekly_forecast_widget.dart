import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/forecast_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../models/weekly_forecast_model.dart'; // Ensure this matches your model file
import '../../screens/fifteendays_forecast_page.dart';
import '../../../core/widgets/forecast_widget/temp_indicator.dart'; // Import your specific widget

class WeeklyForecastView extends StatelessWidget {
  final ForecastController controller = Get.put(ForecastController());
  final ThemeController themeController = Get.find<ThemeController>();
  final HomeController hController = Get.find<HomeController>();

  var isBangla =  Get.locale?.languageCode == 'bn';
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
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: themeController.themeMode.value == ThemeMode.light
              ? [Colors.white, Colors.white]
              : [Color(0xFF3986DD), Color(0xFF3986DD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          GestureDetector(
            onTap: () {
              Get.to(() => FifteenDaysForecastPage());
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    "next_15_days_forecast".tr, // "Next 15 Days"
                    style: TextStyle(
                      color: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "details".tr, // "Details"
                    style: TextStyle(
                      color: themeController.themeMode.value == ThemeMode.light
                          ? Colors.black
                          : Color(0xFF00E5CA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Divider(
              color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.grey.shade300
                  : Colors.grey.shade500,
              height: 1,
            ),
          ),

          // --- List Content ---
          Obx(() {
            // Fetch data reactively. If empty, show loading or fallback.
            final weeklyData = hController.getWeeklyForecast();

            if (weeklyData.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text("data_load_indicator".tr)),
              );
            }

            return Column(
              children: List.generate(weeklyData.length, (index) {
                final item = weeklyData[index];
                // Use controller to get full asset path (e.g., assets/images/ic_sunny.png)
                final iconUrl = controller.getIconUrl(item.iconKey);
                final double rangeDiff = (item.maxTemp - item.minTemp).abs().toDouble();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      // Date & Day
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.day, // e.g. "Wednesday"
                              style: TextStyle(
                                color: themeController.themeMode.value == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item.date, // e.g. "17 Dec, 2025"
                              style: TextStyle(
                                color: themeController.themeMode.value == ThemeMode.light
                                    ? Colors.grey.shade600
                                    : Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Weather Icon
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          iconUrl,
                          width: 30,
                          height: 30,
                          errorBuilder: (c,e,s) => Icon(Icons.wb_sunny, color: Colors.orange),
                        ),
                      ),

                      // Min Temp Text
                      Text( isBangla ? englishToBanglaNumber('${item.minTemp.toInt()}°') :
                        '${item.minTemp.toInt()}°',
                        style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 15,
                        ),
                      ),

                      // Temp Bar Indicator
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              // Assuming AnimatedTempIndicator handles the visual bar length
                              AnimatedTempIndicator(
                                rangeFactor: rangeDiff,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Max Temp Text
                      Text( isBangla ? englishToBanglaNumber('${item.maxTemp.toInt()}°') :
                        '${item.maxTemp.toInt()}°',
                        style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 15,
                        ),
                      ),

                      // Arrow Icon
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.grey
                              : Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}