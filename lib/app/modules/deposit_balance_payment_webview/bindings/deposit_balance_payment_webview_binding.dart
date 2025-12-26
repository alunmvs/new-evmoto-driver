import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/payment_repository.dart';

import '../controllers/deposit_balance_payment_webview_controller.dart';

class DepositBalancePaymentWebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepositBalancePaymentWebviewController>(
      () => DepositBalancePaymentWebviewController(
        paymentRepository: PaymentRepository(),
      ),
    );
  }
}
