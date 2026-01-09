import 'package:get/get.dart';

import '../controllers/withdraw_amount_controller.dart';

class WithdrawAmountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawAmountController>(
      () => WithdrawAmountController(),
    );
  }
}
