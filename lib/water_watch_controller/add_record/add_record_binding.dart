import 'package:get/get.dart';

import 'add_record_controller.dart';

class AddRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddRecordController>(
          () => AddRecordController(),
    );
  }
}
