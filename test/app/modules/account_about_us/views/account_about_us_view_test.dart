import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';
import 'package:new_evmoto_driver/app/modules/account_about_us/controllers/account_about_us_controller.dart';
import 'package:new_evmoto_driver/app/modules/account_about_us/views/account_about_us_view.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';
class MockAgreementRepository extends Mock implements AgreementRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountAboutUsView', () {
    late AccountAboutUsController controller;
    late MockAgreementRepository mockAgreementRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const AccountAboutUsView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(aboutUs: 'About Us'),
      );
      mockAgreementRepository = MockAgreementRepository();
      when(
        () => mockAgreementRepository.getAgreementDetail(
          language: any(named: 'language'),
          userType: any(named: 'userType'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => Agreement(content: '<p>Test</p>'));
      controller = AccountAboutUsController(agreementRepository: mockAgreementRepository);
      Get.put<AccountAboutUsController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders agreement app bar', (tester) async {
      await pumpView(tester);
      await tester.pump();
      expect(find.text('About Us'), findsOneWidget);
    });
  });
}
