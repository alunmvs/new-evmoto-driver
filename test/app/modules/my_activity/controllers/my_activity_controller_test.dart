import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/my_activity/controllers/my_activity_controller.dart';
import 'package:new_evmoto_driver/app/repositories/activity_repository.dart';
import 'package:new_evmoto_driver/app/repositories/guarantee_income_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class MockGuaranteeIncomeRepository extends Mock implements GuaranteeIncomeRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MyActivityController', () {
    late MyActivityController controller;
    late MockActivityRepository mockActivityRepository;
    late MockGuaranteeIncomeRepository mockGuaranteeIncomeRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      registerMockUserServices();
      mockActivityRepository = MockActivityRepository();
      mockGuaranteeIncomeRepository = MockGuaranteeIncomeRepository();
      controller = MyActivityController(activityRepository: mockActivityRepository, guaranteeIncomeRepository: mockGuaranteeIncomeRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'can be instantiated',
      () {
        expect(controller, isA<MyActivityController>());
      }
    );
  });
}
