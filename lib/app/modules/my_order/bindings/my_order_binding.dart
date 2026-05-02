import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';

import '../controllers/my_order_controller.dart';

class MyOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyOrderController>(
      () => MyOrderController(orderRepository: OrderRepository()),
    );
  }
}
