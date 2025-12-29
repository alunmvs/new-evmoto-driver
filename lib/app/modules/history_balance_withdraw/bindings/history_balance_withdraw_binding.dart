import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';

import '../controllers/history_balance_withdraw_controller.dart';

class HistoryBalanceWithdrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryBalanceWithdrawController>(
      () => HistoryBalanceWithdrawController(
        historyBalanceRepository: HistoryBalanceRepository(),
      ),
    );
  }
}
