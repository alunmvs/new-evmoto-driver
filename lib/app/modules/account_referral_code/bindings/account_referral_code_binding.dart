import 'package:get/get.dart';

import '../controllers/account_referral_code_controller.dart';

class AccountReferralCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountReferralCodeController>(
      () => AccountReferralCodeController(),
    );
  }
}
