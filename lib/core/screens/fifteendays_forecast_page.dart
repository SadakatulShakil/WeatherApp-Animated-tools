import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/forecast_details_controller.dart';

class FifteenDaysForecastPage extends StatefulWidget {
  @override
  State<FifteenDaysForecastPage> createState() => _FifteenDaysForecastPageState();
}

class _FifteenDaysForecastPageState extends State<FifteenDaysForecastPage> {
  // Use Get.find if it's already in memory, or put if new
  final ForecastDetailsController controller = Get.put(ForecastDetailsController());

  // Store keys to scroll to specific items
  final List<GlobalKey> _tabKeys = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B76AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B76AB),
        title: Text(controller.isBangla ? 'পরবর্তী ১০ দিন' : 'Next 10 Days'),
        elevation: 0,
        leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // --- TABS (DAYS) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 60,
                child: Obx(() {
                  // Bind to 'dailyTabs'
                  if (controller.dailyTabs.isEmpty) return const SizedBox();

                  // Ensure we have enough keys
                  if (_tabKeys.length != controller.dailyTabs.length) {
                    _tabKeys.clear();
                    for (int i = 0; i < controller.dailyTabs.length; i++) {
                      _tabKeys.add(GlobalKey());
                    }
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.dailyTabs.length,
                    itemBuilder: (context, index) {
                      final item = controller.dailyTabs[index];
                      return Obx(() {
                        // Bind to 'selectedDailyTab'
                        final isSelected = index == controller.selectedDailyTab.value;

                        return GestureDetector(
                          key: _tabKeys[index], // Assign Key
                          onTap: () {
                            controller.updateDailyView(index); // Update Data
                            _scrollToIndex(index); // Auto Scroll
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFF993F)
                                  : const Color(0xFF056AA4),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFFAD66)
                                    : const Color(0xFF3293CC),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    item['dayLabel'],
                                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)
                                ),
                                Text(
                                    item['dateLabel'],
                                    style: const TextStyle(color: Colors.white, fontSize: 12)
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
            ),

            const SizedBox(height: 10),

            // --- FORECAST CARDS LIST ---
            Expanded(
              child: Obx(() {
                // Bind to 'dailyViewData'
                if (controller.dailyViewData.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: controller.dailyViewData.length,
                  itemBuilder: (context, index) {
                    final item = controller.dailyViewData[index];
                    return Card(
                      elevation: 0,
                      color: const Color(0xFF2A8EC8).withOpacity(.4),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFF268CC8), width: 1.5)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              color: const Color(0xFF2A8EC8).withOpacity(.4),
                              border: const Border(bottom: BorderSide(color: Color(0xFF268CC8), width: 1.5)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item['time'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text(item['temperature'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
                              runSpacing: 16,
                              alignment: WrapAlignment.start,
                              children: [
                                _iconLabel(controller.isBangla ? 'বৃষ্টির সম্ভাবনা' : 'Rain Chance', item['rainChance'], icon: Icons.water_drop_outlined),
                                _iconLabel(controller.isBangla ? 'বৃষ্টির পরিমাণ' : 'Rain Amount', item['rainAmount'], icon: Icons.grain),
                                _iconLabel(controller.isBangla ? 'আর্দ্রতা' : 'Humidity', item['humidity'], icon: Icons.opacity),
                                _iconLabel(controller.isBangla ? 'বাতাসের গতি' : 'Wind Speed', item['windSpeed'], icon: Icons.air),
                                _iconLabel(controller.isBangla ? 'মেঘ' : 'Cloud', item['cloud'], icon: Icons.cloud_outlined),
                                _iconLabel(controller.isBangla ? 'দৃষ্টিসীমা' : 'Visibility', item['visibility'], icon: Icons.visibility_outlined),
                                _iconLabel(controller.isBangla ? 'বাতাসের দিক' : 'Wind Direction', item['windDirection'], icon: Icons.explore),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  // --- Scroll Logic ---
  void _scrollToIndex(int index) {
    if (index >= 0 && index < _tabKeys.length) {
      final context = _tabKeys[index].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5, // Center the item
        );
      }
    }
  }

  Widget _iconLabel(String label, String value, {IconData icon = Icons.info_outline}) {
    return SizedBox(
      width: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}