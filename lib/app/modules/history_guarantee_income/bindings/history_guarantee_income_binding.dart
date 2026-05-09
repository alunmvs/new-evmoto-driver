import 'package:get/get.dart';

import '../controllers/history_guarantee_income_controller.dart';

class HistoryGuaranteeIncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryGuaranteeIncomeController>(
      () => HistoryGuaranteeIncomeController(),
    );
  }
}
