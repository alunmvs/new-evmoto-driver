import 'package:get/get.dart';

import '../controllers/account_other_setting_controller.dart';

class AccountOtherSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountOtherSettingController>(
      () => AccountOtherSettingController(),
    );
  }
}
