import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/modules/account_update_mobile_phone_verification_otp/controllers/account_update_mobile_phone_verification_otp_controller.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountUpdateMobilePhoneVerificationOtpController Test', () {
    late AccountUpdateMobilePhoneVerificationOtpController controller;
    late MockAccountRepository mockAccountRepository;

    void stubUpdateMobilePhone() {
      when(
        () => mockAccountRepository.updateMobilePhone(
          password: any(named: 'password'),
          phone: any(named: 'phone'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async {});
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockAccountRepository = MockAccountRepository();
      controller = AccountUpdateMobilePhoneVerificationOtpController(
        accountRepository: mockAccountRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with empty otp code and resend disabled',
      () {
        expect(controller.otpCode.value, '');
        expect(controller.mobilePhone.value, '');
        expect(controller.isButtonResendEnable.value, false);
        expect(controller.isFetch.value, false);
      },
    );

    test(
      'requestOtp should disable resend button',
      () async {
        controller.isButtonResendEnable.value = true;

        await controller.requestOtp();

        expect(controller.isButtonResendEnable.value, false);
      },
    );

    test(
      'onInit should read new_mobile_phone from arguments',
      () async {
        Get.testMode = true;
        Get.routing.args = {'new_mobile_phone': '8123456789'};

        controller.onInit();

        expect(controller.mobilePhone.value, '8123456789');
        expect(controller.isFetch.value, false);
      },
    );

    test(
      'onInit should default mobile phone to empty when argument is missing',
      () async {
        Get.testMode = true;
        Get.routing.args = <String, dynamic>{};

        controller.onInit();

        expect(controller.mobilePhone.value, '');
        expect(controller.isFetch.value, false);
      },
    );

    testWidgets(
      'onTapSubmit should update mobile phone and navigate back twice',
      (WidgetTester tester) async {
        stubUpdateMobilePhone();

        await tester.pumpWidget(
          GetMaterialApp(
            home: const Scaffold(body: Text('Root')),
            getPages: [
              GetPage(
                name: '/middle',
                page: () => const Scaffold(body: Text('Middle')),
              ),
              GetPage(
                name: '/otp',
                page: () => const Scaffold(body: Text('OTP')),
              ),
            ],
          ),
        );

        Get.toNamed('/middle');
        Get.toNamed('/otp');
        expect(Get.currentRoute, '/otp');

        controller.mobilePhone.value = '8123456789';
        controller.otpCode.value = '1234';

        await controller.onTapSubmit();
        await tester.pump();

        expect(Get.currentRoute, '/');
        verify(
          () => mockAccountRepository.updateMobilePhone(
            password: '123456789',
            phone: '628123456789',
            language: 2,
          ),
        ).called(1);
      },
    );

    testWidgets(
      'onTapSubmit should navigate back once when update fails',
      (WidgetTester tester) async {
        when(
          () => mockAccountRepository.updateMobilePhone(
            password: any(named: 'password'),
            phone: any(named: 'phone'),
            language: any(named: 'language'),
          ),
        ).thenThrow(Exception('Invalid OTP'));

        await tester.pumpWidget(
          GetMaterialApp(
            home: const Scaffold(body: Text('Root')),
            getPages: [
              GetPage(
                name: '/middle',
                page: () => const Scaffold(body: Text('Middle')),
              ),
              GetPage(
                name: '/otp',
                page: () => const Scaffold(body: Text('OTP')),
              ),
            ],
          ),
        );

        Get.toNamed('/middle');
        Get.toNamed('/otp');
        expect(Get.currentRoute, '/otp');

        controller.mobilePhone.value = '8123456789';
        controller.otpCode.value = '1234';

        await controller.onTapSubmit();
        await tester.pump();

        expect(Get.currentRoute, '/middle');
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
