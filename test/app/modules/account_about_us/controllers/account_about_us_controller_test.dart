import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';
import 'package:new_evmoto_driver/app/modules/account_about_us/controllers/account_about_us_controller.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAgreementRepository extends Mock implements AgreementRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountAboutUsController', () {
    late AccountAboutUsController controller;
    late MockAgreementRepository mockAgreementRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockAgreementRepository = MockAgreementRepository();
      controller = AccountAboutUsController(agreementRepository: mockAgreementRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test('fetches agreement on init', () async {
      when(
        () => mockAgreementRepository.getAgreementDetail(
          language: any(named: 'language'),
          userType: any(named: 'userType'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => Agreement(content: '<p>Test content</p>'));

      await controller.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(controller.isFetch.value, isFalse);
      expect(controller.agreement.value.content, '<p>Test content</p>');
    });
  });
}
