import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';

import '../controllers/agreement_guarantee_income_controller.dart';

class AgreementGuaranteeIncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgreementGuaranteeIncomeController>(
      () => AgreementGuaranteeIncomeController(
        agreementRepository: AgreementRepository(),
      ),
    );
  }
}
