import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class DashboardPreference extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reorder Sections'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              controller.saveSectionOrder(); // Save to SharedPreferences
              Get.back();
            },
          ),
        ],
      ),
      body: Obx(
            () => ReorderableListView(
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex){
              newIndex = newIndex - 1;
            }
            final item = controller.sectionOrder.removeAt(oldIndex);
            controller.sectionOrder.insert(newIndex, item);
          },
          children: controller.sectionOrder
              .map((section) => Card(
            key: ValueKey(section),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text(
                section.name.capitalizeFirst!.replaceAll('_', ' '),/// beautify the widget name
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.drag_indicator),
            ),
          ))
              .toList(),
        ),
      ),
    );
  }
}

