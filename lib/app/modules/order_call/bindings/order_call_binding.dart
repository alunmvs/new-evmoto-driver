import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';

import '../controllers/order_call_controller.dart';

class OrderCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderCallController>(
      () => OrderCallController(uploadImageRepository: UploadImageRepository()),
    );
  }
}
