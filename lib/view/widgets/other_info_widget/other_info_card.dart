import 'package:flutter/material.dart';
import 'package:package_connector/view/widgets/other_info_widget/precipitation_card.dart';
import 'package:package_connector/view/widgets/other_info_widget/uv_index_card.dart';
import 'package:package_connector/view/widgets/other_info_widget/visibility_card.dart';

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
          title: 'Precipitation',
          value: '0',
          unit: 'mm',
          subtitle: '0 mm precipitation is expected in the next 24 hours',
          icon: Icons.grain,
        ),
        UvIndexCard(
          title: 'UV Index',
          value: '4',
          unit: '',
          subtitle: 'Pay attention to sun protection at 15:00',
          icon: Icons.wb_sunny,
        ),
        HumidityCard(
          title: 'Humidity',
          value: '37',
          unit: '%',
          subtitle: 'The dew point is 17.8°C right now',
          icon: Icons.water_drop,
        ),
        VisibilityCard(
          title: 'Visibility',
          value: '9.8',
          unit: 'km',
          subtitle: 'Poor visibility, vision is not clear.',
          icon: Icons.visibility,
        ),
      ],
    );
  }
}

