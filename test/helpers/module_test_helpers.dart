import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/data/models/working_area_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_driver/app/repositories/guarantee_income_repository.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import 'package:new_evmoto_driver/app/repositories/vehicle_repository.dart';
import 'package:new_evmoto_driver/app/repositories/versioning_server_repository.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/app_lifecycle_services.dart';
import 'package:new_evmoto_driver/app/services/background_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/location_services.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';
import 'package:new_evmoto_driver/app/services/voice_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_typography_services.dart';

export 'test_typography_services.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockOrderRepository extends Mock implements OrderRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockVersioningServerRepository extends Mock
    implements VersioningServerRepository {}

class MockGuaranteeIncomeRepository extends Mock
    implements GuaranteeIncomeRepository {}

class MockAdvanceBookingRepository extends Mock
    implements AdvanceBookingRepository {}

class TestApiServices extends ApiServices {
  @override
  Future<void> onInit() async {}
}

class TestBackgroundServices extends BackgroundServices {
  @override
  Future<void> onInit() async {}
}

class TestLocationServices extends LocationServices {
  @override
  Future<void> onInit() async {}
}

class TestFirebasePushNotificationServices
    extends FirebasePushNotificationServices {
  @override
  Future<void> onInit() async {}
}

class TestSocketServices extends SocketServices {
  @override
  Future<void> onInit() async {}
}

class TestUserServices extends GetxService implements UserServices {
  @override
  final userRepository = MockUserRepository();

  @override
  late final LanguageServices languageServices;

  TestUserServices() {
    languageServices = TestLanguageServices();
  }

  @override
  final userInfo = UserInfo(balance: 50000, name: 'Test Driver', id: 1).obs;

  @override
  final workingAreaList = <WorkingArea>[].obs;

  @override
  final isLoadingRefreshHome = false.obs;

  @override
  Future<void> manualOnInit() async {}

  @override
  Future<void> getUserInfo() async {}

  @override
  Future<void> getWorkingArea() async {}

  @override
  void clearUserInfo() {
    userInfo.value = UserInfo();
    workingAreaList.clear();
  }
}

Future<void> setupModuleTestEnvironment() async {
  setupFirebaseCoreMocks();
  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({});
}

void registerCommonModuleDependencies({Language? language}) {
  Get.put<ThemeColorServices>(ThemeColorServices());

  final languageServices = TestLanguageServices();
  if (language != null) {
    languageServices.language.value = language;
  }
  Get.put<LanguageServices>(languageServices);

  Get.put<FirebaseRemoteConfigServices>(FakeFirebaseRemoteConfigServices());
  registerTestTypographyServices();
}

void registerHomeControllerDependencies() {
  if (!Get.isRegistered<ApiServices>()) {
    Get.put<ApiServices>(TestApiServices());
  }
  if (!Get.isRegistered<BackgroundServices>()) {
    Get.put<BackgroundServices>(TestBackgroundServices());
  }
  if (!Get.isRegistered<LocationServices>()) {
    Get.put<LocationServices>(TestLocationServices());
  }
  if (!Get.isRegistered<AppLifecycleController>()) {
    Get.put<AppLifecycleController>(AppLifecycleController());
  }
  if (!Get.isRegistered<VoiceServices>()) {
    Get.put<VoiceServices>(VoiceServices());
  }
  if (!Get.isRegistered<FirebasePushNotificationServices>()) {
    Get.put<FirebasePushNotificationServices>(
      TestFirebasePushNotificationServices(),
    );
  }
  if (!Get.isRegistered<SocketServices>()) {
    Get.put<SocketServices>(TestSocketServices());
  }
}

HomeController registerStubHomeController({double balance = 50000}) {
  registerHomeControllerDependencies();
  if (!Get.isRegistered<UserServices>()) {
    registerMockUserServices(balance: balance);
  }
  final homeController = HomeController(
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

TestUserServices registerMockUserServices({double balance = 50000, int? id}) {
  final userServices = TestUserServices();
  userServices.userInfo.value = UserInfo(
    balance: balance,
    name: 'Test Driver',
    id: id ?? 1,
  );
  Get.put<UserServices>(userServices);
  return userServices;
}

Future<void> pumpModuleView(
  WidgetTester tester,
  Widget view, {
  List<GetPage<dynamic>>? getPages,
}) async {
  await tester.pumpWidget(
    GetMaterialApp(
      home: view,
      getPages: getPages ?? const [],
    ),
  );
  await tester.pump();
}
