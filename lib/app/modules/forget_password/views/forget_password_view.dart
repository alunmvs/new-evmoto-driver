import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: const Text('Forget Password'), centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: controller.forgetPasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mobile Number"),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (newValue) {
                      controller.mobileNumber.value = newValue ?? "";
                    },
                    onChanged: (value) {
                      controller.mobileNumber.value = value;
                    },
                  ),
                  SizedBox(height: 12),
                  Text("OTP Code"),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (newValue) {
                      controller.otpCode.value = newValue ?? "";
                    },
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          if (controller.otpProtectionTimerSeconds.value == 0) {
                            await controller.onTapSendOTP();
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (controller.otpProtectionTimerSeconds.value ==
                                0) ...[
                              Text("Kirim Kode OTP"),
                            ],
                            if (controller.otpProtectionTimerSeconds.value !=
                                0) ...[
                              Text(
                                controller.otpProtectionTimerSeconds.value
                                    .toString(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text("Password"),
                  TextFormField(
                    onSaved: (newValue) {
                      controller.newPassword.value = newValue ?? "";
                    },
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.onTapConfirm();
                      },
                      child: Text("Konfirmasi"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
