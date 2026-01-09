import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';

import '../controllers/history_balance_all_controller.dart';

class HistoryBalanceAllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryBalanceAllController>(
      () => HistoryBalanceAllController(
        historyBalanceRepository: HistoryBalanceRepository(),
      ),
    );
  }
}
