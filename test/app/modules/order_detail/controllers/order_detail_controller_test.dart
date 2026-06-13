import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/order_detail/controllers/order_detail_controller.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_driver/app/repositories/open_maps_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

class MockGoogleMapsRepository extends Mock implements GoogleMapsRepository {}

class MockOpenMapsRepository extends Mock implements OpenMapsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrderDetailController', () {
    late OrderDetailController controller;
    late MockOrderRepository mockOrderRepository;
    late MockGoogleMapsRepository mockGoogleMapsRepository;
    late MockOpenMapsRepository mockOpenMapsRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      registerStubHomeController();
      registerMockUserServices();
      mockOrderRepository = MockOrderRepository();
      mockGoogleMapsRepository = MockGoogleMapsRepository();
      mockOpenMapsRepository = MockOpenMapsRepository();
      controller = OrderDetailController(orderRepository: mockOrderRepository, googleMapsRepository: mockGoogleMapsRepository, openMapsRepository: mockOpenMapsRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'can be instantiated',
      () {
        expect(controller, isA<OrderDetailController>());
      },
      skip: true, // Requires integration test setup
    );
  });
}
