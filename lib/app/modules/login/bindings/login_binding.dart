import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(loginRepository: LoginRepository()),
    );
  }
}
