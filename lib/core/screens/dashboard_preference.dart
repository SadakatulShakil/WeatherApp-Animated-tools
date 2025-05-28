import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/theme_controller.dart';

class DashboardPreference extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeController.themeMode.value == ThemeMode.light
            ? Colors.white
            : Color(0xFF1B76AB),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20,
              color: themeController.themeMode.value == ThemeMode.light
                  ? Colors.black
                  : Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Custom Layout',
          style: TextStyle(
            color: themeController.themeMode.value == ThemeMode.light
                ? Colors.black
                : Colors.white,
          ),
        ),
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
                  controller.saveSectionOrder(); // Save to SharedPreferences
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => Container(
          decoration: BoxDecoration(
            color:
                themeController.themeMode.value == ThemeMode.light
                    ? Colors.white
                    : Color(0xFF1B76AB),
          ),
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) {
                newIndex = newIndex - 1;
              }
              final item = controller.sectionOrder.removeAt(oldIndex);
              controller.sectionOrder.insert(newIndex, item);
            },
            children:
                controller.sectionOrder
                    .map(
                      (section) => Container(
                        color: themeController.themeMode.value ==
                                ThemeMode.light
                            ? Colors.white
                            : Color(0xFF1B76AB),
                        key: ValueKey(section),
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              if (section.name == 'weather_Forecast' || section.name == 'weekly_Forecast') {
                                Get.snackbar(
                                  'Action Restricted',
                                  'You cannot change the visibility of this item.',
                                  backgroundColor: Colors.green.shade400,
                                  snackPosition: SnackPosition.TOP,
                                );
                              } else {
                                controller.updateSectionVisibility(
                                  section,
                                  !controller.sectionVisibility[section]!,
                                );
                              }
                            },
                            child: SvgPicture.asset(
                              (section.name == 'weather_Forecast' || section.name == 'weekly_Forecast' || !(controller.sectionVisibility[section] ?? true))
                                  ? 'assets/svg/invisible_tick.svg'
                                  : 'assets/svg/visible_tick.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          title: Container(
                            decoration: BoxDecoration(
                              color:
                                  themeController.themeMode.value ==
                                          ThemeMode.light
                                      ? Colors.white
                                      : Color(0xFF2A8EC8),
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                color:
                                    themeController.themeMode.value ==
                                            ThemeMode.light
                                        ? Colors.grey.shade300
                                        : Color(0xFF268CC8),
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      section.name.capitalizeFirst!.replaceAll('_', ' ',),
                                      /// beautify the widget name
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: themeController.themeMode.value ==
                                                ThemeMode.light
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  themeController.themeMode.value == ThemeMode.light
                                      ? const Icon(Icons.drag_indicator)
                                      : SvgPicture.asset(
                                    'assets/svg/drag_drop_icon.svg',
                                    width: 10,
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}
