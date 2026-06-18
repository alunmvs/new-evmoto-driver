import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/modules/account/controllers/account_controller.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import '../../../../helpers/module_test_helpers.dart';
import '../account_test_helpers.dart';

class MockOtpRepository extends Mock implements OtpRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountController', () {
    late AccountController controller;
    late MockOtpRepository mockOtpRepository;
    late MockUserRepository mockUserRepository;
    late HomeController homeController;

    setUp(() async {
      await setupModuleTestEnvironment();
      mockAccountPlatformChannels();
      registerCommonModuleDependencies(
        language: Language(
          cancel: 'Cancel',
          resendVerificationCode: 'Resend Code',
        ),
      );
      homeController = registerTestableHomeControllerForAccount();
      mockOtpRepository = MockOtpRepository();
      mockUserRepository = MockUserRepository();
      controller = AccountController(
        otpRepository: mockOtpRepository,
        userRepository: mockUserRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with empty package info before onInit completes',
      () {
        expect(controller.packageVersion.value, '');
        expect(controller.buildNumber.value, '');
        expect(controller.isFetch.value, false);
      },
    );

    test(
      'getPackageInfo should populate packageVersion and buildNumber',
      () async {
        await controller.getPackageInfo();

        expect(controller.packageVersion.value, '1.9.5');
        expect(controller.buildNumber.value, '100');
      },
    );

    test(
      'onInit should finish loading and set package info',
      () async {
        controller.onInit();
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(controller.isFetch.value, false);
        expect(controller.packageVersion.value, '1.9.5');
        expect(controller.buildNumber.value, '100');
      },
    );

    test(
      'onTapValidateOtpDeleteAccount should request OTP with type 6',
      () async {
        final otpGate = Completer<void>();
        when(
          () => mockOtpRepository.requestOTP(
            phone: any(named: 'phone'),
            language: any(named: 'language'),
            type: any(named: 'type'),
          ),
        ).thenAnswer((_) => otpGate.future);

        homeController.userInfo.value = UserInfo(
          phone: '628123456789',
          name: 'Test Driver',
        );

        unawaited(controller.onTapValidateOtpDeleteAccount());
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockOtpRepository.requestOTP(
            phone: '628123456789',
            language: 2,
            type: 6,
          ),
        ).called(1);
      },
    );

    test(
      'onTapValidateOtpDeleteAccount should throw when OTP request fails',
      () async {
        when(
          () => mockOtpRepository.requestOTP(
            phone: any(named: 'phone'),
            language: any(named: 'language'),
            type: any(named: 'type'),
          ),
        ).thenThrow(Exception('OTP failed'));

        await expectLater(
          controller.onTapValidateOtpDeleteAccount(),
          throwsA(isA<Exception>()),
        );
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
