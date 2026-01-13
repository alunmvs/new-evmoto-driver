import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class AccountReferralCodeController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onTapCopyReferralCode() async {
    await Clipboard.setData(
      ClipboardData(text: homeController.userInfo.value.referralCode ?? ""),
    );

    var snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: themeColorServices.sematicColorGreen400.value,
      content: Text(
        "Berhasil menyalin kode referral",
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
    );
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  Future<void> onTapShareReferralCode() async {
    var shareParams = ShareParams(
      text: homeController.userInfo.value.referralCode ?? "",
    );

    await SharePlus.instance.share(shareParams);
  }

  Future<void> onTapShareQR() async {
    await Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: SizedBox(
              width: Get.width,
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Kesempatan Baru Dimulai dari Sini",
                        style: typographyServices.bodyLargeBold.value,
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: themeColorServices.neutralsColorGrey200.value,
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Scan QR dan bantu temanmu bergabung sebagai Driver EVMoto.",
                        style: typographyServices.bodySmallRegular.value,
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0XFFB2B2B2)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: QrImageView(
                          data:
                              homeController.userInfo.value.referralCode ?? "",
                          version: QrVersions.auto,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 46,
                        width: Get.width,
                        child: OutlinedButton(
                          onPressed: () {
                            Get.close(1);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: themeColorServices.primaryBlue.value,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Kembali",
                            style: typographyServices.bodySmallBold.value
                                .copyWith(
                                  color: themeColorServices.primaryBlue.value,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      isScrollControlled: true,
    );
  }
}
