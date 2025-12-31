import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/order_payment_detail_controller.dart';

class OrderPaymentDetailView extends GetView<OrderPaymentDetailController> {
  const OrderPaymentDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.paymentDetails ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: true,
          backgroundColor: Color(0XFFF7F7F7),
          surfaceTintColor: Color(0XFFF7F7F7),
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
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
                footer: ClassicFooter(
                  loadStyle: LoadStyle.HideAlways,
                  textStyle: controller
                      .typographyServices
                      .bodySmallRegular
                      .value
                      .copyWith(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                  canLoadingIcon: null,
                  loadingIcon: null,
                  idleIcon: null,
                  noMoreIcon: null,
                  failedIcon: null,
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
                                controller.orderDetail.value.payManner == 1
                                    ? controller
                                              .languageServices
                                              .language
                                              .value
                                              .onlinePayment ??
                                          "-"
                                    : controller
                                              .languageServices
                                              .language
                                              .value
                                              .cashPayment ??
                                          "-",
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
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(controller.orderDetail.value.payMoney),
                                style: controller
                                    .typographyServices
                                    .headingLargeBold
                                    .value
                                    .copyWith(color: Color(0XFF34A853)),
                                textAlign: TextAlign.center,
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
                                    controller
                                            .languageServices
                                            .language
                                            .value
                                            .expenseDetail ??
                                        "-",
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
                                    controller
                                                    .orderPayment
                                                    .value
                                                    .additionalCharge ==
                                                null ||
                                            controller
                                                    .orderPayment
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
                                                    .orderPayment
                                                    .value
                                                    .additionalCharge ??
                                                0.0,
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
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
