import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';

import '../controllers/account_user_guide_controller.dart';

class AccountUserGuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountUserGuideController>(
      () => AccountUserGuideController(
        agreementRepository: AgreementRepository(),
      ),
    );
  }
}
