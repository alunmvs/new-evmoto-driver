import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/repositories/register_repository.dart';

import '../controllers/register_verification_otp_controller.dart';

class RegisterVerificationOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterVerificationOtpController>(
      () => RegisterVerificationOtpController(
        otpRepository: OtpRepository(),
        registerRepository: RegisterRepository(),
      ),
    );
  }
}
