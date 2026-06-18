import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import '../../../helpers/module_test_helpers.dart';

class TestableHomeController extends HomeController {
  TestableHomeController({
    required super.vehicleRepository,
    required super.orderRepository,
    required super.userRepository,
    required super.accountRepository,
    required super.versioningServerRepository,
    required super.guaranteeIncomeRepository,
    required super.advanceBookingRepository,
  });

  @override
  Future<void> onInit() async {}
}

TestableHomeController registerTestableHomeControllerForHistoryBalance({
  double balance = 125000,
}) {
  registerHomeControllerDependencies();
  registerMockUserServices(balance: balance);
  final homeController = TestableHomeController(
    vehicleRepository: MockVehicleRepository(),
    orderRepository: MockOrderRepository(),
    userRepository: MockUserRepository(),
    accountRepository: MockAccountRepository(),
    versioningServerRepository: MockVersioningServerRepository(),
    guaranteeIncomeRepository: MockGuaranteeIncomeRepository(),
    advanceBookingRepository: MockAdvanceBookingRepository(),
  );
  homeController.userInfo.value = UserInfo(balance: balance);
  Get.put<HomeController>(homeController);
  return homeController;
}
