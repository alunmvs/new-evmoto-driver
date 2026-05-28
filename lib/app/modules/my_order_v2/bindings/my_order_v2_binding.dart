import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';

import '../controllers/my_order_v2_controller.dart';

class MyOrderV2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyOrderV2Controller>(
      () => MyOrderV2Controller(orderRepository: OrderRepository()),
    );
  }
}
