import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../controllers/account_update_mobile_phone_verification_otp_controller.dart';

class AccountUpdateMobilePhoneVerificationOtpView
    extends GetView<AccountUpdateMobilePhoneVerificationOtpController> {
  const AccountUpdateMobilePhoneVerificationOtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Ubah Nomor Telepon",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.backgroundColor.value,
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
                      Text(
                        "Verifikasi Kode",
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
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
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
                                "Kirim ulang kode",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
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
                                  await controller.onTapSubmit();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.themeColorServices.primaryBlue.value,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Lanjutkan",
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
