import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/guarantee_income_repository.dart';

import '../controllers/history_guarantee_income_controller.dart';

class HistoryGuaranteeIncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryGuaranteeIncomeController>(
      () => HistoryGuaranteeIncomeController(
        guaranteeIncomeRepository: GuaranteeIncomeRepository(),
      ),
    );
  }
}
