import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/privacy_policy/controllers/privacy_policy_controller.dart';
import 'package:new_evmoto_driver/app/modules/privacy_policy/views/privacy_policy_view.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';
class MockAgreementRepository extends Mock implements AgreementRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrivacyPolicyView', () {
    late PrivacyPolicyController controller;
    late MockAgreementRepository mockAgreementRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const PrivacyPolicyView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(),
      );
      mockAgreementRepository = MockAgreementRepository();
      when(
        () => mockAgreementRepository.getAgreementDetail(
          language: any(named: 'language'),
          userType: any(named: 'userType'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => Agreement(content: '<p>Test</p>'));
      controller = PrivacyPolicyController(agreementRepository: mockAgreementRepository);
      Get.put<PrivacyPolicyController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
      'renders scaffold with app bar',
      (tester) async {
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      },
      skip: true, // InAppWebView is not supported in widget tests
    );
  });
}
