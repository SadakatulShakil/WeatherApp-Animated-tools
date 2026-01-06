import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/forecast_details_controller.dart';

class HourlyForecastDetailsPage extends StatefulWidget {
  @override
  State<HourlyForecastDetailsPage> createState() => _HourlyForecastDetailsPageState();
}

class _HourlyForecastDetailsPageState extends State<HourlyForecastDetailsPage> {
  // Use Get.find to reuse the existing instance if created before, or Put if not.
  final ForecastDetailsController controller = Get.put(ForecastDetailsController());

  // List to store keys for each tab item
  final List<GlobalKey> _tabKeys = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B76AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B76AB),
        elevation: 0,
        title: const Text('পরবর্তী ৭২ ঘন্টার পূর্বাভাস'),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Obx(() {
            // -- TABS SECTION --
            if (controller.hourlyTabs.isEmpty) return const SizedBox();

            // Ensure we have enough keys for the tabs
            if (_tabKeys.length != controller.hourlyTabs.length) {
              _tabKeys.clear();
              for (int i = 0; i < controller.hourlyTabs.length; i++) {
                _tabKeys.add(GlobalKey());
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(controller.hourlyTabs.length, (index) {
                    return Obx(() {
                      bool isSelected = controller.selectedHourlyTab.value == index;

                      return GestureDetector(
                        // Assign the unique key here
                        key: _tabKeys[index],
                        onTap: () {
                          // 1. Update Data
                          controller.updateHourlyView(index);

                          // 2. Auto Scroll to this item
                          _scrollToIndex(index);
                        },
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 80),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFF993F)
                                : const Color(0xFF056AA4),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFFAD66)
                                  : const Color(0xFF3293CC),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              controller.hourlyTabs[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  }),
                ),
              ),
            );
          }),
        ),
      ),

      // -- BODY LIST SECTION --
      body: Obx(() {
        if (controller.hourlyViewData.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: controller.hourlyViewData.length,
          itemBuilder: (context, index) {
            final item = controller.hourlyViewData[index];
            return Card(
              elevation: 0,
              color: const Color(0xFF2A8EC8).withOpacity(.4),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF268CC8), width: 1.5)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Header
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

                  // Item Details Grid
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 16,
                      alignment: WrapAlignment.start,
                      children: [
                        _iconLabel('বৃষ্টির সম্ভাবনা', item['rainChance'], icon: Icons.water_drop_outlined),
                        _iconLabel('বৃষ্টির পরিমাণ', item['rainAmount'], icon: Icons.grain),
                        _iconLabel('আর্দ্রতা', item['humidity'], icon: Icons.opacity),
                        _iconLabel('বাতাসের গতি', item['windSpeed'], icon: Icons.air),
                        _iconLabel('মেঘ', item['cloud'], icon: Icons.cloud_outlined),
                        _iconLabel('দূরদর্শিতা', item['visibility'], icon: Icons.visibility_outlined),
                        _iconLabel('অতিবেগুনী রশ্মি', item['uvIndex'], icon: Icons.wb_sunny_outlined),
                        _iconLabel('বাতাসের দিক', item['windDirection'], icon: Icons.explore_outlined),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }),
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
          alignment: 0.5, // 0.5 means center the item in the viewport
        );
      }
    }
  }

  Widget _iconLabel(String label, String value, {IconData icon = Icons.info_outline}) {
    return SizedBox(
      width: 95,
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