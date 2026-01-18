import 'package:bmd_weather_app/controllers/home_controller.dart';
import 'package:bmd_weather_app/core/widgets/other_info_widget/precipitation_card.dart';
import 'package:bmd_weather_app/core/widgets/other_info_widget/uv_index_card.dart';
import 'package:bmd_weather_app/core/widgets/other_info_widget/visibility_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'humidity_card.dart';

class OtherInfoCards extends StatelessWidget {
  OtherInfoCards({super.key});

  final HomeController controller = Get.find<HomeController>();
  final isBangla = Get.locale?.languageCode == 'bn';

  @override
  Widget build(BuildContext context) {
    final current = controller.forecast.value?.result?.current;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.only(left: 4, right: 4),
      mainAxisSpacing: 12,
      childAspectRatio: 0.70, // <<< Important! Adjust card height!
      children: [
        PrecipitationCard(
          title: 'rainfall_title'.tr,
          value: current?.rf?.valAvg ?? '0',
          start: current?.start ?? '',
          end: current?.end ?? '',
          unit: current?.rfUnit ?? 'মিমি.',
          icon: Icons.grain,
        ),
        UvIndexCard(
          title: 'uv_index_title'.tr,
          value: current?.uv ?? '0',
          start: current?.start ?? '',
          end: current?.end ?? '',
          unit: '',
          icon: Icons.wb_sunny,
        ),
        HumidityCard(
          title: 'humidity_title'.tr,
          value: current?.rh?.valAvg ?? '0',
          start: current?.start ?? '',
          end: current?.end ?? '',
          unit: current?.rhUnit ?? '%.',
          icon: Icons.water_drop,
        ),
        VisibilityCard(
          title: 'visibility_title'.tr,
          value: current?.vis ?? '0',
          start: current?.start ?? '',
          end: current?.end ?? '',
          unit: isBangla? 'কিমি.' : 'km',
          icon: Icons.visibility,
        ),
      ],
    );
  }
}

