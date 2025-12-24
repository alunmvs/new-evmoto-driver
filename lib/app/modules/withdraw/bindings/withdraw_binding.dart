import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/bank_account_repository.dart';

import '../controllers/withdraw_controller.dart';

class WithdrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawController>(
      () => WithdrawController(bankAccountRepository: BankAccountRepository()),
    );
  }
}
