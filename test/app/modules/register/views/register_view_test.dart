import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/register/controllers/register_controller.dart';
import 'package:new_evmoto_driver/app/modules/register/views/register_view.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterView', () {
    late RegisterController controller;


    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const RegisterView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(registerTitle: 'Register', registerSubtitle: 'Enter phone', mobilePhone: 'Mobile Phone', buttonNext: 'Next', formValidationFirst8: 'Must start with 8', formValidationLengthMin8: 'Min 8 digits', formValidationMobileMaxLength: 'Max 15 digits', tncPrivacyConfirmation1: 'By continuing', tncPrivacyConfirmation2: 'and', tncPrivacyConfirmation3: '.', termAndCondition: 'Terms', privacyPolicy: 'Privacy'),
      );

      controller = RegisterController();
      Get.put<RegisterController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders register form', (tester) async {
      await pumpView(tester);
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Enter phone'), findsOneWidget);
      expect(find.text('Mobile Phone'), findsOneWidget);
      expect(find.text('+62'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });
  });
}
