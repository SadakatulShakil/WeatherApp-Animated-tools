import 'package:bmd_weather_app/core/widgets/other_info_widget/precipitation_card.dart';
import 'package:bmd_weather_app/core/widgets/other_info_widget/uv_index_card.dart';
import 'package:bmd_weather_app/core/widgets/other_info_widget/visibility_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'humidity_card.dart';

class OtherInfoCards extends StatelessWidget {
  const OtherInfoCards({super.key});

  @override
  Widget build(BuildContext context) {
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
          value: '০',
          unit: 'মিমি.',
          subtitle: 'আগামী ২৪ ঘন্টায় ০ মিমি বৃষ্টিপাতের সম্ভাবনা রয়েছে।',
          icon: Icons.grain,
        ),
        UvIndexCard(
          title: 'uv_index_title'.tr,
          value: '৪',
          unit: '',
          subtitle: '১৫:০০ টায় সূর্য সুরক্ষার দিকে মনোযোগ দিন',
          icon: Icons.wb_sunny,
        ),
        HumidityCard(
          title: 'humidity_title'.tr,
          value: '৩৭',
          unit: '%',
          subtitle: 'শিশির বিন্দু এখন ১৭.৮° সেলসিয়াস।',
          icon: Icons.water_drop,
        ),
        VisibilityCard(
          title: 'visibility_title'.tr,
          value: '৯.৮',
          unit: 'কি.মি',
          subtitle: 'দৃশ্যমানতার পরিমাণ কম, দৃষ্টি স্পষ্ট নয়।',
          icon: Icons.visibility,
        ),
      ],
    );
  }
}

