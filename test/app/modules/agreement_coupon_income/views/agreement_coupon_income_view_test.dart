import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';
import 'package:new_evmoto_driver/app/modules/agreement_coupon_income/controllers/agreement_coupon_income_controller.dart';
import 'package:new_evmoto_driver/app/modules/agreement_coupon_income/views/agreement_coupon_income_view.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAgreementRepository extends Mock implements AgreementRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AgreementCouponIncomeView', () {
    late AgreementCouponIncomeController controller;
    late MockAgreementRepository mockAgreementRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const AgreementCouponIncomeView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockAgreementRepository = MockAgreementRepository();
      when(
        () => mockAgreementRepository.getAgreementDetail(
          language: any(named: 'language'),
          userType: any(named: 'userType'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => Agreement(content: '<p>Test</p>'));
      controller = AgreementCouponIncomeController(agreementRepository: mockAgreementRepository);
      Get.put<AgreementCouponIncomeController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders agreement app bar', (tester) async {
      await pumpView(tester);
      await tester.pump();
      expect(find.text('Coupon Income'), findsOneWidget);
    });
  });
}
