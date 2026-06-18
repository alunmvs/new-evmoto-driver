import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/account_update_mobile_phone_verification_otp/controllers/account_update_mobile_phone_verification_otp_controller.dart';
import 'package:new_evmoto_driver/app/modules/account_update_mobile_phone_verification_otp/views/account_update_mobile_phone_verification_otp_view.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:pinput/pinput.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountUpdateMobilePhoneVerificationOtpView', () {
    late AccountUpdateMobilePhoneVerificationOtpController controller;
    late MockAccountRepository mockAccountRepository;

    Future<void> waitForInit() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(
        tester,
        const AccountUpdateMobilePhoneVerificationOtpView(),
      );
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(
          changeMobileNumber: 'Change Mobile Number',
          verificationCode: 'Verification Code',
          resendVerificationCode: 'Resend Code',
          buttonNext: 'Next',
        ),
      );
      mockAccountRepository = MockAccountRepository();
      Get.testMode = true;
      Get.routing.args = {'new_mobile_phone': '8123456789'};
      controller = AccountUpdateMobilePhoneVerificationOtpController(
        accountRepository: mockAccountRepository,
      );
      Get.put<AccountUpdateMobilePhoneVerificationOtpController>(controller);
      await waitForInit();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders update mobile phone OTP screen content', (
      tester,
    ) async {
      await pumpView(tester);

      expect(find.text('Change Mobile Number'), findsOneWidget);
      expect(find.text('Verification Code'), findsOneWidget);
      expect(find.text('Resend Code'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.byType(Pinput), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching', (tester) async {
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Verification Code'), findsNothing);
    });

    testWidgets('disables resend button when countdown is active', (
      tester,
    ) async {
      controller.isButtonResendEnable.value = false;

      await pumpView(tester);

      final resendButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Resend Code'),
      );
      expect(resendButton.onPressed, isNull);
    });

    testWidgets('enables resend button when countdown is done', (
      tester,
    ) async {
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
