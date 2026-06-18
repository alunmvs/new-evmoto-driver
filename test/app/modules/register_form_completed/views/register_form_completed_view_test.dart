import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/register_form_completed/controllers/register_form_completed_controller.dart';
import 'package:new_evmoto_driver/app/modules/register_form_completed/views/register_form_completed_view.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterFormCompletedView', () {
    late RegisterFormCompletedController controller;


    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const RegisterFormCompletedView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(registerCompleteTitle: 'Registration Complete', registerCompleteDescription: 'Please wait', registerCompleteTitle1: 'Success', registerCompleteDescription1: 'Your data is being reviewed', confirmation: 'Continue'),
      );

      controller = RegisterFormCompletedController();
      Get.put<RegisterFormCompletedController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders completion screen', (tester) async {
      await pumpView(tester);
      expect(find.text('Registration Complete'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
  });
}
