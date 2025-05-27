import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class VisibilityPreference extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visibility Sections'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              controller.saveVisibilitySettings(); // Save to SharedPreferences
              Get.back();
            },
          ),
        ],
      ),
      body: Column(
        children: HomeSection.values.map((section) {
          return Obx(() => SwitchListTile(
            title: Text(section.name.capitalizeFirst!.replaceAll('_', ' ')), // Beautify the widget name
            value: controller.sectionVisibility[section] ?? true,
            onChanged: (value) {
              controller.updateSectionVisibility(section, value);
            },
          ));
        }).toList(),
      ),
    );
  }
}

