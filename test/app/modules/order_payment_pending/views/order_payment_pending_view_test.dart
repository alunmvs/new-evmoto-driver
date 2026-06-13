import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_pending/controllers/order_payment_pending_controller.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_pending/views/order_payment_pending_view.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrderPaymentPendingView', () {
    late OrderPaymentPendingController controller;
    late MockOrderRepository mockOrderRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const OrderPaymentPendingView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(),
      );
      mockOrderRepository = MockOrderRepository();
      controller = OrderPaymentPendingController(orderRepository: mockOrderRepository);
      Get.put<OrderPaymentPendingController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
      'renders OrderPaymentPending screen',
      (tester) async {
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
      },
      skip: true, // View requires integration test setup
    );
  });
}
