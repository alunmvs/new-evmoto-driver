import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/login/controllers/login_controller.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import '../../../../helpers/test_typography_services.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginController Test', () {
    late LoginController controller;
    late MockLoginRepository loginRepository;
    late LanguageServices languageServices;

    late ThemeColorServices themeColorServices;

    void registerDependencies() {
      themeColorServices = ThemeColorServices();
      Get.put<ThemeColorServices>(themeColorServices);

      languageServices = TestLanguageServices();
      languageServices.language.value = Language(
        formValidationFirst8: 'Phone number must start with 8',
        formValidationLengthMin8: 'Minimum 8 digits',
        formValidationMobileMaxLength: 'Maximum 15 digits',
      );
      Get.put<LanguageServices>(languageServices);

      Get.put<FirebaseRemoteConfigServices>(
        FakeFirebaseRemoteConfigServices(),
      );

      registerTestTypographyServices();
    }

    Future<void> pumpLoginForm(
      WidgetTester tester,
      LoginController loginController,
    ) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Form(
              key: loginController.loginRegisterFormKey,
              child: TextFormField(
                controller: loginController.mobileNumberTextEditingController,
                validator: _mobilePhoneValidator(languageServices),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    setUp(() async {
      await setupLoginTestEnvironment();
      registerDependencies();
      loginRepository = MockLoginRepository();
      controller = LoginController(loginRepository: loginRepository);
      controller.onInit();
    });

    tearDown(() {
      controller.onClose();
      controller.mobileNumberTextEditingController.dispose();
      Get.reset();
    });

    test(
      'should have empty mobilePhone and isFormValid false as initial state',
      () {
        expect(controller.mobilePhone.value, '');
        expect(controller.isFormValid.value, false);
      },
    );

    testWidgets(
      'should set isFormValid to true when phone number is valid',
      (WidgetTester tester) async {
        await pumpLoginForm(tester, controller);

        controller.mobilePhone.value = '8123456789';
        controller.mobileNumberTextEditingController.text = '8123456789';
        controller.validateForm();

        expect(controller.isFormValid.value, true);
      },
    );

    testWidgets(
      'should keep isFormValid false when phone number is empty',
      (WidgetTester tester) async {
        await pumpLoginForm(tester, controller);

        controller.mobilePhone.value = '';
        controller.mobileNumberTextEditingController.text = '';
        controller.validateForm();

        expect(controller.isFormValid.value, false);
      },
    );

    testWidgets(
      'should keep isFormValid false when phone number does not start with 8',
      (WidgetTester tester) async {
        await pumpLoginForm(tester, controller);

        controller.mobilePhone.value = '7123456789';
        controller.mobileNumberTextEditingController.text = '7123456789';
        controller.validateForm();

        expect(controller.isFormValid.value, false);
      },
    );

    testWidgets(
      'should keep isFormValid false when phone number has fewer than 8 digits',
      (WidgetTester tester) async {
        await pumpLoginForm(tester, controller);

        controller.mobilePhone.value = '8123456';
        controller.mobileNumberTextEditingController.text = '8123456';
        controller.validateForm();

        expect(controller.isFormValid.value, false);
      },
    );

    testWidgets(
      'should keep isFormValid false when phone number has more than 15 digits',
      (WidgetTester tester) async {
        await pumpLoginForm(tester, controller);

        controller.mobilePhone.value = '8123456789012345';
        controller.mobileNumberTextEditingController.text = '8123456789012345';
        controller.validateForm();

        expect(controller.isFormValid.value, false);
      },
    );

    testWidgets(
      'should revalidate form when TextEditingController text changes via listener',
      (WidgetTester tester) async {
        await pumpLoginForm(tester, controller);

        expect(controller.isFormValid.value, false);

        controller.mobilePhone.value = '8123456789';
        await tester.enterText(find.byType(TextFormField), '8123456789');
        await tester.pump();

        expect(controller.isFormValid.value, true);
      },
    );

    testWidgets(
      'should navigate to OTP verification page with correct phone number argument',
      (WidgetTester tester) async {
        Map<String, dynamic>? capturedArguments;

        when(
          () => loginRepository.checkPhoneRegistered(phone: any(named: 'phone')),
        ).thenAnswer((_) async => true);

        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: Form(
                key: controller.loginRegisterFormKey,
                child: TextFormField(
                  controller: controller.mobileNumberTextEditingController,
                  validator: _mobilePhoneValidator(languageServices),
                ),
              ),
            ),
            getPages: [
              GetPage(
                name: Routes.LOGIN_VERIFICATION_OTP,
                page: () {
                  capturedArguments = Get.arguments as Map<String, dynamic>?;
                  return const Scaffold(body: Text('OTP'));
                },
              ),
            ],
          ),
        );
        await tester.pump();

        controller.mobileNumberTextEditingController.text = '8123456789';
        await tester.pump();
        await controller.onTapSubmit();
        await tester.pump();

        expect(Get.currentRoute, Routes.LOGIN_VERIFICATION_OTP);
        expect(capturedArguments?['mobile_phone'], '628123456789');
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

String? Function(String?) _mobilePhoneValidator(
  LanguageServices languageServices,
) {
  return (value) {
    if (value != null && value != '') {
      if (value.isNotEmpty && value.substring(0, 1) != '8') {
        return languageServices.language.value.formValidationFirst8;
      }
      if (value.length < 8) {
        return languageServices.language.value.formValidationLengthMin8;
      }
      if (value.length > 15) {
        return languageServices.language.value.formValidationMobileMaxLength;
      }
    }
    return null;
  };
}
