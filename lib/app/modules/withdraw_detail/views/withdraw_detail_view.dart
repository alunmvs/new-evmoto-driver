import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/widgets/dashed_line.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/withdraw_detail_controller.dart';

class WithdrawDetailView extends GetView<WithdrawDetailController> {
  const WithdrawDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Tarik Dana",
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  if (controller.historyBalanceWithdraw.value.state == 1) ...[
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Color(0XFFD9EBFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0XFF3A99FF),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_hourglass.svg",
                                    width: 22,
                                    height: 22,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: 247,
                        child: Text(
                          "Penarikan Dana Anda Sedang Diproses",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(color: Color(0XFF2C5951)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  if (controller.historyBalanceWithdraw.value.state == 2) ...[
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Color(0XFFCAEDDB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_withdraw_success.svg",
                                  width: 40,
                                  height: 40,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: 247,
                        child: Text(
                          "Selamat!\nPenarikan Dana berhasil",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(color: Color(0XFF2C5951)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  if (controller.historyBalanceWithdraw.value.state == 3) ...[
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Color(0XFFFFD8D5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_withdraw_rejected.svg",
                                  width: 40,
                                  height: 40,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: 247,
                        child: Text(
                          "Penarikan Dana Anda\nGagal Diproses",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(color: Color(0XFF2C5951)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DashedLine(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey200
                          .value,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0XFF777777),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Penarikan Dana",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp',
                                    decimalDigits: 0,
                                  ).format(
                                    controller
                                            .historyBalanceWithdraw
                                            .value
                                            .money ??
                                        0.0,
                                  ),
                                  style: controller
                                      .typographyServices
                                      .headingLargeBold
                                      .value
                                      .copyWith(color: Color(0XFF34A853)),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16 * 2,
                                      child: Divider(
                                        height: 0,
                                        color: Color(0XFFD7D7D7),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Rincian Biaya",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value,
                                    ),
                                    SizedBox(width: 4),
                                    SizedBox(
                                      width: 16 * 2,
                                      child: Divider(
                                        height: 0,
                                        color: Color(0XFFD7D7D7),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Nominal Penarikan",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0XFF7D7D7D),
                                          ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp',
                                        decimalDigits: 0,
                                      ).format(
                                        controller
                                                .historyBalanceWithdraw
                                                .value
                                                .money ??
                                            0.0,
                                      ),
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: controller
                                                .themeColorServices
                                                .textColor
                                                .value,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Biaya Admin",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0XFF7D7D7D),
                                          ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp',
                                        decimalDigits: 0,
                                      ).format(
                                        controller
                                                .historyBalanceWithdraw
                                                .value
                                                .adminFee ??
                                            0.0,
                                      ),
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: controller
                                                .themeColorServices
                                                .textColor
                                                .value,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                ),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp',
                                    decimalDigits: 0,
                                  ).format(
                                    controller
                                            .historyBalanceWithdraw
                                            .value
                                            .money! -
                                        (controller
                                                .historyBalanceWithdraw
                                                .value
                                                .adminFee ??
                                            0.0),
                                  ),
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.historyBalanceWithdraw.value.state == 1) ...[
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0XFFE1E1E1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_alert_circle_grey.svg",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Penarikan dana kamu sedang diproses oleh Admin. Mohon ditunggu!",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (controller.historyBalanceWithdraw.value.state == 3 &&
                      controller.historyBalanceWithdraw.value.remark !=
                          null) ...[
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0XFFE1E1E1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_alert_circle_grey.svg",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                controller
                                        .historyBalanceWithdraw
                                        .value
                                        .remark ??
                                    "-",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
        bottomNavigationBar: controller.isFetch.value
            ? null
            : BottomAppBar(
                height: 78,
                color: Color(0XFFF7F7F7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoaderElevatedButton(
                      onPressed: () async {
                        Get.back();
                      },
                      child: Text(
                        "Kembali",
                        style: controller.typographyServices.bodySmallBold.value
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
