import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_verification_otp_controller.dart';

class LoginVerificationOtpView extends GetView<LoginVerificationOtpController> {
  const LoginVerificationOtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginVerificationOtpView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LoginVerificationOtpView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
