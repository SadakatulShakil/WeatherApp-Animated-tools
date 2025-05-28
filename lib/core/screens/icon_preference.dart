import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/forecast_controller.dart';
import '../../controllers/theme_controller.dart';
import '../widgets/other_info_widget/icon_row_widget.dart';

class IconPreferencePage extends StatelessWidget {
  final ForecastController controller = Get.find<ForecastController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20,
              color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.black
                  : Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
          title: Text('Select Icon Style',
            style: TextStyle(
              color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        backgroundColor: themeController.themeMode.value == ThemeMode.light
            ? Colors.white
            : Color(0xFF1B76AB),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: themeController.themeMode.value == ThemeMode.light
                  ? Colors.grey
                  : Colors.blue,
              radius: 16,
              child: IconButton(
                icon: Icon(Icons.save, color: Colors.white, size: 16),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Container(
          decoration: BoxDecoration(
            color:
            themeController.themeMode.value == ThemeMode.light
                ? Colors.white
                : Color(0xFF1B76AB),
          ),
          child: ListView(
            children: controller.iconPackages.keys.map((modeName) {
              final isSelected = controller.iconMode.value == modeName;
              final iconList = controller.iconPackages[modeName] ?? [];

              return GestureDetector(
                onTap: () => controller.switchIconMode(modeName),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                  child: Card(
                    color: isSelected ? Colors.grey.shade200 : Colors.white,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: modeName,
                                groupValue: controller.iconMode.value,
                                activeColor: Colors.blue,
                                onChanged: (value) => controller.switchIconMode(value!),
                              ),
                              Text(
                                modeName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.blue : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: iconList.map((icon) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
                                child: Image.asset(
                                  icon.iconUrl,
                                  width: 40,
                                  height: 40,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}

