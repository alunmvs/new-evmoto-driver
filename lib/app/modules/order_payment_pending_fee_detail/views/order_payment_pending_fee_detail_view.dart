import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/order_payment_pending_fee_detail_controller.dart';

class OrderPaymentPendingFeeDetailView
    extends GetView<OrderPaymentPendingFeeDetailController> {
  const OrderPaymentPendingFeeDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Fee Details",
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          borderRadius: BorderRadius.circular(8),
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
                            SizedBox(height: 16),
                            Text(
                              "Order Amount",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value
                                  .copyWith(),
                            ),
                            SizedBox(height: 16),
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
                                  "Fee Details",
                                  style: controller
                                      .typographyServices
                                      .captionLargeRegular
                                      .value,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                children: [
                                  if (controller.orderDetail.value.startMoney !=
                                          null &&
                                      controller.orderDetail.value.startMoney !=
                                          0) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${controller.languageServices.language.value.startingPrice} (${controller.orderDetail.value.mileage! < controller.orderDetail.value.startMileage! ? controller.orderDetail.value.mileage! : controller.orderDetail.value.startMileage!}) ${controller.languageServices.language.value.km}",
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
                                                .orderDetail
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
                                  ],
                                  if (controller.orderDetail.value.waitMoney !=
                                          null &&
                                      controller.orderDetail.value.waitMoney !=
                                          0) ...[
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${controller.languageServices.language.value.waitFee} (${(controller.orderDetail.value.wait ?? 0.0) + (controller.orderDetail.value.freeWaitTime ?? 0.0)}) ${controller.languageServices.language.value.minute}",
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
                                            SizedBox(height: 4),
                                            Text(
                                              "Bebas biaya tunggu sampai ${controller.orderDetail.value.freeWaitTime ?? 0.0} ${controller.languageServices.language.value.minute}",
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFFB3B3B3),
                                                  ),
                                            ),
                                          ],
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
                                  ],
                                  if (controller
                                              .orderDetail
                                              .value
                                              .mileageMoney !=
                                          null &&
                                      controller
                                              .orderDetail
                                              .value
                                              .mileageMoney !=
                                          0) ...[
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${controller.languageServices.language.value.mileageFee} (${controller.orderDetail.value.mileage}) km",
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
                                                .orderDetail
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
                                  ],
                                  if (controller
                                              .orderDetail
                                              .value
                                              .durationMoney !=
                                          null &&
                                      controller
                                              .orderDetail
                                              .value
                                              .durationMoney !=
                                          0) ...[
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${controller.languageServices.language.value.timeCost} (${controller.orderDetail.value.duration!}) km",
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
                                                .orderDetail
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
                                  ],
                                  if (controller
                                              .orderDetail
                                              .value
                                              .longDistanceMoney !=
                                          null &&
                                      controller
                                              .orderDetail
                                              .value
                                              .longDistanceMoney !=
                                          0) ...[
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${controller.languageServices.language.value.longDistanceFee} (${controller.orderDetail.value.longDistance!}) km",
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
                                                .orderDetail
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
                                  ],
                                  if (controller
                                              .orderDetail
                                              .value
                                              .collectionFees !=
                                          null &&
                                      controller
                                              .orderDetail
                                              .value
                                              .collectionFees !=
                                          0) ...[
                                    SizedBox(height: 12),
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
                                                .orderDetail
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
                                  if (controller
                                              .orderDetail
                                              .value
                                              .additionalCharge !=
                                          null &&
                                      controller
                                              .orderDetail
                                              .value
                                              .additionalCharge !=
                                          0) ...[
                                    SizedBox(height: 12),
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
                                                .orderDetail
                                                .value
                                                .additionalCharge,
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
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
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
