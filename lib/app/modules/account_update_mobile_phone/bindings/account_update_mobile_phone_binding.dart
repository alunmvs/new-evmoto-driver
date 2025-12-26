import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';

import '../controllers/account_update_mobile_phone_controller.dart';

class AccountUpdateMobilePhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountUpdateMobilePhoneController>(
      () => AccountUpdateMobilePhoneController(
        accountRepository: AccountRepository(),
      ),
    );
  }
}
