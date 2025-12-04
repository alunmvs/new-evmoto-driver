import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';

import '../controllers/login_verification_otp_controller.dart';

class LoginVerificationOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginVerificationOtpController>(
      () => LoginVerificationOtpController(
        loginRepository: LoginRepository(),
        otpRepository: OtpRepository(),
      ),
    );
  }
}
