import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/order_payment_confirmation_controller.dart';

class OrderPaymentConfirmationView
    extends GetView<OrderPaymentConfirmationController> {
  const OrderPaymentConfirmationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (controller.orderDetail.value.state == 5) {
            Get.back();
          } else {
            Get.offAllNamed(Routes.HOME);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              controller.orderDetail.value.state == 5
                  ? "Konfirmasi Pembayaran (Cash)"
                  : "Menunggu Pembayaran (Cash)",
              style: controller.typographyServices.bodyLargeBold.value,
            ),
            centerTitle: false,
            backgroundColor: controller.orderDetail.value.state != 5
                ? controller.themeColorServices.neutralsColorGrey0.value
                : Color(0XFFF7F7F7),
            surfaceTintColor: controller.orderDetail.value.state != 5
                ? controller.themeColorServices.neutralsColorGrey0.value
                : Color(0XFFF7F7F7),
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.orderDetail.value.state == 5) {
                      Get.back();
                    } else {
                      Get.offAllNamed(Routes.HOME);
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [
                        BoxShadow(
                          color: controller
                              .themeColorServices
                              .overlayDark200
                              .value
                              .withValues(alpha: 0.15),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_arrow_left.svg",
                          width: 22,
                          height: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0XFFF7F7F7),
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
              : SmartRefresher(
                  header: MaterialClassicHeader(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                  enablePullDown: true,
                  onRefresh: () async {
                    await controller.refreshAll();
                    controller.refreshController.refreshCompleted();
                  },
                  controller: controller.refreshController,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.orderDetail.value.state == 5) ...[
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 32,
                              ),
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
                                        .withValues(alpha: 0.1),
                                    blurRadius: 18,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Total Pembayaran",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp ',
                                      decimalDigits: 0,
                                    ).format(
                                      controller
                                              .orderPayment
                                              .value
                                              .orderMoney! +
                                          controller.subcharge.value,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 36,
                                        child: Divider(
                                          height: 0,
                                          color: Color(0XFFD7D7D7),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Basic Expense",
                                        style: controller
                                            .typographyServices
                                            .captionLargeRegular
                                            .value
                                            .copyWith(
                                              color: controller
                                                  .themeColorServices
                                                  .textColor
                                                  .value,
                                            ),
                                      ),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        width: 36,
                                        child: Divider(
                                          height: 0,
                                          color: Color(0XFFD7D7D7),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Starting price (${controller.orderPayment.value.startMileage!.toStringAsPrecision(2)}) km",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .thirdTextColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'id_ID',
                                              symbol: 'Rp ',
                                              decimalDigits: 0,
                                            ).format(
                                              controller
                                                  .orderPayment
                                                  .value
                                                  .startMoney,
                                            ),
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .textColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
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
                                            "Wait fee (${controller.orderPayment.value.wait!.toStringAsPrecision(2)}) minutes",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .thirdTextColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'id_ID',
                                              symbol: 'Rp ',
                                              decimalDigits: 0,
                                            ).format(
                                              controller
                                                  .orderPayment
                                                  .value
                                                  .waitMoney,
                                            ),
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .textColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
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
                                            "Mileage fee (${controller.orderPayment.value.mileage!.toStringAsPrecision(2)}) km",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .thirdTextColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'id_ID',
                                              symbol: 'Rp ',
                                              decimalDigits: 0,
                                            ).format(
                                              controller
                                                  .orderPayment
                                                  .value
                                                  .mileageMoney,
                                            ),
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .textColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
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
                                            "Time cost (${controller.orderPayment.value.duration!.toStringAsPrecision(2)}) km",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .thirdTextColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'id_ID',
                                              symbol: 'Rp ',
                                              decimalDigits: 0,
                                            ).format(
                                              controller
                                                  .orderPayment
                                                  .value
                                                  .durationMoney,
                                            ),
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .textColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
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
                                            "Long distance fee (${controller.orderPayment.value.longDistance!.toStringAsPrecision(2)}) km",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .thirdTextColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'id_ID',
                                              symbol: 'Rp ',
                                              decimalDigits: 0,
                                            ).format(
                                              controller
                                                  .orderPayment
                                                  .value
                                                  .longDistanceMoney,
                                            ),
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .textColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
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
                                            "Collected by drivers",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .thirdTextColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'id_ID',
                                              symbol: 'Rp ',
                                              decimalDigits: 0,
                                            ).format(
                                              controller
                                                  .orderPayment
                                                  .value
                                                  .collectionFees,
                                            ),
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .textColor
                                                      .value,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 36,
                                        child: Divider(
                                          height: 0,
                                          color: Color(0XFFD7D7D7),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Other Fee",
                                        style: controller
                                            .typographyServices
                                            .captionLargeRegular
                                            .value
                                            .copyWith(
                                              color: controller
                                                  .themeColorServices
                                                  .textColor
                                                  .value,
                                            ),
                                      ),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        width: 36,
                                        child: Divider(
                                          height: 0,
                                          color: Color(0XFFD7D7D7),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "You need to charge additional fees for manual entry",
                                    style: controller
                                        .typographyServices
                                        .captionLargeRegular
                                        .value
                                        .copyWith(color: Color(0XFFC5C5C5)),
                                  ),
                                  SizedBox(height: 16),
                                  ReactiveForm(
                                    formGroup: controller.formGroup,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Subcharge",
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .textColor
                                                        .value,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: ReactiveTextField(
                                                formControlName:
                                                    'additional_charge',
                                                keyboardType:
                                                    TextInputType.number,
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value,
                                                textAlign: TextAlign.right,
                                                onChanged: (control) {
                                                  controller.subcharge.value =
                                                      int.tryParse(
                                                        control.value
                                                            .toString()
                                                            .replaceAll(
                                                              "Rp",
                                                              "",
                                                            )
                                                            .replaceAll(
                                                              ".",
                                                              "",
                                                            ),
                                                      ) ??
                                                      0;
                                                },
                                                inputFormatters: [
                                                  CurrencyTextInputFormatter.currency(
                                                    locale: 'id_ID',
                                                    symbol: 'Rp',
                                                    decimalDigits: 0,
                                                  ),
                                                ],
                                                decoration: InputDecoration(
                                                  hintText: 'Please enter...',
                                                  hintStyle: controller
                                                      .typographyServices
                                                      .bodySmallRegular
                                                      .value
                                                      .copyWith(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey500
                                                            .value,
                                                      ),
                                                  border: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  focusedErrorBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Subcharge (Fee Description)",
                                          style: controller
                                              .typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .textColor
                                                    .value,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        ReactiveTextField(
                                          formControlName:
                                              'surcharge_description',
                                          maxLines: 3,
                                          keyboardType: TextInputType.multiline,
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                          decoration: InputDecoration(
                                            hintText: 'Please enter...',
                                            hintStyle: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey500
                                                      .value,
                                                ),
                                            border: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (controller.orderDetail.value.state != 5) ...[
                          Container(
                            padding: EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
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
                                  controller.orderDetail.value.nickName
                                      .toString(),
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: controller
                                            .themeColorServices
                                            .textColor
                                            .value,
                                      ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${controller.orderDetail.value.historyNum} Rides",
                                  style: controller
                                      .typographyServices
                                      .captionLargeRegular
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .imageUploadVerticalDividerColor
                                            .value,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 8),
                                Divider(height: 0, color: Color(0XFFD7D7D7)),
                                SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_clock.svg",
                                      width: 16,
                                      height: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      controller.orderDetail.value.travelTime ??
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
                                  ],
                                ),
                                SizedBox(height: 8),
                                Divider(height: 0, color: Color(0XFFD7D7D7)),
                                SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_location.svg",
                                      width: 18.24,
                                      height: 18.24,
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Dijemput",
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
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Divider(height: 0, color: Color(0XFFD7D7D7)),
                                SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_pin_location.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Lokasi Tujuan",
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 0, color: Color(0XFFD7D7D7)),
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Color(0XFFE1E1E1)),
                                boxShadow: [
                                  BoxShadow(
                                    color: controller
                                        .themeColorServices
                                        .overlayDark100
                                        .value
                                        .withValues(alpha: 0.15),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Pembayaran yang dibayar oleh penumpang",
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
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp ',
                                      decimalDigits: 0,
                                    ).format(
                                      controller.orderPayment.value.orderMoney,
                                    ),
                                    style: controller
                                        .typographyServices
                                        .headingLargeBold
                                        .value
                                        .copyWith(color: Color(0XFF34A853)),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(
                                        Routes.ORDER_PAYMENT_DETAIL,
                                        arguments: {
                                          "order_id": controller.orderId.value,
                                          "order_type":
                                              controller.orderType.value,
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
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Color(0XFF7D7D7D),
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          if (controller.orderDetail.value.state == 7) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0XFF7D7D7D),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_alert_circle.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Konfirmasi dengan penumpang untuk pembayaran",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
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
                            ),
                          ],
                          if (controller.orderDetail.value.state == 8) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Color(0XFFE1E1E1)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: controller
                                          .themeColorServices
                                          .overlayDark100
                                          .value
                                          .withValues(alpha: 0.15),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Yang dibayarkan oleh penumpang",
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
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 4),
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
                                          .headingLargeBold
                                          .value
                                          .copyWith(color: Color(0XFF34A853)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 32),
                        ],
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: controller.isFetch.value
              ? null
              : (controller.orderDetail.value.state != 5 &&
                    controller.orderDetail.value.state != 7)
              ? null
              : BottomAppBar(
                  height: 78,
                  color: Color(0XFFF7F7F7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (controller.orderDetail.value.state == 5) ...[
                        SizedBox(
                          height: 46,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.onTapConfirmPayment();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Konfirmasi Pembayaran",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                      if (controller.orderDetail.value.state == 8 &&
                          controller.orderDetail.value.driverConfirm != 2) ...[
                        SizedBox(
                          height: 46,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.onTapConfirmCashReceived();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Pembayaran Sudah Diterima",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
