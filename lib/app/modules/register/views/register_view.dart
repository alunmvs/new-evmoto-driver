import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
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
                SizedBox(height: 16),
                Image.asset(
                  "assets/logos/logo_evmoto.png",
                  width: 95.46,
                  height: 29.56,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller
                                  .languageServices
                                  .language
                                  .value
                                  .registerTitle ??
                              "-",
                          style: controller
                              .typographyServices
                              .headingSmallBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .textColor
                                    .value,
                              ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          controller
                                  .languageServices
                                  .language
                                  .value
                                  .registerSubtitle ??
                              "-",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .secondaryTextColor
                                    .value,
                              ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      "assets/images/img_progress_register_1_of_3.svg",
                      width: 72,
                      height: 72,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  controller.languageServices.language.value.mobilePhone ?? "-",
                  style: controller.typographyServices.bodyLargeRegular.value
                      .copyWith(
                        color:
                            controller.themeColorServices.thirdTextColor.value,
                      ),
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey200
                                .value,
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/icon_flag_id_square.png",
                              width: 20,
                              height: 13,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "+62",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .textColor
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ReactiveForm(
                        formGroup: controller.formGroup,
                        child: ReactiveTextField(
                          formControlName: 'mobile_phone',
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          cursorErrorColor:
                              controller.themeColorServices.primaryBlue.value,
                          keyboardType: TextInputType.phone,
                          maxLength: 25,
                          onChanged: (control) {
                            controller.mobilePhone.value =
                                control.value as String;

                            controller.isFormValid.value =
                                controller.formGroup.valid;
                            controller.formGroup.markAllAsTouched();
                          },
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationRequired ??
                                "-",
                            ValidationMessage.minLength: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationLengthMin8 ??
                                "-",
                            ValidationMessage.maxLength: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationMobileMaxLength ??
                                "-",
                            ValidationMessage.pattern: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationFirst8 ??
                                "-",
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            hintText: '812345678xxxx',
                            hintStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey500
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
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16 * 2),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: controller.isFormValid.value
                        ? () {
                            controller.onTapSubmit();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.themeColorServices.primaryBlue.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      controller.languageServices.language.value.buttonNext ??
                          "-",
                      style: controller.typographyServices.bodySmallBold.value
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text:
                        controller
                            .languageServices
                            .language
                            .value
                            .tncPrivacyConfirmation1 ??
                        "-",
                    style: controller
                        .typographyServices
                        .captionLargeRegular
                        .value
                        .copyWith(
                          color: controller.themeColorServices.textColor.value,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            " ${controller.languageServices.language.value.termAndCondition ?? "-"} ",
                        style: controller
                            .typographyServices
                            .captionLargeBold
                            .value
                            .copyWith(
                              color:
                                  controller.themeColorServices.textColor.value,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(Routes.TERMS_AND_CONDITIONS);
                          },
                      ),
                      TextSpan(
                        text:
                            controller
                                .languageServices
                                .language
                                .value
                                .tncPrivacyConfirmation2 ??
                            "-",
                        style: controller
                            .typographyServices
                            .captionLargeRegular
                            .value
                            .copyWith(
                              color:
                                  controller.themeColorServices.textColor.value,
                            ),
                      ),
                      TextSpan(
                        text:
                            " ${controller.languageServices.language.value.privacyPolicy ?? "-"} ",
                        style: controller
                            .typographyServices
                            .captionLargeBold
                            .value
                            .copyWith(
                              color:
                                  controller.themeColorServices.textColor.value,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(Routes.PRIVACY_POLICY);
                          },
                      ),
                      TextSpan(
                        text:
                            controller
                                .languageServices
                                .language
                                .value
                                .tncPrivacyConfirmation3 ??
                            "-",
                        style: controller
                            .typographyServices
                            .captionLargeRegular
                            .value
                            .copyWith(
                              color:
                                  controller.themeColorServices.textColor.value,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
