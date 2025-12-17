import 'package:get/get.dart';

import '../controllers/account_language_controller.dart';

class AccountLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountLanguageController>(
      () => AccountLanguageController(),
    );
  }
}
