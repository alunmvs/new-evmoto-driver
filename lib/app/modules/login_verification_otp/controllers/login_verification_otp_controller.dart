import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';

class LoginVerificationOtpController extends GetxController {
  final OtpRepository otpRepository;
  final LoginRepository loginRepository;

  LoginVerificationOtpController({
    required this.otpRepository,
    required this.loginRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

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
        phone: mobilePhone.value,
        language: languageServices.languageCodeSystem.value,
        type: 3,
      );
      isButtonResendEnable.value = false;
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }

  Future<void> onTapSubmit() async {
    try {
      await otpRepository.checkOTP(
        phone: mobilePhone.value,
        code: otpCode.value,
        language: languageServices.languageCodeSystem.value,
      );

      var token = await loginRepository.loginByMobileNumber(
        phone: mobilePhone.value,
        password: "123456789",
        language: languageServices.languageCodeSystem.value,
      );

      var storage = FlutterSecureStorage();
      await storage.write(key: "token", value: token);

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }
}
