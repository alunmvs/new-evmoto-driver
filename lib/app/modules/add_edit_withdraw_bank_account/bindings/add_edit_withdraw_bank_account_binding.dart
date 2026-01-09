import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/bank_account_repository.dart';

import '../controllers/add_edit_withdraw_bank_account_controller.dart';

class AddEditWithdrawBankAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditWithdrawBankAccountController>(
      () => AddEditWithdrawBankAccountController(
        bankAccountRepository: BankAccountRepository(),
      ),
    );
  }
}
