import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';

class AccountUpdateMobilePhoneVerificationOtpController extends GetxController {
  final AccountRepository accountRepository;

  AccountUpdateMobilePhoneVerificationOtpController({
    required this.accountRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

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
        password: "1234567899",
        phone: "62${mobilePhone.value}",
        language: 2,
      );
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
      Get.back();
      return;
    }

    Get.back();
    Get.back();

    final SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: themeColorServices.sematicColorGreen400.value,
      content: Text(
        "Nomor HP berhasil diubah",
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
    );
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
