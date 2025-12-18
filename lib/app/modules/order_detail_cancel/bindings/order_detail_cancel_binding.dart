import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';

import '../controllers/order_detail_cancel_controller.dart';

class OrderDetailCancelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailCancelController>(
      () => OrderDetailCancelController(orderRepository: OrderRepository()),
    );
  }
}
