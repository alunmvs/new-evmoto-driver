import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/withdraw_repository.dart';

import '../controllers/withdraw_amount_controller.dart';

class WithdrawAmountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawAmountController>(
      () => WithdrawAmountController(withdrawRepository: WithdrawRepository()),
    );
  }
}
