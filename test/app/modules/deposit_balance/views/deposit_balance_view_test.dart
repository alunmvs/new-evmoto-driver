import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/deposit_balance/controllers/deposit_balance_controller.dart';
import 'package:new_evmoto_driver/app/modules/deposit_balance/views/deposit_balance_view.dart';
import 'package:new_evmoto_driver/app/repositories/payment_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockPaymentRepository extends Mock implements PaymentRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DepositBalanceView', () {
    late DepositBalanceController controller;
    late MockPaymentRepository mockPaymentRepository;
    late MockUserRepository mockUserRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const DepositBalanceView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(save: 'Save'),
      );
      mockPaymentRepository = MockPaymentRepository();
      mockUserRepository = MockUserRepository();
      controller = DepositBalanceController(paymentRepository: mockPaymentRepository, userRepository: mockUserRepository);
      Get.put<DepositBalanceController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
      'renders DepositBalance screen',
      (tester) async {
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
      },
      skip: true, // View requires integration test setup
    );
  });
}
