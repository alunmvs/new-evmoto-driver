import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_form_controller.dart';

class RegisterFormView extends GetView<RegisterFormController> {
  const RegisterFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisterFormView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RegisterFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
