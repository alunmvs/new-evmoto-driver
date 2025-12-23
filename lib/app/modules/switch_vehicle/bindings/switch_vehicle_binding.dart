import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/vehicle_repository.dart';

import '../controllers/switch_vehicle_controller.dart';

class SwitchVehicleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwitchVehicleController>(
      () => SwitchVehicleController(vehicleRepository: VehicleRepository()),
    );
  }
}
