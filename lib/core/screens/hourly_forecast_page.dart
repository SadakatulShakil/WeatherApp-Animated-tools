import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/forecast_details_controller.dart';

class HourlyForecastDetailsPage extends StatelessWidget {
  final ForecastDetailsController controller = Get.put(ForecastDetailsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.hourTabs.length,
      child: Scaffold(
        backgroundColor: const Color(0xFF1B76AB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1B76AB),
          elevation: 0,
          title: const Text('পরবর্তী ৭২ ঘন্টার পূর্বাভাস'),
          leading:  GestureDetector(
            onTap: () => Get.back(),
              child: Icon(Icons.arrow_back_ios)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(controller.hourTabs.length, (index) {
                    return GestureDetector(
                      onTap: () => controller.selectedHourTab.value = index,
                      child: Container(
                        width: 100, // You can adjust width as needed
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: controller.selectedHourTab.value == index
                              ? Color(0xFFFF993F)
                              : Color(0xFF056AA4),
                          border: Border.all(
                            color: controller.selectedHourTab.value == index
                                ? Color(0xFFFFAD66)
                                : Color(0xFF3293CC),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            controller.hourTabs[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )),
          ),
        ),
        body: ListView.builder(
          itemCount: controller.forecastData.length,
          itemBuilder: (context, index) {
            final item = controller.forecastData[index];
            return Card(
              elevation: 0,
              color: Color(0xFF2A8EC8).withOpacity(.4),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Color(0xFF268CC8), width: 1.5)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF2A8EC8).withOpacity(.4),
                      border: Border.all(color: Color(0xFF268CC8), width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 12, bottom: 12, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['time'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text(item['temperature'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(item['date'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _iconLabel('বৃষ্টিপাতের সম্ভাবনা', item['rainChance'], icon: Icons.water_drop_outlined),
                        _iconLabel('বৃষ্টিপাত পরিমাণ', item['rainAmount'], icon: Icons.water_outlined),
                        _iconLabel('আর্দ্রতা', item['humidity'], icon: Icons.water_drop_outlined),
                        _iconLabel('দূরদর্শিতা', item['visibility'], icon: Icons.visibility_outlined),
                        _iconLabel('অতিবেগুনী রশ্মি', item['uvIndex'], icon: Icons.wb_sunny_outlined),
                        _iconLabel('বাতাসের গতি', item['windSpeed'], icon: Icons.air_outlined),
                        _iconLabel('বাতাসের দিক', item['windDirection'], icon: Icons.navigation_outlined),
                        _iconLabel('মেঘ', item['cloud']),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _iconLabel(String label, String value, {IconData icon = Icons.info_outline}) {
    return SizedBox(
      width: 90,
      height: 65,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon( icon, color: Colors.white),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
