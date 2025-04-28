import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/forecast_controller.dart';

class SettingsBottomSheet extends StatelessWidget {
  final ForecastController controller = Get.find<ForecastController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Choose Icon Style', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

          Obx(() => Column(
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('2D Icons'),
                trailing: Radio<IconMode>(
                  value: IconMode.twoD,
                  groupValue: controller.iconMode.value,
                  onChanged: (mode) {
                    controller.switchIconMode(mode!);
                    Get.back(); // Close the bottom sheet after selection
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.image_outlined),
                title: Text('3D Icons'),
                trailing: Radio<IconMode>(
                  value: IconMode.threeD,
                  groupValue: controller.iconMode.value,
                  onChanged: (mode) {
                    controller.switchIconMode(mode!);
                    Get.back(); // Close the bottom sheet after selection
                  },
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
