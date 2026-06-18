import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/account_language/controllers/account_language_controller.dart';
import 'package:new_evmoto_driver/app/modules/account_language/views/account_language_view.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountLanguageView', () {
    late AccountLanguageController controller;


    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const AccountLanguageView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(selectLanguage: 'Select Language', save: 'Save'),
      );

      controller = AccountLanguageController();
      Get.put<AccountLanguageController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders language options', (tester) async {
      await pumpView(tester);
      expect(find.text('Select Language'), findsWidgets);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Bahasa Indonesia'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });
  });
}
