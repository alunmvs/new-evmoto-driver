import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';

import '../controllers/history_balance_recharge_controller.dart';

class HistoryBalanceRechargeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryBalanceRechargeController>(
      () => HistoryBalanceRechargeController(
        historyBalanceRepository: HistoryBalanceRepository(),
      ),
    );
  }
}
