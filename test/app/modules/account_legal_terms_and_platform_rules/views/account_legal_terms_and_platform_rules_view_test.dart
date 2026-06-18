import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';
import 'package:new_evmoto_driver/app/modules/account_legal_terms_and_platform_rules/controllers/account_legal_terms_and_platform_rules_controller.dart';
import 'package:new_evmoto_driver/app/modules/account_legal_terms_and_platform_rules/views/account_legal_terms_and_platform_rules_view.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAgreementRepository extends Mock implements AgreementRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountLegalTermsAndPlatformRulesView', () {
    late AccountLegalTermsAndPlatformRulesController controller;
    late MockAgreementRepository mockAgreementRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const AccountLegalTermsAndPlatformRulesView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(legalTermsAndApplicationRules: 'Legal Terms'),
      );
      mockAgreementRepository = MockAgreementRepository();
      when(
        () => mockAgreementRepository.getAgreementDetail(
          language: any(named: 'language'),
          userType: any(named: 'userType'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => Agreement(content: '<p>Test</p>'));
      controller = AccountLegalTermsAndPlatformRulesController(agreementRepository: mockAgreementRepository);
      Get.put<AccountLegalTermsAndPlatformRulesController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders agreement app bar', (tester) async {
      await pumpView(tester);
      await tester.pump();
      expect(find.text('Legal Terms'), findsOneWidget);
    });
  });
}
