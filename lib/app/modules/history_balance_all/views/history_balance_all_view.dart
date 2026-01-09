import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';

import '../controllers/history_balance_all_controller.dart';

class HistoryBalanceAllView extends GetView<HistoryBalanceAllController> {
  const HistoryBalanceAllView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Seluruh Riwayat",
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0XFF0573EA), Color(0XFF034184)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 1],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Saldo Aktif Saya",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_wallet.svg",
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            width: 16,
                            height: 15,
                          ),
                          SizedBox(width: 8),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(
                              controller
                                      .homeController
                                      .userInfo
                                      .value
                                      .balance ??
                                  0.0,
                            ),
                            style: controller
                                .typographyServices
                                .headingMediumBold
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.HISTORY_BALANCE_REVENUE);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      border: Border.all(color: Color(0XFFE8E8E8)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_history_revenue.svg",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Riwayat Pendapatan",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value,
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 19,
                          height: 19,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.HISTORY_BALANCE_WITHDRAW);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      border: Border.all(color: Color(0XFFE8E8E8)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_history_withdraw.svg",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Riwayat Penarikan Dana",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value,
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 19,
                          height: 19,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.HISTORY_BALANCE_RECHARGE);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      border: Border.all(color: Color(0XFFE8E8E8)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_history_recharge.svg",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Riwayat Isi Ulang Saldo",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value,
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 19,
                          height: 19,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
        ),
      ),
    );
  }
}
