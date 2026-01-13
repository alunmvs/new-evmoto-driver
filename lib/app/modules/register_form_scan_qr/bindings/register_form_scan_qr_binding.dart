import 'package:get/get.dart';

import '../controllers/register_form_scan_qr_controller.dart';

class RegisterFormScanQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterFormScanQrController>(
      () => RegisterFormScanQrController(),
    );
  }
}
