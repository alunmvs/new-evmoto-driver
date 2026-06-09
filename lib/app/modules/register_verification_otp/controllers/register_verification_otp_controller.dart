import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/registered_driver_model.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/repositories/register_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_driver/main.dart';

class RegisterVerificationOtpController extends GetxController {
  final OtpRepository otpRepository;
  final RegisterRepository registerRepository;

  RegisterVerificationOtpController({
    required this.otpRepository,
    required this.registerRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final mobilePhone = "".obs;
  final otpCode = "".obs;

  final registeredDriver = RegisteredDriver().obs;

  final isButtonResendEnable = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    mobilePhone.value = Get.arguments["mobile_phone"] ?? "";
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
        language: languageServices.languageCodeSystem.value,
        type: 3,
      );
      isButtonResendEnable.value = false;
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  Future<void> onTapNext() async {
    try {
      await otpRepository.checkOTP(
        phone: "62${mobilePhone.value}",
        language: languageServices.languageCodeSystem.value,
        code: otpCode.value,
      );
      registeredDriver.value = (await registerRepository
          .registerDriverNoPassword(
            code: otpCode.value,
            language: languageServices.languageCodeSystem.value,
            phone: "62${mobilePhone.value}",
          ))!;

      Get.toNamed(
        Routes.REGISTER_FORM,
        arguments: {
          "uid": registeredDriver.value.id.toString(),
          "mobile_phone": mobilePhone.value,
        },
      );
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }
}
