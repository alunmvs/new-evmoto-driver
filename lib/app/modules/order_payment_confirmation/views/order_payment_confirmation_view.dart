import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/order_payment_confirmation_controller.dart';

class OrderPaymentConfirmationView
    extends GetView<OrderPaymentConfirmationController> {
  const OrderPaymentConfirmationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Konfirmasi Pembayaran (Cash)",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor: Color(0XFFF7F7F7),
          surfaceTintColor: Color(0XFFF7F7F7),
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: [
                    BoxShadow(
                      color: controller.themeColorServices.overlayDark200.value
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
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                controller.orderPayment.value.orderMoney,
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
                                        controller.orderPayment.value.waitMoney,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          formControlName: 'additional_charge',
                                          keyboardType: TextInputType.number,
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                          textAlign: TextAlign.right,
                                          onChanged: (control) {
                                            print(control.value);
                                          },
                                          inputFormatters: [
                                            CurrencyTextInputFormatter.currency(
                                              locale: 'id_ID',
                                              symbol: '',
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
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
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
                                    formControlName: 'surcharge_description',
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
                                      focusedErrorBorder: InputBorder.none,
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
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          color: Color(0XFFF7F7F7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 46,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.themeColorServices.primaryBlue.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Konfirmasi Pembayaran",
                    style: controller.typographyServices.bodyLargeBold.value
                        .copyWith(color: Colors.white),
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
