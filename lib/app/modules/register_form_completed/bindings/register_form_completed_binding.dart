import 'package:get/get.dart';

import '../controllers/register_form_completed_controller.dart';

class RegisterFormCompletedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterFormCompletedController>(
      () => RegisterFormCompletedController(),
    );
  }
}
