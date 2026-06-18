import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/modules/withdraw_amount/controllers/withdraw_amount_controller.dart';
import 'package:new_evmoto_driver/app/repositories/withdraw_repository.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import '../../../helpers/module_test_helpers.dart';

class MockWithdrawRepository extends Mock implements WithdrawRepository {}

class MockFirebaseRemoteConfig extends Mock implements FirebaseRemoteConfig {}

class TestFirebaseRemoteConfigServices extends GetxService
    implements FirebaseRemoteConfigServices {
  TestFirebaseRemoteConfigServices({this.withdrawMin = 50000}) {
    when(
      () => _remoteConfig.getInt('driver_withdraw_min'),
    ).thenReturn(withdrawMin);
  }

  final int withdrawMin;
  final MockFirebaseRemoteConfig _remoteConfig = MockFirebaseRemoteConfig();

  @override
  FirebaseRemoteConfig get remoteConfig => _remoteConfig;

  @override
  Future<void> onInit() async {}

  @override
  Future<void> manualOnInit() async {}
}

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

BankAccount sampleBankAccount() => BankAccount(
  id: 1,
  bank: 'BCA',
  bankCode: '014',
  name: 'John Doe',
  code: '1234567890',
);

void stubGetAdminFee(
  MockWithdrawRepository mockWithdrawRepository, {
  double fee = 2500,
}) {
  when(
    () => mockWithdrawRepository.getAdminFeeByBankCode(
      bankCode: any(named: 'bankCode'),
    ),
  ).thenAnswer((_) async => fee);
}

void stubRequestWithdrawal(MockWithdrawRepository mockWithdrawRepository) {
  when(
    () => mockWithdrawRepository.requestWithdrawal(
      bankName: any(named: 'bankName'),
      code: any(named: 'code'),
      language: any(named: 'language'),
      money: any(named: 'money'),
      name: any(named: 'name'),
    ),
  ).thenAnswer((_) async {});
}

void fillValidWithdrawForm(
  WithdrawAmountController controller, {
  String amount = '100000',
}) {
  controller.formGroup.control('money').value = amount;
}

HomeController registerTestableHomeController({double balance = 500000}) {
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
  homeController.userInfo.value = UserInfo(
    balance: balance,
    name: 'Test Driver',
    id: 1,
  );
  Get.put<HomeController>(homeController);
  return homeController;
}

void registerWithdrawAmountDependencies({int withdrawMin = 50000}) {
  registerCommonModuleDependencies();

  if (Get.isRegistered<FirebaseRemoteConfigServices>()) {
    Get.delete<FirebaseRemoteConfigServices>(force: true);
  }

  Get.put<FirebaseRemoteConfigServices>(
    TestFirebaseRemoteConfigServices(withdrawMin: withdrawMin),
  );

  registerTestableHomeController();
}
