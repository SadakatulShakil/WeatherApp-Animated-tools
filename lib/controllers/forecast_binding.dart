import 'package:get/get.dart';
import 'package:package_connector/controllers/forecast_controller.dart';


class ForecastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForecastController>(
          () => ForecastController(),
    );
  }
}
