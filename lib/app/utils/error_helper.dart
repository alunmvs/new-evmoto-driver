import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_driver/app/widgets/loader_outlined_button_widget.dart';

Future<void> showNoConnectivityInternetDialog({
  required Future Function() onRetry,
}) async {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  var result = await Get.dialog(
    Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tidak Ada Koneksi Internet",
                          style: typographyServices.bodyLargeBold.value
                              .copyWith(
                                color: themeColorServices.textColor.value,
                              ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Get.back();
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_close.svg",
                                  width: 12,
                                  height: 12,
                                  color: themeColorServices.textColor.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Pastikan data atau Wi-Fi aktif agar bisa digunakan kembali.",
                      style: typographyServices.bodySmallRegular.value.copyWith(
                        color: themeColorServices.textColor.value,
                      ),
                    ),
                    SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 304.5 / 125,
                        child: Image.asset(
                          "assets/images/img_no_internet_connectivity.png",
                          width: Get.width,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    LoaderElevatedButton(
                      child: Text(
                        "Pengaturan Jaringan",
                        style: typographyServices.bodySmallBold.value.copyWith(
                          color: themeColorServices.neutralsColorGrey0.value,
                        ),
                      ),
                      onPressed: () async {
                        await AppSettings.openAppSettings(
                          type: AppSettingsType.generalSettings,
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    LoaderOutlinedButton(
                      borderSide: BorderSide(
                        color: themeColorServices.neutralsColorGrey300.value,
                      ),
                      onPressed: () async {
                        Get.back();
                      },
                      child: Text(
                        "Coba Lagi",
                        style: typographyServices.bodySmallBold.value.copyWith(
                          color: Color(0XFFB3B3B3),
                        ),
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

  if (result != true) {
    await onRetry();
  }
}
