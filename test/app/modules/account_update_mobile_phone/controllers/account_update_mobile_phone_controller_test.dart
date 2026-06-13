import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/modules/account_update_mobile_phone/controllers/account_update_mobile_phone_controller.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class MockUserRepository extends Mock implements UserRepository {}

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
  Future<void> onInit() async {
    isFetch.value = false;
  }
}

HomeController registerTestableHomeController({
  required UserRepository userRepository,
}) {
  registerHomeControllerDependencies();
  if (!Get.isRegistered<UserServices>()) {
    registerMockUserServices();
  }
  final homeController = TestableHomeController(
    vehicleRepository: MockVehicleRepository(),
    orderRepository: MockOrderRepository(),
    userRepository: userRepository,
    accountRepository: MockAccountRepository(),
    versioningServerRepository: MockVersioningServerRepository(),
    guaranteeIncomeRepository: MockGuaranteeIncomeRepository(),
    advanceBookingRepository: MockAdvanceBookingRepository(),
  );
  Get.put<HomeController>(homeController);
  return homeController;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountUpdateMobilePhoneController', () {
    late AccountUpdateMobilePhoneController controller;
    late MockAccountRepository mockAccountRepository;
    late MockUserRepository mockUserRepository;

    void stubGetUserInfoDetail({String phone = '628123456789'}) {
      when(
        () => mockUserRepository.getUserInfoDetail(
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => UserInfo(phone: phone));
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockAccountRepository = MockAccountRepository();
      mockUserRepository = MockUserRepository();
      registerTestableHomeController(userRepository: mockUserRepository);
      controller = AccountUpdateMobilePhoneController(
        accountRepository: mockAccountRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with empty form and isFetch false',
      () {
        expect(controller.formGroup.control('old_mobile_phone').value, isNull);
        expect(controller.formGroup.control('new_mobile_phone').value, isNull);
        expect(controller.isFetch.value, false);
      },
    );

    test(
      'onInit should fetch user info and populate old mobile phone without country code',
      () async {
        stubGetUserInfoDetail(phone: '628123456789');

        await controller.onInit();

        expect(controller.isFetch.value, false);
        expect(
          controller.formGroup.control('old_mobile_phone').value,
          '8123456789',
        );
        verify(
          () => mockUserRepository.getUserInfoDetail(language: 2),
        ).called(1);
      },
    );

    test(
      'onInit should set isFetch true while loading and false after completion',
      () async {
        final userInfoRequest = Completer<UserInfo>();
        when(
          () => mockUserRepository.getUserInfoDetail(
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) => userInfoRequest.future);

        final initFuture = controller.onInit();
        expect(controller.isFetch.value, true);

        userInfoRequest.complete(UserInfo(phone: '628987654321'));
        await initFuture;

        expect(controller.isFetch.value, false);
      },
    );

    test(
      'form should be invalid when new mobile phone is empty',
      () {
        controller.formGroup.control('old_mobile_phone').value = '8123456789';
        controller.formGroup.control('new_mobile_phone').value = '';
        controller.formGroup.markAllAsTouched();

        expect(controller.formGroup.valid, isFalse);
      },
    );

    test(
      'form should be invalid when new mobile phone does not start with 8',
      () {
        controller.formGroup.control('old_mobile_phone').value = '8123456789';
        controller.formGroup.control('new_mobile_phone').value = '7123456789';
        controller.formGroup.markAllAsTouched();

        expect(controller.formGroup.valid, isFalse);
      },
    );

    test(
      'form should be invalid when new mobile phone is shorter than 8 digits',
      () {
        controller.formGroup.control('old_mobile_phone').value = '8123456789';
        controller.formGroup.control('new_mobile_phone').value = '8123456';
        controller.formGroup.markAllAsTouched();

        expect(controller.formGroup.valid, isFalse);
      },
    );

    test(
      'form should be valid with correct old and new mobile phone values',
      () {
        controller.formGroup.control('old_mobile_phone').value = '8123456789';
        controller.formGroup.control('new_mobile_phone').value = '8987654321';
        controller.formGroup.markAllAsTouched();

        expect(controller.formGroup.valid, isTrue);
      },
    );

    testWidgets(
      'onTapSubmit should navigate to OTP verification when form is valid',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const SizedBox()),
              GetPage(
                name: Routes.ACCOUNT_UPDATE_MOBILE_PHONE_VERIFICATION_OTP,
                page: () => const Scaffold(body: Text('OTP Verification')),
              ),
            ],
          ),
        );

        controller.formGroup.control('old_mobile_phone').value = '8123456789';
        controller.formGroup.control('new_mobile_phone').value = '8987654321';

        await controller.onTapSubmit();
        await tester.pumpAndSettle();

        expect(
          Get.currentRoute,
          Routes.ACCOUNT_UPDATE_MOBILE_PHONE_VERIFICATION_OTP,
        );
        expect(Get.arguments['old_mobile_phone'], '8123456789');
        expect(Get.arguments['new_mobile_phone'], '8987654321');
      },
    );

    testWidgets(
      'onTapSubmit should not navigate when form is invalid',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const SizedBox()),
              GetPage(
                name: Routes.ACCOUNT_UPDATE_MOBILE_PHONE_VERIFICATION_OTP,
                page: () => const Scaffold(body: Text('OTP Verification')),
              ),
            ],
          ),
        );

        controller.formGroup.control('old_mobile_phone').value = '8123456789';
        controller.formGroup.control('new_mobile_phone').value = '7123456789';

        await controller.onTapSubmit();
        await tester.pumpAndSettle();

        expect(Get.currentRoute, '/');
      },
    );

    test(
      'should clean up controller without error when onClose is called',
      () {
        expect(() => controller.onClose(), returnsNormally);
      },
    );
  });
}
