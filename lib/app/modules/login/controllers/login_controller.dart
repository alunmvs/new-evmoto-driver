import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class LoginController extends GetxController {
  final LoginRepository loginRepository;

  LoginController({required this.loginRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final loginRegisterFormKey = GlobalKey<FormState>();
  final mobileNumberTextEditingController = TextEditingController();

  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    mobileNumberTextEditingController.addListener(validateForm);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void validateForm() {
    isFormValid.value = loginRegisterFormKey.currentState!.validate();
  }

  Future<void> onTapSubmit() async {
    try {
      Get.toNamed(
        Routes.LOGIN_VERIFICATION_OTP,
        arguments: {
          "mobile_phone": "62${mobileNumberTextEditingController.text}",
        },
      );
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(message: e.toString(), duration: Duration(seconds: 2)),
      );
    }
  }
}
