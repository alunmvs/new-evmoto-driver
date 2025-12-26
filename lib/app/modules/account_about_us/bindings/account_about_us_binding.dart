import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';

import '../controllers/account_about_us_controller.dart';

class AccountAboutUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountAboutUsController>(
      () =>
          AccountAboutUsController(agreementRepository: AgreementRepository()),
    );
  }
}
