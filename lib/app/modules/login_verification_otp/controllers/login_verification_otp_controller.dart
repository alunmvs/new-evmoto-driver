import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class LoginVerificationOtpController extends GetxController {
  final OtpRepository otpRepository;
  final LoginRepository loginRepository;

  LoginVerificationOtpController({
    required this.otpRepository,
    required this.loginRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final mobilePhone = "".obs;
  final otpCode = "".obs;

  final isButtonResendEnable = false.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    mobilePhone.value = Get.arguments['mobile_phone'] ?? "";
    await requestOtp();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> requestOtp() async {
    try {
      await otpRepository.requestOTP(
        phone: "62${mobilePhone.value}",
        language: 2,
        type: 3,
      );
      isButtonResendEnable.value = false;
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.toString(),
          duration: Duration(seconds: 2),
          backgroundColor: themeColorServices.sematicColorRed500.value,
        ),
      );
    }
  }

  Future<void> onTapSubmit() async {
    try {
      var token = await loginRepository.loginByMobileNumber(
        phone: mobilePhone.value,
        password: "1234567899",
        language: 2,
      );

      var storage = FlutterSecureStorage();
      await storage.write(key: "token", value: token);

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.offAllNamed(Routes.LOGIN);

      Get.showSnackbar(
        GetSnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: themeColorServices.sematicColorRed400.value,
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.GROUNDED,
          messageText: Text(
            e.toString(),
            style: typographyServices.bodySmallRegular.value.copyWith(
              color: themeColorServices.neutralsColorGrey0.value,
            ),
          ),
        ),
      );
    }
  }
}
