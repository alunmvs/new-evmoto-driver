import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
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

  bool checkAppVersioningCalled = false;
  bool? lastIsShowVersionNewestConfirmationDialog;

  @override
  Future<void> onInit() async {}

  @override
  Future<void> checkAppVersioning({
    required bool isShowVersionNewestConfirmationDialog,
  }) async {
    checkAppVersioningCalled = true;
    lastIsShowVersionNewestConfirmationDialog =
        isShowVersionNewestConfirmationDialog;
  }
}

TestableHomeController registerTestableHomeController() {
  registerHomeControllerDependencies();
  registerMockUserServices();
  final homeController = TestableHomeController(
    vehicleRepository: MockVehicleRepository(),
    orderRepository: MockOrderRepository(),
    userRepository: MockUserRepository(),
    accountRepository: MockAccountRepository(),
    versioningServerRepository: MockVersioningServerRepository(),
    guaranteeIncomeRepository: MockGuaranteeIncomeRepository(),
    advanceBookingRepository: MockAdvanceBookingRepository(),
  );
  Get.put<HomeController>(homeController);
  return homeController;
}

void mockOtherSettingPlatformChannels() {
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

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(pathProviderChannel, (
    MethodCall methodCall,
  ) async {
    switch (methodCall.method) {
      case 'getTemporaryDirectory':
      case 'getApplicationSupportDirectory':
      case 'getApplicationDocumentsDirectory':
        return '/tmp';
      default:
        return null;
    }
  });
}
