import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/forget_password_repository.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';

class ForgetPasswordController extends GetxController {
  final OtpRepository otpRepository;
  final ForgetPasswordRepository forgetPasswordRepository;

  ForgetPasswordController({
    required this.otpRepository,
    required this.forgetPasswordRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final mobileNumber = "".obs;
  final newPassword = "".obs;
  final otpCode = "".obs;

  final forgetPasswordFormKey = GlobalKey<FormState>();

  final otpProtectionTimerSeconds = 0.obs;
  late Timer? otpProtectionTimer;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    try {
      otpProtectionTimer?.cancel();
    } catch (e) {}
  }

  Future<void> onTapSendOTP() async {
    forgetPasswordFormKey.currentState!.save();
    if (mobileNumber.value == "") {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          "Nomor HP wajib diisi",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      return;
    }

    await otpRepository.requestOTP(
      phone: mobileNumber.value,
      language: 2,
      type: 4,
    );

    otpProtectionTimerSeconds.value = 60;
    otpProtectionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (otpProtectionTimerSeconds.value == 0) {
        otpProtectionTimer?.cancel();
      } else {
        otpProtectionTimerSeconds.value -= 1;
      }
    });

    final SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: themeColorServices.sematicColorRed400.value,
      content: Text(
        "OTP telah terkirim",
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
    );
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  Future<void> onTapConfirm() async {
    forgetPasswordFormKey.currentState!.save();

    if (mobileNumber.value == "") {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          "Nomor HP wajib diisi",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      return;
    }

    print(mobileNumber.value);
    print(otpCode.value);
    print(newPassword.value);

    if (otpCode.value == "") {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          "Kode OTP wajib diisi",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      return;
    }

    if (newPassword.value == "") {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          "Kata sandi wajib diisi",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      return;
    }

    try {
      await forgetPasswordRepository.resetPassword(
        phone: mobileNumber.value,
        password: newPassword.value,
        code: otpCode.value,
        language: 2,
      );

      Get.back();

      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorGreen400.value,
        content: Text(
          "Kata sandi berhasil di reset",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
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
