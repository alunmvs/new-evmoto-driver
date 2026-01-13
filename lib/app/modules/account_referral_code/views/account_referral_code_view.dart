import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/account_referral_code_controller.dart';

class AccountReferralCodeView extends GetView<AccountReferralCodeController> {
  const AccountReferralCodeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kode Referral",
          style: controller.typographyServices.bodyLargeBold.value,
        ),
        centerTitle: false,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        surfaceTintColor:
            controller.themeColorServices.neutralsColorGrey0.value,
      ),
      backgroundColor: controller.themeColorServices.backgroundColor.value,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: controller.themeColorServices.neutralsColorGrey0.value,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Bagikan Kode Referral Anda",
                    style: controller.typographyServices.bodySmallRegular.value,
                  ),
                  SizedBox(height: 16),
                  DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: controller.themeColorServices.primaryBlue.value,
                      strokeWidth: 1,
                      dashPattern: [8, 4],
                      borderPadding: EdgeInsets.all(0),
                      radius: Radius.circular(8),
                    ),
                    child: Container(
                      height: 56,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0XFFDDEDFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          controller
                                  .homeController
                                  .userInfo
                                  .value
                                  .referralCode ??
                              "",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          width: MediaQuery.of(context).size.width,
                          child: OutlinedButton(
                            onPressed: () async {
                              await controller.onTapCopyReferralCode();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0XFF0060C6)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_clipboard.svg",
                                        width: 11.97,
                                        height: 13.33,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Salin Kode",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(color: Color(0XFF0060C6)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          width: MediaQuery.of(context).size.width,
                          child: OutlinedButton(
                            onPressed: () async {
                              await controller.onTapShareReferralCode();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0XFF0060C6)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_share.svg",
                                        width: 13.33,
                                        height: 13.33,
                                        color: Color(0XFF0060C6),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Bagikan Kode",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(color: Color(0XFF0060C6)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Atau Bisa Menggunakan",
                style: controller.typographyServices.bodySmallRegular.value,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.onTapShareQR();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFFEDEDED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Color(0XFFC6C6C6)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_scan_qr.svg",
                              width: 13.5,
                              height: 13.5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Scan QR Kode Referral Anda",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 16),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_arrow_right.svg",
                              width: 6,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
