import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';

import '../controllers/account_feedback_controller.dart';

class AccountFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountFeedbackController>(
      () => AccountFeedbackController(accountRepository: AccountRepository()),
    );
  }
}
