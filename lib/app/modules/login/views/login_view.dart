import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: controller.themeColorServices.neutralsColorGrey0.value,
        child: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: Scaffold(
            backgroundColor:
                controller.themeColorServices.neutralsColorGrey0.value,
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0XFFFFFFFF),
                      Color(0XFFA5C8EF),
                      Color(0XFFE1EFFF).withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.47, 1.0],
                  ).withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/img_login_3x.png",
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(height: 24),
                    Text(
                      controller.languageServices.language.value.loginTitle ??
                          "-",
                      style:
                          controller.typographyServices.headingSmallBold.value,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .loginSubtitle ??
                          "-",
                      style:
                          controller.typographyServices.bodySmallRegular.value,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 22),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0XFF2D74BF),
                                    Color(0XFF114E8E),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 16),
                                  SizedBox(
                                    height: 50,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                          ),
                                          child: RichText(
                                            textAlign: TextAlign.center,
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
                                                    color: Colors.white,
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
                                                        color: Colors.white,
                                                      ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      Get.toNamed(
                                                        Routes
                                                            .TERMS_AND_CONDITIONS,
                                                      );
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
                                                        color: Colors.white,
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
                                                        color: Colors.white,
                                                      ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Get.toNamed(
                                                            Routes
                                                                .PRIVACY_POLICY,
                                                          );
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
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 14),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  border: Border.all(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey200
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: controller
                                          .themeColorServices
                                          .overlayDark100
                                          .value
                                          .withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                      offset: Offset(0, -1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .mobilePhone ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value,
                                    ),
                                    SizedBox(height: 4),
                                    Form(
                                      key: controller.loginRegisterFormKey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: controller
                                                .mobileNumberTextEditingController,
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value,
                                            cursorErrorColor: controller
                                                .themeColorServices
                                                .primaryBlue
                                                .value,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
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
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: controller
                                                          .themeColorServices
                                                          .sematicColorRed500
                                                          .value,
                                                    ),
                                                  ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey400
                                                      .value,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: controller
                                                      .themeColorServices
                                                      .primaryBlue
                                                      .value,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              prefixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(width: 12),
                                                  Text(
                                                    "+62",
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallBold
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey400
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onChanged: (value) {
                                              controller.mobilePhone.value =
                                                  value;
                                              controller.validateForm();
                                            },
                                            maxLength: 25,
                                            validator: (value) {
                                              if (value != null) {
                                                if (value.isNotEmpty) {
                                                  if (value.substring(0, 1) !=
                                                      "8") {
                                                    return controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .formValidationFirst8 ??
                                                        "-";
                                                  }
                                                }
                                                if (value.length < 8) {
                                                  return controller
                                                          .languageServices
                                                          .language
                                                          .value
                                                          .formValidationLengthMin8 ??
                                                      "-";
                                                }
                                              }
                                              return null;
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          SizedBox(
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            height: 46,
                                            child: ElevatedButton(
                                              onPressed:
                                                  controller.isFormValid.value
                                                  ? () async {
                                                      await controller
                                                          .onTapSubmit();
                                                    }
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    controller.isFormValid.value
                                                    ? controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value
                                                    : controller
                                                          .themeColorServices
                                                          .neutralsColorGrey300
                                                          .value,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  side: BorderSide(
                                                    color:
                                                        controller
                                                            .isFormValid
                                                            .value
                                                        ? controller
                                                              .themeColorServices
                                                              .sematicColorBlue200
                                                              .value
                                                        : controller
                                                              .themeColorServices
                                                              .neutralsColorGrey200
                                                              .value,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .loginButton ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallBold
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey0
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text:
                                                  controller
                                                      .languageServices
                                                      .language
                                                      .value
                                                      .loginContactCs1 ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallRegular
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey500
                                                        .value,
                                                  ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      " ${controller.languageServices.language.value.loginContactCs2 ?? "-"} ",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallBold
                                                      .value
                                                      .copyWith(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey500
                                                            .value,
                                                      ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          await controller
                                                              .onTapContactCs();
                                                        },
                                                ),
                                                TextSpan(
                                                  text:
                                                      controller
                                                          .languageServices
                                                          .language
                                                          .value
                                                          .loginContactCs3 ??
                                                      "-",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallRegular
                                                      .value
                                                      .copyWith(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey500
                                                            .value,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 9),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              height: 54,
              color: controller.themeColorServices.neutralsColorGrey0.value,
              padding: EdgeInsets.all(0),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.REGISTER);
                },
                child: Container(
                  height: 54,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    boxShadow: [
                      BoxShadow(
                        color: controller
                            .themeColorServices
                            .overlayDark100
                            .value
                            .withValues(alpha: 0.07),
                        blurRadius: 25,
                        spreadRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_user_add.svg",
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 5),
                      Text(
                        controller
                                .languageServices
                                .language
                                .value
                                .registerAsNewDriver ??
                            "-",
                        style: controller.typographyServices.bodySmallBold.value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
