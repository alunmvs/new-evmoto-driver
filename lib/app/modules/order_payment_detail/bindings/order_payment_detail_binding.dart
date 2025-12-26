import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';

import '../controllers/order_payment_detail_controller.dart';

class OrderPaymentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderPaymentDetailController>(
      () => OrderPaymentDetailController(orderRepository: OrderRepository()),
    );
  }
}
