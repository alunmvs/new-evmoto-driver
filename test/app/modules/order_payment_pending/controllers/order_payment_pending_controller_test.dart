import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_pending/controllers/order_payment_pending_controller.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrderPaymentPendingController', () {
    late OrderPaymentPendingController controller;
    late MockOrderRepository mockOrderRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockOrderRepository = MockOrderRepository();
      controller = OrderPaymentPendingController(orderRepository: mockOrderRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'can be instantiated',
      () {
        expect(controller, isA<OrderPaymentPendingController>());
      }
    );
  });
}
