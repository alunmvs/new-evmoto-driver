import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class LoginController extends GetxController {
  final LoginRepository loginRepository;

  LoginController({required this.loginRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  // Form Login
  final loginFormKey = GlobalKey<FormState>();

  final mobilePhone = "".obs;
  final password = "".obs;

  final isHidePassword = true.obs;

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
  }

  Future<void> onTapLogin() async {
    var isFormValid = loginFormKey.currentState!.validate();
    if (isFormValid) {
      try {
        loginFormKey.currentState!.save();
        var token = await loginRepository.loginByMobileNumber(
          phone: mobilePhone.value,
          password: password.value,
          language: 2,
        );

        var storage = FlutterSecureStorage();
        await storage.write(key: "token", value: token);
      } catch (e) {
        Get.showSnackbar(
          GetSnackBar(message: e.toString(), duration: Duration(seconds: 2)),
        );
      }
    }
  }
}
