import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../controllers/register_verification_otp_controller.dart';

class RegisterVerificationOtpView
    extends GetView<RegisterVerificationOtpController> {
  const RegisterVerificationOtpView({super.key});
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
        body: controller.isFetch.value
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      SvgPicture.asset(
                        "assets/logos/logo_evmoto.svg",
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
                                        .validateOtpTitle ??
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
                                        .validateOtpSubtitle ??
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
                        controller
                                .languageServices
                                .language
                                .value
                                .resendVerificationCode ??
                            "-",
                        style: controller
                            .typographyServices
                            .bodyLargeRegular
                            .value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .thirdTextColor
                                  .value,
                            ),
                      ),
                      SizedBox(height: 8),
                      Pinput(
                        defaultPinTheme: PinTheme(
                          textStyle: controller
                              .typographyServices
                              .headingMediumBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                          width: MediaQuery.of(context).size.width * (83 / 375),
                          height: 47,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey400
                                  .value,
                            ),
                          ),
                        ),
                        onCompleted: (pin) {
                          controller.otpCode.value = pin;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (controller.isButtonResendEnable.value ==
                              false) ...[
                            SlideCountdown(
                              duration: Duration(minutes: 1),
                              countUp: false,
                              separatorStyle: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .forthTextColor
                                        .value,
                                  ),
                              shouldShowMinutes: (value) {
                                return true;
                              },
                              onDone: () {
                                controller.isButtonResendEnable.value = true;
                              },
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.all(0),
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .forthTextColor
                                        .value,
                                  ),
                            ),
                          ],
                          SizedBox(width: 10),
                          SizedBox(
                            height: 34,
                            child: ElevatedButton(
                              onPressed: controller.isButtonResendEnable.value
                                  ? () async {
                                      await controller.requestOtp();
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                backgroundColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                controller
                                        .languageServices
                                        .language
                                        .value
                                        .resendVerificationCode ??
                                    "-",
                                style: controller
                                    .typographyServices
                                    .bodySmallBold
                                    .value
                                    .copyWith(color: Colors.white),
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
                          onPressed: controller.otpCode.value.length != 4
                              ? null
                              : () async {
                                  await controller.onTapNext();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.themeColorServices.primaryBlue.value,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .buttonNext ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallBold
                                .value
                                .copyWith(color: Colors.white),
                          ),
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
