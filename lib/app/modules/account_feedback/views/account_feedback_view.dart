import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/account_feedback_controller.dart';

class AccountFeedbackView extends GetView<AccountFeedbackController> {
  const AccountFeedbackView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller
                    .languageServices
                    .language
                    .value
                    .evaluationNotFoundTitle ??
                "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.backgroundColor.value,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ReactiveForm(
              formGroup: controller.formGroup,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  ReactiveTextField(
                    style: controller.typographyServices.bodySmallRegular.value,
                    cursorErrorColor:
                        controller.themeColorServices.primaryBlue.value,
                    formControlName: 'content',
                    maxLines: 10,
                    validationMessages: {
                      ValidationMessage.required: (error) => 'Wajib diisi',
                    },
                    decoration: InputDecoration(
                      fillColor: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 12,
                      ),
                      prefix: SizedBox(width: 12),
                      suffix: SizedBox(width: 12),
                      hintText:
                          controller
                              .languageServices
                              .language
                              .value
                              .hintFeedback ??
                          "-",
                      hintStyle: controller
                          .typographyServices
                          .bodySmallRegular
                          .value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey400
                                .value,
                          ),
                      errorStyle: controller
                          .typographyServices
                          .bodySmallRegular
                          .value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .sematicColorRed500
                                .value,
                          ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: controller
                              .themeColorServices
                              .sematicColorRed500
                              .value,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: controller
                              .themeColorServices
                              .sematicColorRed500
                              .value,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey400
                              .value,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey400
                              .value,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              controller.themeColorServices.primaryBlue.value,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    controller.languageServices.language.value.noteMax200Char ??
                        "-",
                    style: controller.typographyServices.bodySmallRegular.value
                        .copyWith(color: Color(0XFFB3B3B3)),
                  ),
                  SizedBox(height: 16 * 2),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          color: controller.themeColorServices.neutralsColorGrey0.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoaderElevatedButton(
                onPressed: () async {
                  await controller.onTapSubmitFeedback();
                },
                child: Text(
                  controller.languageServices.language.value.sendFeedback ??
                      "-",
                  style: controller.typographyServices.bodySmallBold.value
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
