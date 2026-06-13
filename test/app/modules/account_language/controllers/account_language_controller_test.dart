import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/account_language/controllers/account_language_controller.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountLanguageController', () {
    late AccountLanguageController controller;


    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();

      controller = AccountLanguageController();
    });

    tearDown(() {
      Get.reset();
    });

    test('initializes tempLanguageCode from language service', () {
      controller.onInit();
      expect(controller.tempLanguageCode.value, isNotEmpty);
    });

    test('updates tempLanguageCode when language is changed', () {
      controller.tempLanguageCode.value = 'EN';
      expect(controller.tempLanguageCode.value, 'EN');
    });
  });
}
