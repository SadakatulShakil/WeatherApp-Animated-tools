import 'package:get/get.dart';
import 'navigation_controller.dart';
class WaterWatchNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaterWatchNavigationController>(
      () => WaterWatchNavigationController(),
    );
  }
}
