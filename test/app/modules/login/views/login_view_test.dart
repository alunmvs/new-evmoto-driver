import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/login/controllers/login_controller.dart';
import 'package:new_evmoto_driver/app/modules/login/views/login_view.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import '../../../../helpers/test_typography_services.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginView', () {
    late LoginController controller;
    late MockLoginRepository loginRepository;

    void registerDependencies() {
      Get.put<ThemeColorServices>(ThemeColorServices());

      final languageServices = TestLanguageServices();
      languageServices.language.value = Language(
        loginTitle: 'Login Driver Evmoto',
        loginSubtitle: 'Enter your mobile number to continue',
        mobilePhone: 'Mobile Phone',
        loginButton: 'Continue',
        formValidationFirst8: 'Phone number must start with 8',
        formValidationLengthMin8: 'Minimum 8 digits',
        formValidationMobileMaxLength: 'Maximum 15 digits',
        tncPrivacyConfirmation1: 'By continuing, you agree to our',
        tncPrivacyConfirmation2: 'and',
        termAndCondition: 'Terms & Conditions',
        privacyPolicy: 'Privacy Policy',
      );
      Get.put<LanguageServices>(languageServices);

      Get.put<FirebaseRemoteConfigServices>(
        FakeFirebaseRemoteConfigServices(),
      );

      registerTestTypographyServices();
    }

    Future<void> pumpLoginView(
      WidgetTester tester, {
      List<GetPage<dynamic>>? getPages,
    }) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginView(),
          getPages: getPages ?? const [],
        ),
      );
      await tester.pumpAndSettle();
    }

    setUp(() async {
      await setupLoginTestEnvironment();
      registerDependencies();
      loginRepository = MockLoginRepository();
      controller = LoginController(loginRepository: loginRepository);
      Get.put<LoginController>(controller);
    });

    tearDown(() {
      controller.onClose();
      controller.mobileNumberTextEditingController.dispose();
      Get.reset();
    });

    testWidgets('renders login screen content', (WidgetTester tester) async {
      await pumpLoginView(tester);

      expect(find.text('Login Driver Evmoto'), findsOneWidget);
      expect(find.text('Enter your mobile number to continue'), findsOneWidget);
      expect(find.text('Mobile Phone'), findsOneWidget);
      expect(find.text('+62'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('keeps submit button disabled when phone number is empty', (
      WidgetTester tester,
    ) async {
      await pumpLoginView(tester);

      final submitButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Continue'),
      );

      expect(submitButton.onPressed, isNull);
      expect(controller.isFormValid.value, isFalse);
    });

    testWidgets('enables submit button when phone number is valid', (
      WidgetTester tester,
    ) async {
      await pumpLoginView(tester);

      await tester.enterText(find.byType(TextFormField), '8123456789');
      await tester.pump();

      final submitButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Continue'),
      );

      expect(submitButton.onPressed, isNotNull);
      expect(controller.isFormValid.value, isTrue);
    });

    testWidgets('shows validation error when phone number does not start with 8', (
      WidgetTester tester,
    ) async {
      await pumpLoginView(tester);

      await tester.enterText(find.byType(TextFormField), '7123456789');
      await tester.pump();

      expect(find.text('Phone number must start with 8'), findsOneWidget);
      expect(controller.isFormValid.value, isFalse);
    });

    testWidgets('shows validation error when phone number has fewer than 8 digits', (
      WidgetTester tester,
    ) async {
      await pumpLoginView(tester);

      await tester.enterText(find.byType(TextFormField), '8123456');
      await tester.pump();

      expect(find.text('Minimum 8 digits'), findsOneWidget);
      expect(controller.isFormValid.value, isFalse);
    });

    testWidgets(
      'navigates to OTP verification page when submit is tapped with valid phone',
      (WidgetTester tester) async {
        Map<String, dynamic>? capturedArguments;

        when(
          () => loginRepository.checkPhoneRegistered(phone: any(named: 'phone')),
        ).thenAnswer((_) async => true);

        await pumpLoginView(
          tester,
          getPages: [
            GetPage(
              name: Routes.LOGIN_VERIFICATION_OTP,
              page: () {
                capturedArguments = Get.arguments as Map<String, dynamic>?;
                return const Scaffold(body: Text('OTP Page'));
              },
            ),
          ],
        );

        await tester.enterText(find.byType(TextFormField), '8123456789');
        await tester.pump();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
        await tester.pumpAndSettle();

        expect(find.text('OTP Page'), findsOneWidget);
        expect(Get.currentRoute, Routes.LOGIN_VERIFICATION_OTP);
        expect(capturedArguments?['mobile_phone'], '628123456789');
      },
    );
  });
}
