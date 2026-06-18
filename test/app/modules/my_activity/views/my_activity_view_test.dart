import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/my_activity/controllers/my_activity_controller.dart';
import 'package:new_evmoto_driver/app/modules/my_activity/views/my_activity_view.dart';
import 'package:new_evmoto_driver/app/repositories/activity_repository.dart';
import 'package:new_evmoto_driver/app/repositories/guarantee_income_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class MockGuaranteeIncomeRepository extends Mock implements GuaranteeIncomeRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MyActivityView', () {
    late MyActivityController controller;
    late MockActivityRepository mockActivityRepository;
    late MockGuaranteeIncomeRepository mockGuaranteeIncomeRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const MyActivityView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(selectLanguage: 'Select Language', save: 'Save'),
      );
      registerMockUserServices();
      mockActivityRepository = MockActivityRepository();
      mockGuaranteeIncomeRepository = MockGuaranteeIncomeRepository();
      controller = MyActivityController(activityRepository: mockActivityRepository, guaranteeIncomeRepository: mockGuaranteeIncomeRepository);
      Get.put<MyActivityController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
      'renders MyActivity screen',
      (tester) async {
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
      },
      skip: true, // View requires integration test setup
    );
  });
}
