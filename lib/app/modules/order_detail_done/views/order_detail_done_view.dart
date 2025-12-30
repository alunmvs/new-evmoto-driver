import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';

import '../controllers/order_detail_done_controller.dart';

class OrderDetailDoneView extends GetView<OrderDetailDoneController> {
  const OrderDetailDoneView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Perjalanan Selesai",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Aktivitas Perjalanan",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: controller
                                      .themeColorServices
                                      .overlayDark200
                                      .value
                                      .withValues(alpha: 0.10),
                                  blurRadius: 18,
                                  spreadRadius: 0,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 25,
                                      height: 18,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_clock_grey.svg",
                                            width: 18,
                                            height: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      controller.orderDetail.value.travelTime ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_card_origin.svg",
                                      width: 25,
                                      height: 25,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller
                                                    .languageServices
                                                    .language
                                                    .value
                                                    .pickedUp ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color: Color(0XFFB3B3B3),
                                                ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            controller
                                                    .orderDetail
                                                    .value
                                                    .startAddress ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_card_destination.svg",
                                            width: 15,
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller
                                                    .languageServices
                                                    .language
                                                    .value
                                                    .destinationLocation ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color: Color(0XFFB3B3B3),
                                                ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            controller
                                                    .orderDetail
                                                    .value
                                                    .endAddress ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Biaya Perjalanan",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: controller
                                      .themeColorServices
                                      .overlayDark200
                                      .value
                                      .withValues(alpha: 0.10),
                                  blurRadius: 18,
                                  spreadRadius: 0,
                                  offset: Offset(0, 0),
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
                                          .basicExpense ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .collectedByDrivers ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(color: Color(0XFFB3B3B3)),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp ',
                                        decimalDigits: 0,
                                      ).format(
                                        controller
                                            .orderDetail
                                            .value
                                            .collectionFees,
                                      ),
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
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
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .surcharge ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(color: Color(0XFFB3B3B3)),
                                    ),
                                    Text(
                                      controller
                                                      .orderDetail
                                                      .value
                                                      .additionalCharge ==
                                                  null ||
                                              controller
                                                      .orderDetail
                                                      .value
                                                      .additionalCharge ==
                                                  0.0
                                          ? "-"
                                          : NumberFormat.currency(
                                              locale: 'id_ID',
                                              symbol: 'Rp ',
                                              decimalDigits: 0,
                                            ).format(
                                              controller
                                                      .orderDetail
                                                      .value
                                                      .additionalCharge ??
                                                  0.0,
                                            ),
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .textColor
                                                .value,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Divider(height: 0, color: Color(0XFFE5E5E5)),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .totalPayment ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .textColor
                                                .value,
                                          ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp ',
                                        decimalDigits: 0,
                                      ).format(
                                        controller.orderDetail.value.payMoney,
                                      ),
                                      style: controller
                                          .typographyServices
                                          .headingSmallBold
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .sematicColorGreen400
                                                .value,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              controller.themeColorServices.primaryBlue.value,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0XFFB3B3B3)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_bubble_chat_3.svg",
                                    width: 28,
                                    height: 28,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Chat Kami Lebih Lanjut",
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
                                SizedBox(height: 4),
                                Text(
                                  "Membantu kamu dapat setiap keluhan",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
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
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
