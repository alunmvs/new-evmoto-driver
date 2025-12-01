import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/forget_password_repository.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

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
    if (mobileNumber.value == "") {
      Get.showSnackbar(
        GetSnackBar(
          message: "Nomor HP wajib diisi",
          duration: Duration(seconds: 2),
        ),
      );
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

    Get.showSnackbar(
      GetSnackBar(
        message: "OTP telah terkirim".toString(),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> onTapConfirm() async {
    forgetPasswordFormKey.currentState!.save();

    if (mobileNumber.value == "") {
      Get.showSnackbar(
        GetSnackBar(
          message: "Nomor HP wajib diisi",
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    print(mobileNumber.value);
    print(otpCode.value);
    print(newPassword.value);

    if (otpCode.value == "") {
      Get.showSnackbar(
        GetSnackBar(
          message: "Kode OTP wajib diisi",
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (newPassword.value == "") {
      Get.showSnackbar(
        GetSnackBar(
          message: "Kata sandi wajib diisi",
          duration: Duration(seconds: 2),
        ),
      );
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

      Get.showSnackbar(
        GetSnackBar(
          message: "Kata sandi berhasil di reset",
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(message: e.toString(), duration: Duration(seconds: 2)),
      );
    }
  }
}
