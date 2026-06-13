import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/deposit_balance_payment_webview/controllers/deposit_balance_payment_webview_controller.dart';
import 'package:new_evmoto_driver/app/modules/deposit_balance_payment_webview/views/deposit_balance_payment_webview_view.dart';
import 'package:new_evmoto_driver/app/repositories/payment_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockPaymentRepository extends Mock implements PaymentRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DepositBalancePaymentWebviewView', () {
    late DepositBalancePaymentWebviewController controller;
    late MockPaymentRepository mockPaymentRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const DepositBalancePaymentWebviewView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(),
      );
      registerStubHomeController();
      mockPaymentRepository = MockPaymentRepository();
      controller = DepositBalancePaymentWebviewController(paymentRepository: mockPaymentRepository);
      Get.put<DepositBalancePaymentWebviewController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
      'renders DepositBalancePaymentWebview screen',
      (tester) async {
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
      },
      skip: true, // View requires integration test setup
    );
  });
}
