import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';

import '../controllers/account_legal_terms_and_platform_rules_controller.dart';

class AccountLegalTermsAndPlatformRulesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountLegalTermsAndPlatformRulesController>(
      () => AccountLegalTermsAndPlatformRulesController(
        agreementRepository: AgreementRepository(),
      ),
    );
  }
}
