import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/modules/login_verification_otp/controllers/login_verification_otp_controller.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOtpRepository extends Mock implements OtpRepository {}

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginVerificationOtpController Test', () {
    late LoginVerificationOtpController controller;
    late MockOtpRepository mockOtpRepository;
    late MockLoginRepository mockLoginRepository;

    void mockSecureStorage() {
      const channel = MethodChannel(
        'plugins.it_nomads.com/flutter_secure_storage',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        return null;
      });
    }

    void stubRequestOtp() {
      when(
        () => mockOtpRepository.requestOTP(
          phone: any(named: 'phone'),
          language: any(named: 'language'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async {});
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockSecureStorage();
      if (!Get.isRegistered<ApiServices>()) {
        Get.put<ApiServices>(TestApiServices());
      }
      mockOtpRepository = MockOtpRepository();
      mockLoginRepository = MockLoginRepository();
      controller = LoginVerificationOtpController(
        otpRepository: mockOtpRepository,
        loginRepository: mockLoginRepository,
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
      'requestOtp should call repository with phone, language, and type 3',
      () async {
        stubRequestOtp();
        controller.mobilePhone.value = '628123456789';

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
        controller.mobilePhone.value = '628123456789';

        await expectLater(controller.requestOtp(), completes);
      },
    );

    test(
      'onInit should read mobile_phone from arguments and request OTP',
      () async {
        Get.testMode = true;
        Get.routing.args = {'mobile_phone': '628123456789'};
        stubRequestOtp();

        await controller.onInit();

        expect(controller.mobilePhone.value, '628123456789');
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
      'onTapSubmit should login and navigate to home',
      (WidgetTester tester) async {
        when(
          () => mockLoginRepository.loginByMobileNumberOtp(
            phone: any(named: 'phone'),
            otp: any(named: 'otp'),
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) async => 'test-token');

        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const SizedBox()),
              GetPage(
                name: Routes.HOME,
                page: () => const Scaffold(body: Text('Home')),
              ),
            ],
          ),
        );

        controller.mobilePhone.value = '628123456789';
        controller.otpCode.value = '1234';

        await controller.onTapSubmit();
        await tester.pumpAndSettle();

        expect(Get.currentRoute, Routes.HOME);
        verify(
          () => mockLoginRepository.loginByMobileNumberOtp(
            phone: '628123456789',
            otp: '1234',
            language: 2,
          ),
        ).called(1);
      },
    );

    test(
      'onTapSubmit should not throw when login fails',
      () async {
        when(
          () => mockLoginRepository.loginByMobileNumberOtp(
            phone: any(named: 'phone'),
            otp: any(named: 'otp'),
            language: any(named: 'language'),
          ),
        ).thenThrow(Exception('Invalid OTP'));
        controller.mobilePhone.value = '628123456789';
        controller.otpCode.value = '1234';

        await expectLater(controller.onTapSubmit(), completes);
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
