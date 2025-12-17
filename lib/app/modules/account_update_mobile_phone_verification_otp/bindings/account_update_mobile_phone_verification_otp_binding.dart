import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';

import '../controllers/account_update_mobile_phone_verification_otp_controller.dart';

class AccountUpdateMobilePhoneVerificationOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountUpdateMobilePhoneVerificationOtpController>(
      () => AccountUpdateMobilePhoneVerificationOtpController(
        accountRepository: AccountRepository(),
      ),
    );
  }
}
