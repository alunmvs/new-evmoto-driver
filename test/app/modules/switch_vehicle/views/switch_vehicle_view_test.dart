import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/switch_vehicle/controllers/switch_vehicle_controller.dart';
import 'package:new_evmoto_driver/app/modules/switch_vehicle/views/switch_vehicle_view.dart';
import 'package:new_evmoto_driver/app/repositories/vehicle_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

import 'package:new_evmoto_driver/app/data/models/my_vehicle_model.dart';
class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SwitchVehicleView', () {
    late SwitchVehicleController controller;
    late MockVehicleRepository mockVehicleRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const SwitchVehicleView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(),
      );
      mockVehicleRepository = MockVehicleRepository();
      when(
        () => mockVehicleRepository.getMyVehicleDetail(
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => MyVehicle());
      when(
        () => mockVehicleRepository.switchVehicle(
          language: any(named: 'language'),
          carId: any(named: 'carId'),
        ),
      ).thenAnswer((_) async {});
      controller = SwitchVehicleController(vehicleRepository: mockVehicleRepository);
      Get.put<SwitchVehicleController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders switch vehicle screen', (tester) async {
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
