import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/forget_password_repository.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';

import '../controllers/forget_password_controller.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(
        otpRepository: OtpRepository(),
        forgetPasswordRepository: ForgetPasswordRepository(),
      ),
    );
  }
}
