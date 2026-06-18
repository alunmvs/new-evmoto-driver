import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/my_vehicle_model.dart';
import 'package:new_evmoto_driver/app/modules/switch_vehicle/controllers/switch_vehicle_controller.dart';
import 'package:new_evmoto_driver/app/repositories/vehicle_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SwitchVehicleController', () {
    late SwitchVehicleController controller;
    late MockVehicleRepository mockVehicleRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockVehicleRepository = MockVehicleRepository();
      controller = SwitchVehicleController(vehicleRepository: mockVehicleRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test('loads vehicle detail on init', () async {
      when(
        () => mockVehicleRepository.getMyVehicleDetail(language: any(named: 'language')),
      ).thenAnswer((_) async => MyVehicle());

      await controller.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(controller.isFetch.value, isFalse);
      verify(() => mockVehicleRepository.getMyVehicleDetail(language: any(named: 'language'))).called(1);
    });
  });
}
