import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_detail/controllers/order_payment_detail_controller.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrderPaymentDetailController', () {
    late OrderPaymentDetailController controller;
    late MockOrderRepository mockOrderRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockOrderRepository = MockOrderRepository();
      controller = OrderPaymentDetailController(orderRepository: mockOrderRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'can be instantiated',
      () {
        expect(controller, isA<OrderPaymentDetailController>());
      }
    );
  });
}
