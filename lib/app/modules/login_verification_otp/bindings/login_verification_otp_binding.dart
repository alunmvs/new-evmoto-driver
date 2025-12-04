import 'package:get/get.dart';

import '../controllers/login_verification_otp_controller.dart';

class LoginVerificationOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginVerificationOtpController>(
      () => LoginVerificationOtpController(),
    );
  }
}
