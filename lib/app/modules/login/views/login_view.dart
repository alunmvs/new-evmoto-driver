import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        surfaceTintColor:
            controller.themeColorServices.neutralsColorGrey0.value,
      ),
      backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Form(
                key: controller.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Mobile Phone Number"),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        controller.mobilePhone.value = newValue ?? "";
                      },
                    ),
                    SizedBox(height: 8),
                    Text("Password"),
                    TextFormField(
                      onSaved: (newValue) {
                        controller.password.value = newValue ?? "";
                      },
                      decoration: InputDecoration(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.FORGET_PASSWORD);
                    },
                    child: Text("Forgot your password?"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.TERMS_AND_CONDITIONS);
                    },
                    child: Text("Terms and Conditions"),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.PRIVACY_POLICY);
                    },
                    child: Text("Privacy Policy"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.onTapLogin();
                  },
                  child: Text("Login"),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.REGISTER);
                  },
                  child: Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
