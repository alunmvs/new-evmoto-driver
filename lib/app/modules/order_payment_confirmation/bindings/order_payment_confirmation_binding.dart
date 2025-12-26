import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';

import '../controllers/order_payment_confirmation_controller.dart';

class OrderPaymentConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderPaymentConfirmationController>(
      () => OrderPaymentConfirmationController(
        orderRepository: OrderRepository(),
      ),
    );
  }
}
