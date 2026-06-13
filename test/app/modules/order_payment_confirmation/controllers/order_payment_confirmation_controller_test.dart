import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_confirmation/controllers/order_payment_confirmation_controller.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrderPaymentConfirmationController', () {
    late OrderPaymentConfirmationController controller;
    late MockOrderRepository mockOrderRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      registerStubHomeController();
      Get.routing.args = {'order_id': '1', 'order_type': 1};
      mockOrderRepository = MockOrderRepository();
      controller = OrderPaymentConfirmationController(orderRepository: mockOrderRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'can be instantiated',
      () {
        expect(controller, isA<OrderPaymentConfirmationController>());
      }
    );
  });
}
