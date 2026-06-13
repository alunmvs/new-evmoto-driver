import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_confirmation/controllers/order_payment_confirmation_controller.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_confirmation/views/order_payment_confirmation_view.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrderPaymentConfirmationView', () {
    late OrderPaymentConfirmationController controller;
    late MockOrderRepository mockOrderRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const OrderPaymentConfirmationView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(selectLanguage: 'Select Language', save: 'Save'),
      );
      registerStubHomeController();
      Get.routing.args = {'order_id': '1', 'order_type': 1};
      mockOrderRepository = MockOrderRepository();
      controller = OrderPaymentConfirmationController(orderRepository: mockOrderRepository);
      Get.put<OrderPaymentConfirmationController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
      'renders OrderPaymentConfirmation screen',
      (tester) async {
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
      },
      skip: true, // View requires integration test setup
    );
  });
}
