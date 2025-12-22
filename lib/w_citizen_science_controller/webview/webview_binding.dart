import 'package:bmd_weather_app/w_citizen_science_controller/webview/webview_controller.dart';
import 'package:get/get.dart';

class WebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewController>(
      () => WebviewController(),
    );
  }
}
