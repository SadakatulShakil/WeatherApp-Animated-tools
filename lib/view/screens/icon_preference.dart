import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/forecast_controller.dart';
import '../widgets/other_info_widget/icon_row_widget.dart';

class IconPreferencePage extends StatelessWidget {
  final ForecastController controller = Get.find<ForecastController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Icon Style')),
      body: Obx(() {
        return ListView(
          children: controller.iconPackages.keys.map((modeName) {
            final isSelected = controller.iconMode.value == modeName;
            final iconList = controller.iconPackages[modeName] ?? [];

            return GestureDetector(
              onTap: () => controller.switchIconMode(modeName),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                child: Card(
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
                              onChanged: (value) => controller.switchIconMode(value!),
                            ),
                            Text(
                              modeName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
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
        );
      }),
    );
  }
}

