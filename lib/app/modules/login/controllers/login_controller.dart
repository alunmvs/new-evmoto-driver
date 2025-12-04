import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:reactive_forms/reactive_forms.dart';

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
      // var token = await loginRepository.loginByMobileNumber(
      //   phone: formGroup.control("mobile_number").value,
      //   password: formGroup.control("password").value,
      //   language: 2,
      // );

      // var storage = FlutterSecureStorage();
      // await storage.write(key: "token", value: token);
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(message: e.toString(), duration: Duration(seconds: 2)),
      );
    }
  }
}
