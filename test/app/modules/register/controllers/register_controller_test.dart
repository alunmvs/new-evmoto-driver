import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/register/controllers/register_controller.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterController', () {
    late RegisterController controller;


    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();

      controller = RegisterController();
    });

    tearDown(() {
      Get.reset();
    });

    test('has invalid form as initial state', () {
      expect(controller.isFormValid.value, isFalse);
      expect(controller.formGroup.valid, isFalse);
    });

    testWidgets('marks form valid with correct phone number', (tester) async {
      controller.formGroup.control('mobile_phone').value = '8123456789';
      controller.formGroup.markAllAsTouched();
      controller.isFormValid.value = controller.formGroup.valid;
      expect(controller.isFormValid.value, isTrue);
    });
  });
}
