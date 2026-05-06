import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/order_payment_pending_controller.dart';

class OrderPaymentPendingView extends GetView<OrderPaymentPendingController> {
  const OrderPaymentPendingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.orderDetail.value.state == 7
                ? "Pending Payment"
                : "Completed",
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
                children: [
                  Divider(height: 1, color: Color(0XFFC5C5C5)),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 27,
                              height: 27,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_passenger.svg",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.orderUser.value.name ?? "-",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "(${controller.orderDetail.value.historyNum})",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(height: 0, color: Color(0XFFD7D7D7)),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 27,
                              height: 27,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_clock_grey.svg",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.orderDetail.value.travelTime ?? "-",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value
                                    .copyWith(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(height: 0, color: Color(0XFFD7D7D7)),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 27,
                              height: 27,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_card_origin.svg",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dijemput",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(color: Color(0XFFB3B3B3)),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    controller.orderDetail.value.startAddress ??
                                        "-",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(height: 0, color: Color(0XFFD7D7D7)),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 27,
                              height: 27,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_card_destination.svg",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lokasi Tujuan",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(color: Color(0XFFB3B3B3)),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    controller.orderDetail.value.endAddress ??
                                        "-",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0XFFE1E1E1)),
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        boxShadow: [
                          BoxShadow(
                            color: controller
                                .themeColorServices
                                .overlayDark200
                                .value
                                .withValues(alpha: 0.15),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Pembayaran yang dibayar oleh penumpang",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value,
                          ),
                          SizedBox(height: 4),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(
                              controller.orderDetail.value.orderMoney ?? 0.0,
                            ),
                            style: controller
                                .typographyServices
                                .headingLargeBold
                                .value
                                .copyWith(color: Color(0XFF34A853)),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.ORDER_PAYMENT_PENDING_FEE_DETAIL,
                                arguments: {
                                  "order_id": controller.orderId.value,
                                  "order_type": controller.orderType.value,
                                },
                              );
                            },
                            child: Text(
                              "Lihat detail pembayaran",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: Color(0XFF7D7D7D),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0XFF7D7D7D),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0XFFE1E1E1)),
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        boxShadow: [
                          BoxShadow(
                            color: controller
                                .themeColorServices
                                .overlayDark200
                                .value
                                .withValues(alpha: 0.15),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Yang dibayar oleh penumpang",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value,
                          ),
                          SizedBox(height: 4),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(
                              controller.orderDetail.value.payMoney ?? 0.0,
                            ),
                            style: controller
                                .typographyServices
                                .headingLargeBold
                                .value
                                .copyWith(color: Color(0XFF34A853)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: controller.orderDetail.value.state == 7
            ? BottomAppBar(
                height: 78,
                color: controller.themeColorServices.neutralsColorGrey0.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoaderElevatedButton(
                      onPressed: () async {
                        await controller.onTapCashCollected();
                      },
                      child: Text(
                        "Cash Collected",
                        style: controller.typographyServices.bodySmallBold.value
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
