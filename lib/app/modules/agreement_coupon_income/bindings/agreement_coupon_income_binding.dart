import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';

import '../controllers/agreement_coupon_income_controller.dart';

class AgreementCouponIncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgreementCouponIncomeController>(
      () => AgreementCouponIncomeController(
        agreementRepository: AgreementRepository(),
      ),
    );
  }
}
