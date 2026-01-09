import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';

import '../controllers/order_chat_controller.dart';

class OrderChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderChatController>(
      () => OrderChatController(uploadImageRepository: UploadImageRepository()),
    );
  }
}
