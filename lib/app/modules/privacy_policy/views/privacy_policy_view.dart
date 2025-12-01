import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';

import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: const Text('Privacy Policy'), centerTitle: true),
        body: controller.isFetch.value
            ? Center(child: CircularProgressIndicator())
            : Html(data: controller.agreement.value.content),
      ),
    );
  }
}
