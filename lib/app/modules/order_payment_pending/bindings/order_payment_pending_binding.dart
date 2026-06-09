import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';

import '../controllers/order_payment_pending_controller.dart';

class OrderPaymentPendingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderPaymentPendingController>(
      () => OrderPaymentPendingController(orderRepository: OrderRepository()),
    );
  }
}
