import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';

import '../controllers/terms_and_conditions_controller.dart';

class TermsAndConditionsView extends GetView<TermsAndConditionsController> {
  const TermsAndConditionsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Terms and Conditions'),
          centerTitle: true,
        ),
        body: controller.isFetch.value
            ? Center(child: CircularProgressIndicator())
            : Html(data: controller.agreement.value.content),
      ),
    );
  }
}
