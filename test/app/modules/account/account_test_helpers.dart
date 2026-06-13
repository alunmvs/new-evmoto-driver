import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/data/models/vehicle_statistics_model.dart';
import 'package:new_evmoto_driver/app/modules/account/controllers/account_controller.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
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
  // ignore: must_call_super
  Future<void> onInit() async {}
}

class TestableAccountController extends AccountController {
  TestableAccountController({
    required super.otpRepository,
    required super.userRepository,
  });

  @override
  // ignore: must_call_super
  Future<void> onInit() async {
    isFetch.value = false;
    packageVersion.value = '1.9.5';
    buildNumber.value = '100';
  }
}

Language accountLanguage() {
  return Language(
    myBalance: 'My Balance',
    totalOrder: 'Total Orders',
    myRating: 'My Rating',
    myEvaluation: 'My Evaluation',
    sendFeedback: 'Send Feedback',
    selectService: 'Select Service',
    changeVehicle: 'Change Vehicle',
    recommendToFriend: 'Recommend to Friend',
    contactCs: 'Contact CS',
    otherSetting: 'Other Settings',
    appVersion: 'App Version',
    cancel: 'Cancel',
    resendVerificationCode: 'Resend Code',
  );
}

void mockAccountPlatformChannels() {
  const packageInfoChannel = MethodChannel(
    'dev.fluttercommunity.plus/package_info',
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(packageInfoChannel, (
    MethodCall methodCall,
  ) async {
    if (methodCall.method == 'getAll') {
      return {
        'appName': 'Test',
        'packageName': 'com.test.app',
        'version': '1.9.5',
        'buildNumber': '100',
      };
    }
    return null;
  });
}

HomeController registerTestableHomeControllerForAccount() {
  registerHomeControllerDependencies();
  registerMockUserServices(
    balance: 75000,
    id: 1,
  );

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
    balance: 75000,
    name: 'Test Driver',
    phone: '628123456789',
    licensePlate: 'B 1234 ABC',
    brand: 'Toyota',
    id: 1,
  );
  homeController.vehicleStatistics.value = VehicleStatistics(
    dayNum: 12,
    score: 4.8,
  );
  Get.put<HomeController>(homeController);
  return homeController;
}

TestableAccountController registerTestableAccountController({
  required OtpRepository otpRepository,
  required UserRepository userRepository,
}) {
  final controller = TestableAccountController(
    otpRepository: otpRepository,
    userRepository: userRepository,
  );
  Get.put<AccountController>(controller);
  return controller;
}
