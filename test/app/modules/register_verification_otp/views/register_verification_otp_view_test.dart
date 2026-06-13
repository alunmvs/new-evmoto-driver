import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/register_verification_otp/controllers/register_verification_otp_controller.dart';
import 'package:new_evmoto_driver/app/modules/register_verification_otp/views/register_verification_otp_view.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/repositories/register_repository.dart';
import 'package:pinput/pinput.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOtpRepository extends Mock implements OtpRepository {}

class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterVerificationOtpView', () {
    late RegisterVerificationOtpController controller;
    late MockOtpRepository mockOtpRepository;
    late MockRegisterRepository mockRegisterRepository;

    Future<void> waitForOtpFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const RegisterVerificationOtpView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(
          validateOtpTitle: 'Verify OTP',
          validateOtpSubtitle: 'Enter the code sent to your phone',
          verificationCode: 'Verification Code',
          resendVerificationCode: 'Resend Code',
          buttonNext: 'Next',
        ),
      );
      mockOtpRepository = MockOtpRepository();
      mockRegisterRepository = MockRegisterRepository();
      when(
        () => mockOtpRepository.requestOTP(
          phone: any(named: 'phone'),
          language: any(named: 'language'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async {});
      Get.testMode = true;
      Get.routing.args = {'mobile_phone': '8123456789'};
      controller = RegisterVerificationOtpController(
        otpRepository: mockOtpRepository,
        registerRepository: mockRegisterRepository,
      );
      Get.put<RegisterVerificationOtpController>(controller);
      await waitForOtpFetch();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders OTP verification screen content', (tester) async {
      await pumpView(tester);

      expect(find.text('Verify OTP'), findsOneWidget);
      expect(find.text('Enter the code sent to your phone'), findsOneWidget);
      expect(find.text('Verification Code'), findsOneWidget);
      expect(find.text('Resend Code'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.byType(Pinput), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching OTP', (tester) async {
      final otpRequest = Completer<void>();
      when(
        () => mockOtpRepository.requestOTP(
          phone: any(named: 'phone'),
          language: any(named: 'language'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) => otpRequest.future);

      Get.delete<RegisterVerificationOtpController>();
      final loadingController = RegisterVerificationOtpController(
        otpRepository: mockOtpRepository,
        registerRepository: mockRegisterRepository,
      );
      Get.put<RegisterVerificationOtpController>(loadingController);

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Verify OTP'), findsNothing);

      otpRequest.complete();
      await waitForOtpFetch();
    });

    testWidgets('disables resend button when countdown is active', (tester) async {
      controller.isButtonResendEnable.value = false;

      await pumpView(tester);

      final resendButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Resend Code'),
      );
      expect(resendButton.onPressed, isNull);
    });

    testWidgets('enables resend button when countdown is done', (tester) async {
      controller.isButtonResendEnable.value = true;

      await pumpView(tester);

      final resendButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Resend Code'),
      );
      expect(resendButton.onPressed, isNotNull);
    });

    testWidgets('disables next button when OTP code is incomplete', (
      tester,
    ) async {
      controller.otpCode.value = '12';

      await pumpView(tester);

      final nextButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Next'),
      );
      expect(nextButton.onPressed, isNull);
    });

    testWidgets('enables next button when OTP code has 4 digits', (
      tester,
    ) async {
      controller.otpCode.value = '1234';

      await pumpView(tester);

      final nextButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Next'),
      );
      expect(nextButton.onPressed, isNotNull);
    });
  });
}
