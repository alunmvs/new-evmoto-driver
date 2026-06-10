import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_driver/main.dart';

class GuaranteeIncomeAreaInDialog extends StatelessWidget {
  GuaranteeIncomeAreaInDialog({super.key});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
                maxHeight: MediaQuery.of(
                  navigatorKey.currentContext!,
                ).size.height,
              ),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Area Guarantee Income",
                              style: typographyServices.bodyLargeBold.value
                                  .copyWith(fontSize: 18),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Get.close(1);
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: 24,
                              height: 24,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_close.svg",
                                    width: 18,
                                    height: 18,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 304 / 152,
                          child: Image.asset(
                            "assets/images/img_guarantee_income_area_in.png",
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Selamat! Saat ini Anda sedang berada di Area Guarantee Income.",
                        style: typographyServices.bodyLargeRegular.value
                            .copyWith(),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Color(0XFFEFF7FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  "assets/icons/icon_guarantee_income_area_in_1.png",
                                  width: 36,
                                  height: 34,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Jaminan\nPendapatan",
                                style: typographyServices
                                    .captionLargeRegular
                                    .value,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Color(0XFFEFF7FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  "assets/icons/icon_guarantee_income_area_in_2.png",
                                  width: 36,
                                  height: 34,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Online di Jam\nyang Ditentukan",
                                style: typographyServices
                                    .captionLargeRegular
                                    .value,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Color(0XFFEFF7FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  "assets/icons/icon_guarantee_income_area_in_3.png",
                                  width: 36,
                                  height: 34,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Tidak Cancel\n/ Reject Order",
                                style: typographyServices
                                    .captionLargeRegular
                                    .value,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      LoaderElevatedButton(
                        onPressed: () async {
                          Get.close(1);
                        },
                        child: Text(
                          "Lanjutkan",
                          style: typographyServices.bodyLargeBold.value
                              .copyWith(
                                color:
                                    themeColorServices.neutralsColorGrey0.value,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
