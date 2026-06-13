import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/registered_driver_model.dart';
import 'package:new_evmoto_driver/app/modules/register_verification_otp/controllers/register_verification_otp_controller.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/repositories/register_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOtpRepository extends Mock implements OtpRepository {}

class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterVerificationOtpController Test', () {
    late RegisterVerificationOtpController controller;
    late MockOtpRepository mockOtpRepository;
    late MockRegisterRepository mockRegisterRepository;

    void stubRequestOtp() {
      when(
        () => mockOtpRepository.requestOTP(
          phone: any(named: 'phone'),
          language: any(named: 'language'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async {});
    }

    void stubCheckOtp() {
      when(
        () => mockOtpRepository.checkOTP(
          phone: any(named: 'phone'),
          language: any(named: 'language'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) async {});
    }

    void stubRegisterDriver({int id = 42}) {
      when(
        () => mockRegisterRepository.registerDriverNoPassword(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => RegisteredDriver(id: id));
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockOtpRepository = MockOtpRepository();
      mockRegisterRepository = MockRegisterRepository();
      controller = RegisterVerificationOtpController(
        otpRepository: mockOtpRepository,
        registerRepository: mockRegisterRepository,
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
      'requestOtp should call repository with 62 prefix, language, and type 3',
      () async {
        stubRequestOtp();
        controller.mobilePhone.value = '8123456789';

        await controller.requestOtp();

        verify(
          () => mockOtpRepository.requestOTP(
            phone: '628123456789',
            language: 2,
            type: 3,
          ),
        ).called(1);
        expect(controller.isButtonResendEnable.value, false);
      },
    );

    test(
      'requestOtp should not throw when repository fails',
      () async {
        when(
          () => mockOtpRepository.requestOTP(
            phone: any(named: 'phone'),
            language: any(named: 'language'),
            type: any(named: 'type'),
          ),
        ).thenThrow(Exception('OTP failed'));
        controller.mobilePhone.value = '8123456789';

        await expectLater(controller.requestOtp(), completes);
      },
    );

    test(
      'onInit should read mobile_phone from arguments and request OTP',
      () async {
        Get.testMode = true;
        Get.routing.args = {'mobile_phone': '8123456789'};
        stubRequestOtp();

        await controller.onInit();

        expect(controller.mobilePhone.value, '8123456789');
        expect(controller.isFetch.value, false);
        verify(
          () => mockOtpRepository.requestOTP(
            phone: '628123456789',
            language: any(named: 'language'),
            type: 3,
          ),
        ).called(1);
      },
    );

    test(
      'onInit should default mobile phone to empty when argument is missing',
      () async {
        Get.testMode = true;
        Get.routing.args = <String, dynamic>{};
        stubRequestOtp();

        await controller.onInit();

        expect(controller.mobilePhone.value, '');
        expect(controller.isFetch.value, false);
      },
    );

    testWidgets(
      'onTapNext should verify OTP, register driver, and navigate to register form',
      (WidgetTester tester) async {
        stubCheckOtp();
        stubRegisterDriver(id: 99);

        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const SizedBox()),
              GetPage(
                name: Routes.REGISTER_FORM,
                page: () => const Scaffold(body: Text('Register Form')),
              ),
            ],
          ),
        );

        controller.mobilePhone.value = '8123456789';
        controller.otpCode.value = '1234';

        await controller.onTapNext();
        await tester.pumpAndSettle();

        expect(Get.currentRoute, Routes.REGISTER_FORM);
        expect(controller.registeredDriver.value.id, 99);
        verify(
          () => mockOtpRepository.checkOTP(
            phone: '628123456789',
            language: 2,
            code: '1234',
          ),
        ).called(1);
        verify(
          () => mockRegisterRepository.registerDriverNoPassword(
            phone: '628123456789',
            code: '1234',
            language: 2,
          ),
        ).called(1);
      },
    );

    test(
      'onTapNext should not throw when check OTP fails',
      () async {
        when(
          () => mockOtpRepository.checkOTP(
            phone: any(named: 'phone'),
            language: any(named: 'language'),
            code: any(named: 'code'),
          ),
        ).thenThrow(Exception('Invalid OTP'));
        controller.mobilePhone.value = '8123456789';
        controller.otpCode.value = '1234';

        await expectLater(controller.onTapNext(), completes);
      },
    );

    test(
      'onTapNext should not throw when register driver fails',
      () async {
        stubCheckOtp();
        when(
          () => mockRegisterRepository.registerDriverNoPassword(
            phone: any(named: 'phone'),
            code: any(named: 'code'),
            language: any(named: 'language'),
          ),
        ).thenThrow(Exception('Registration failed'));
        controller.mobilePhone.value = '8123456789';
        controller.otpCode.value = '1234';

        await expectLater(controller.onTapNext(), completes);
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
