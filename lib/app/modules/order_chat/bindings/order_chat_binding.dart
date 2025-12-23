import 'package:get/get.dart';

import '../controllers/order_chat_controller.dart';

class OrderChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderChatController>(
      () => OrderChatController(),
    );
  }
}
