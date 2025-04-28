import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:package_connector/view/widgets/settings_widget.dart';

import '../../controllers/forecast_controller.dart';

class WeeklyForecastView extends StatelessWidget {
  final ForecastController controller = Get.find<ForecastController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Text('Weekly Forecast'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Get.bottomSheet(
                SettingsBottomSheet(),
                backgroundColor: Colors.white,
              );
            },
          ),
        ],
      ),
        body: Obx(() {
          return ListView.builder(
            itemCount: controller.forecastList.length,
            itemBuilder: (context, index) {
              final item = controller.forecastList[index];

              return ListTile(
                leading: Obx(() {/// every time need to rebuild the icon
                  final iconUrl = controller.iconMode.value == IconMode.twoD
                      ? item.icon2DUrl
                      : item.icon3DUrl;
                  return Image.asset(iconUrl, width: 40, height: 40);
                }),
                title: Text('${item.day} - ${item.date}'),
                subtitle: Text('Min: ${item.minTemp}°C, Max: ${item.maxTemp}°C'),
              );
            },
          );
        }),
    );
  }
}

