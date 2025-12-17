import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';

import '../controllers/account_service_controller.dart';

class AccountServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountServiceController>(
      () => AccountServiceController(accountRepository: AccountRepository()),
    );
  }
}
