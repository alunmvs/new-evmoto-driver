import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/activity_repository.dart';
import 'package:new_evmoto_driver/app/repositories/guarantee_income_repository.dart';

import '../controllers/my_activity_controller.dart';

class MyActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyActivityController>(
      () => MyActivityController(
        activityRepository: ActivityRepository(),
        guaranteeIncomeRepository: GuaranteeIncomeRepository(),
      ),
    );
  }
}
