import 'package:get/get.dart';

import 'forecast_controller.dart';


class ForecastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForecastController>(
          () => ForecastController(),
    );
  }
}
