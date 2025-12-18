import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';

import '../controllers/order_detail_done_controller.dart';

class OrderDetailDoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailDoneController>(
      () => OrderDetailDoneController(orderRepository: OrderRepository()),
    );
  }
}
