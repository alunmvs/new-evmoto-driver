import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_detail/controllers/order_payment_detail_controller.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_detail/views/order_payment_detail_view.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrderPaymentDetailView', () {
    late OrderPaymentDetailController controller;
    late MockOrderRepository mockOrderRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const OrderPaymentDetailView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(),
      );
      mockOrderRepository = MockOrderRepository();
      controller = OrderPaymentDetailController(orderRepository: mockOrderRepository);
      Get.put<OrderPaymentDetailController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
      'renders OrderPaymentDetail screen',
      (tester) async {
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
      },
      skip: true, // View requires integration test setup
    );
  });
}
