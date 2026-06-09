import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';

import '../controllers/order_payment_pending_fee_detail_controller.dart';

class OrderPaymentPendingFeeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderPaymentPendingFeeDetailController>(
      () => OrderPaymentPendingFeeDetailController(
        orderRepository: OrderRepository(),
      ),
    );
  }
}
