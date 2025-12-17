import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 810,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0XFF0573EA), Color(0XFF034184)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.225],
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(height: 40),
            SizedBox(height: 16),
            CircleAvatar(
              radius: 46 / 2,
              backgroundImage: CachedNetworkImageProvider(
                controller.homeController.userInfo.value.avatar!,
              ),
            ),
            SizedBox(height: 8),
            Text(
              controller.homeController.userInfo.value.name ?? "-",
              style: controller.typographyServices.bodyLargeBold.value.copyWith(
                color: controller.themeColorServices.neutralsColorGrey0.value,
              ),
            ),
            Text(
              "${controller.homeController.userInfo.value.licensePlate} | ${controller.homeController.userInfo.value.brand}",
              style: controller.typographyServices.bodySmallRegular.value
                  .copyWith(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                  ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Saldo Saya",
                            style: controller
                                .typographyServices
                                .captionLargeRegular
                                .value,
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(
                              controller.homeController.userInfo.value.balance,
                            ),
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value,
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      SizedBox(height: 20, child: VerticalDivider(width: 0)),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Orderan",
                            style: controller
                                .typographyServices
                                .captionLargeRegular
                                .value,
                          ),
                          Text(
                            controller
                                .homeController
                                .vehicleStatistics
                                .value
                                .dayNum
                                .toString(),
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value,
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rating Saya",
                            style: controller
                                .typographyServices
                                .captionLargeRegular
                                .value,
                          ),
                          Text(
                            controller
                                .homeController
                                .vehicleStatistics
                                .value
                                .score!
                                .toStringAsFixed(1),
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            border: Border.all(color: Color(0XFFE8E8E8)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.ACCOUNT_MY_EVALUATION);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_account_my_evaluation.svg",
                                              width: 20,
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          "Evaluasi Saya",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      SizedBox(
                                        width: 19,
                                        height: 19,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_arrow_right.svg",
                                              width: 4.75,
                                              height: 9.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(
                                  height: 0,
                                  color: Color(0XFFE8E8E8),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.ACCOUNT_FEEDBACK);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_account_alert.svg",
                                              width: 18.33,
                                              height: 16.1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          "Berikan Masukan",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      SizedBox(
                                        width: 19,
                                        height: 19,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_arrow_right.svg",
                                              width: 4.75,
                                              height: 9.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            border: Border.all(color: Color(0XFFE8E8E8)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_account_document.svg",
                                            width: 16.5,
                                            height: 18.33,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        "Pilih Jenis Layanan",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    SizedBox(
                                      width: 19,
                                      height: 19,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_arrow_right.svg",
                                            width: 4.75,
                                            height: 9.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(
                                  height: 0,
                                  color: Color(0XFFE8E8E8),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_account_switch.svg",
                                            width: 18.33,
                                            height: 18.33,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        "Ubah Kendaraan",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    SizedBox(
                                      width: 19,
                                      height: 19,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_arrow_right.svg",
                                            width: 4.75,
                                            height: 9.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(
                                  height: 0,
                                  color: Color(0XFFE8E8E8),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_account_switch.svg",
                                            width: 18.33,
                                            height: 18.33,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        "Ubah Nomor Telepon",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    SizedBox(
                                      width: 19,
                                      height: 19,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_arrow_right.svg",
                                            width: 4.75,
                                            height: 9.5,
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
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            border: Border.all(color: Color(0XFFE8E8E8)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await controller.onTapShareAppLink();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_account_recommend.svg",
                                              width: 18,
                                              height: 15.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          "Rekomendasi Kepada Teman",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      SizedBox(
                                        width: 19,
                                        height: 19,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_arrow_right.svg",
                                              width: 4.75,
                                              height: 9.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(
                                  height: 0,
                                  color: Color(0XFFE8E8E8),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_account_customer_service.svg",
                                            width: 17.92,
                                            height: 18.75,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        "Hubungi Customer Service",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    SizedBox(
                                      width: 19,
                                      height: 19,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_arrow_right.svg",
                                            width: 4.75,
                                            height: 9.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(
                                  height: 0,
                                  color: Color(0XFFE8E8E8),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_account_setting.svg",
                                            width: 20,
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        "Pengaturan Lainnya",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    SizedBox(
                                      width: 19,
                                      height: 19,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_arrow_right.svg",
                                            width: 4.75,
                                            height: 9.5,
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
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            await controller.onTapLogout();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              border: Border.all(color: Color(0XFFE8E8E8)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_account_logout.svg",
                                              width: 19.02,
                                              height: 18.33,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          "Keluar",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      SizedBox(
                                        width: 19,
                                        height: 19,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_arrow_right.svg",
                                              width: 4.75,
                                              height: 9.5,
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
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey200
                                  .value,
                            ),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            "App Versi v.1.0",
                            style: controller
                                .typographyServices
                                .captionSmallBold
                                .value,
                          ),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
