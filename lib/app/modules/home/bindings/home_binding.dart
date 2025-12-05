import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import 'package:new_evmoto_driver/app/repositories/vehicle_repository.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        vehicleRepository: VehicleRepository(),
        orderRepository: OrderRepository(),
        userRepository: UserRepository(),
      ),
    );
  }
}
