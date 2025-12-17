import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';

import '../controllers/account_my_evaluation_controller.dart';

class AccountMyEvaluationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountMyEvaluationController>(
      () =>
          AccountMyEvaluationController(accountRepository: AccountRepository()),
    );
  }
}
