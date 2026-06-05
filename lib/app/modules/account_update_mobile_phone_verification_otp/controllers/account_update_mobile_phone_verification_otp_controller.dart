import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_driver/main.dart';

class AccountUpdateMobilePhoneVerificationOtpController extends GetxController {
  final AccountRepository accountRepository;

  AccountUpdateMobilePhoneVerificationOtpController({
    required this.accountRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final mobilePhone = "".obs;
  final otpCode = "".obs;

  final isButtonResendEnable = false.obs;

  final isFetch = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isFetch.value = true;
    mobilePhone.value = Get.arguments['new_mobile_phone'] ?? "";
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
    isButtonResendEnable.value = false;
  }

  Future<void> onTapSubmit() async {
    try {
      await accountRepository.updateMobilePhone(
        password: "123456789",
        phone: "62${mobilePhone.value}",
        language: languageServices.languageCodeSystem.value,
      );
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
      Get.back();
      return;
    }

    Get.back();
    Get.back();
    SnackbarHelper.showSnackbarSuccess(
      text: languageServices.language.value.mobileNumberSuccessChanged ?? "-",
    );
  }
}
