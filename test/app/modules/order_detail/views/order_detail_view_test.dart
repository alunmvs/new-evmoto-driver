import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/order_detail/controllers/order_detail_controller.dart';
import 'package:new_evmoto_driver/app/modules/order_detail/views/order_detail_view.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_driver/app/repositories/open_maps_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

class MockGoogleMapsRepository extends Mock implements GoogleMapsRepository {}

class MockOpenMapsRepository extends Mock implements OpenMapsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrderDetailView', () {
    late OrderDetailController controller;
    late MockOrderRepository mockOrderRepository;
    late MockGoogleMapsRepository mockGoogleMapsRepository;
    late MockOpenMapsRepository mockOpenMapsRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const OrderDetailView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(selectLanguage: 'Select Language', save: 'Save'),
      );
      registerStubHomeController();
      registerMockUserServices();
      mockOrderRepository = MockOrderRepository();
      mockGoogleMapsRepository = MockGoogleMapsRepository();
      mockOpenMapsRepository = MockOpenMapsRepository();
      controller = OrderDetailController(orderRepository: mockOrderRepository, googleMapsRepository: mockGoogleMapsRepository, openMapsRepository: mockOpenMapsRepository);
      Get.put<OrderDetailController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets(
      'renders OrderDetail screen',
      (tester) async {
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
      },
      skip: true, // View requires integration test setup
    );
  });
}
