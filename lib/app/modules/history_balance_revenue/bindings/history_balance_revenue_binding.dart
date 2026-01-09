import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';

import '../controllers/history_balance_revenue_controller.dart';

class HistoryBalanceRevenueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryBalanceRevenueController>(
      () => HistoryBalanceRevenueController(
        historyBalanceRepository: HistoryBalanceRepository(),
      ),
    );
  }
}
