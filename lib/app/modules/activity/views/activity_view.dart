import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.myActivities ?? "-",
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
            : DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Container(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      child: TabBar(
                        labelColor:
                            controller.themeColorServices.textColor.value,
                        indicatorColor:
                            controller.themeColorServices.primaryBlue.value,
                        unselectedLabelColor:
                            controller.themeColorServices.textColor.value,
                        dividerColor: controller
                            .themeColorServices
                            .neutralsColorGrey200
                            .value,
                        labelStyle:
                            controller.typographyServices.bodySmallBold.value,
                        unselectedLabelStyle:
                            controller.typographyServices.bodySmallBold.value,
                        isScrollable: true,
                        controller: controller.tabController,
                        tabAlignment: TabAlignment.start,
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        tabs: [
                          Tab(
                            child: Text(
                              controller.languageServices.language.value.all ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                            ),
                          ),
                          Tab(
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .toBePaid ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallBold
                                          .value,
                                    ),
                                    if (controller.toBePaidList.isNotEmpty) ...[
                                      SizedBox(width: 10),
                                    ],
                                  ],
                                ),
                                if (controller.toBePaidList.isNotEmpty) ...[
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .redColor
                                            .value,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 5,
                                        minHeight: 5,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Tab(
                            child: Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .cancelOrder ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          SmartRefresher(
                            header: MaterialClassicHeader(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                            footer: ClassicFooter(
                              loadStyle: LoadStyle.HideAlways,
                              textStyle: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .primaryBlue
                                        .value,
                                  ),
                              canLoadingIcon: null,
                              loadingIcon: null,
                              idleIcon: null,
                              noMoreIcon: null,
                              failedIcon: null,
                            ),
                            enablePullDown: true,
                            enablePullUp: controller.isSeeMoreAllOrder.value,
                            onRefresh: () async {
                              await Future.wait([controller.getAllOrderList()]);
                              controller.allOrderRefreshController
                                  .refreshCompleted();
                            },
                            onLoading: () async {
                              await Future.wait([
                                controller.seeMoreAllOrderList(),
                              ]);
                              controller.allOrderRefreshController
                                  .loadComplete();
                            },
                            controller: controller.allOrderRefreshController,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 16),
                                    if (controller.allOrderList.isEmpty) ...[
                                      SizedBox(height: 16 * 3),
                                      SvgPicture.asset(
                                        "assets/images/img_history_activity_not_found.svg",
                                        height: 80,
                                        width: 80,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .noActivityYet ??
                                            "-",
                                        style: controller
                                            .typographyServices
                                            .bodyLargeBold
                                            .value,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .thereIsNoActivityAllActivities ??
                                            "-",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                    for (var allOrder
                                        in controller.allOrderList) ...[
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            Routes.ORDER_DETAIL,
                                            arguments: {
                                              "order_id": allOrder.id,
                                              "order_type": allOrder.type,
                                            },
                                          );
                                          // Get.toNamed(
                                          //   Routes.ORDER_PAYMENT_CONFIRMATION,
                                          //   arguments: {
                                          //     "order_id": allOrder.id,
                                          //     "order_type": allOrder.type,
                                          //   },
                                          // );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: allOrder.state == 10
                                                ? Color(0XFFEBEBEB)
                                                : controller
                                                      .themeColorServices
                                                      .neutralsColorGrey0
                                                      .value,
                                            border: Border.all(
                                              color: Color(0XFFD3D3D3),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (allOrder.state == 10) ...[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFDFDFDF,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .canceled ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF979797,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                  if ([
                                                    1,
                                                    2,
                                                    3,
                                                    4,
                                                    5,
                                                    6,
                                                    7,
                                                  ].contains(
                                                    allOrder.state,
                                                  )) ...[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFD6EAFF,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .inService ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF0573EA,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                  if ([8, 9].contains(
                                                    allOrder.state,
                                                  )) ...[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFD0FFDD,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .finished ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF34A853,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                  Text(
                                                    "Rp0",
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeBold
                                                        .value
                                                        .copyWith(
                                                          color:
                                                              allOrder.state ==
                                                                  10
                                                              ? Color(
                                                                  0XFFB3B3B3,
                                                                )
                                                              : [
                                                                  1,
                                                                  2,
                                                                  3,
                                                                  4,
                                                                  5,
                                                                  6,
                                                                  7,
                                                                ].contains(
                                                                  allOrder
                                                                      .state,
                                                                )
                                                              ? Color(
                                                                  0XFF0573EA,
                                                                )
                                                              : Color(
                                                                  0XFF34A853,
                                                                ),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .destinationLocation ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .captionLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: Color(0XFFB3B3B3),
                                                    ),
                                              ),
                                              Text(
                                                allOrder.endAddress!,
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value
                                                    .copyWith(
                                                      color:
                                                          allOrder.state == 10
                                                          ? Color(0XFFB3B3B3)
                                                          : controller
                                                                .themeColorServices
                                                                .textColor
                                                                .value,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SmartRefresher(
                            header: MaterialClassicHeader(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                            footer: ClassicFooter(
                              loadStyle: LoadStyle.HideAlways,
                              textStyle: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .primaryBlue
                                        .value,
                                  ),
                              canLoadingIcon: null,
                              loadingIcon: null,
                              idleIcon: null,
                              noMoreIcon: null,
                              failedIcon: null,
                            ),
                            enablePullDown: true,
                            enablePullUp: controller.isSeeMoreToBePaid.value,
                            onRefresh: () async {
                              await Future.wait([controller.getToBePaidList()]);
                              controller.toBePaidRefreshController
                                  .refreshCompleted();
                            },
                            onLoading: () async {
                              await Future.wait([
                                controller.seeMoreToBePaidList(),
                              ]);
                              controller.toBePaidRefreshController
                                  .loadComplete();
                            },
                            controller: controller.toBePaidRefreshController,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 16),
                                    if (controller.toBePaidList.isEmpty) ...[
                                      SizedBox(height: 16 * 3),
                                      SvgPicture.asset(
                                        "assets/images/img_history_activity_not_found.svg",
                                        height: 80,
                                        width: 80,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .noActivityYet ??
                                            "-",
                                        style: controller
                                            .typographyServices
                                            .bodyLargeBold
                                            .value,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .thereIsNoActivityWaitingForPayment ??
                                            "-",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                    for (var toBePaid
                                        in controller.toBePaidList) ...[
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            Routes.ORDER_DETAIL,
                                            arguments: {
                                              "order_id": toBePaid.id,
                                              "order_type": toBePaid.type,
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: toBePaid.state == 10
                                                ? Color(0XFFEBEBEB)
                                                : controller
                                                      .themeColorServices
                                                      .neutralsColorGrey0
                                                      .value,
                                            border: Border.all(
                                              color: Color(0XFFD3D3D3),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (toBePaid.state == 10) ...[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFDFDFDF,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .canceled ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF979797,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                  if ([
                                                    1,
                                                    2,
                                                    3,
                                                    4,
                                                    5,
                                                    6,
                                                    7,
                                                  ].contains(
                                                    toBePaid.state,
                                                  )) ...[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFD6EAFF,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .waitingForPayment ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF0573EA,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                  if ([8, 9].contains(
                                                    toBePaid.state,
                                                  )) ...[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFD0FFDD,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .finished ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF34A853,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                  Text(
                                                    "Rp0",
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeBold
                                                        .value
                                                        .copyWith(
                                                          color:
                                                              toBePaid.state ==
                                                                  10
                                                              ? Color(
                                                                  0XFFB3B3B3,
                                                                )
                                                              : [
                                                                  1,
                                                                  2,
                                                                  3,
                                                                  4,
                                                                  5,
                                                                  6,
                                                                  7,
                                                                ].contains(
                                                                  toBePaid
                                                                      .state,
                                                                )
                                                              ? Color(
                                                                  0XFF0573EA,
                                                                )
                                                              : Color(
                                                                  0XFF34A853,
                                                                ),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .destinationLocation ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .captionLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: Color(0XFFB3B3B3),
                                                    ),
                                              ),
                                              Text(
                                                toBePaid.endAddress!,
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value
                                                    .copyWith(
                                                      color:
                                                          toBePaid.state == 10
                                                          ? Color(0XFFB3B3B3)
                                                          : controller
                                                                .themeColorServices
                                                                .textColor
                                                                .value,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SmartRefresher(
                            header: MaterialClassicHeader(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                            footer: ClassicFooter(
                              loadStyle: LoadStyle.HideAlways,
                              textStyle: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .primaryBlue
                                        .value,
                                  ),
                              canLoadingIcon: null,
                              loadingIcon: null,
                              idleIcon: null,
                              noMoreIcon: null,
                              failedIcon: null,
                            ),
                            enablePullDown: true,
                            enablePullUp: controller.isSeeMoreCancelOrder.value,
                            onRefresh: () async {
                              await Future.wait([
                                controller.getCancelOrderList(),
                              ]);
                              controller.cancelOrderRefreshController
                                  .refreshCompleted();
                            },
                            onLoading: () async {
                              await Future.wait([
                                controller.seeMoreCancelOrderList(),
                              ]);
                              controller.cancelOrderRefreshController
                                  .loadComplete();
                            },
                            controller: controller.cancelOrderRefreshController,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 16),
                                    if (controller.cancelOrderList.isEmpty) ...[
                                      SizedBox(height: 16 * 3),
                                      SvgPicture.asset(
                                        "assets/images/img_history_activity_not_found.svg",
                                        height: 80,
                                        width: 80,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .noActivityYet ??
                                            "-",
                                        style: controller
                                            .typographyServices
                                            .bodyLargeBold
                                            .value,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .thereIsNoActivityCancelled ??
                                            "-",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                    for (var cancelOrder
                                        in controller.cancelOrderList) ...[
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            Routes.ORDER_DETAIL,
                                            arguments: {
                                              "order_id": cancelOrder.id,
                                              "order_type": cancelOrder.type,
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: cancelOrder.state == 10
                                                ? Color(0XFFEBEBEB)
                                                : controller
                                                      .themeColorServices
                                                      .neutralsColorGrey0
                                                      .value,
                                            border: Border.all(
                                              color: Color(0XFFD3D3D3),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (cancelOrder.state ==
                                                      10) ...[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFDFDFDF,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .canceled ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF979797,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                  if ([
                                                    1,
                                                    2,
                                                    3,
                                                    4,
                                                    5,
                                                    6,
                                                    7,
                                                  ].contains(
                                                    cancelOrder.state,
                                                  )) ...[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFD6EAFF,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        "Dalam Layanan",
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF0573EA,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                  if ([8, 9].contains(
                                                    cancelOrder.state,
                                                  )) ...[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFD0FFDD,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .finished ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF34A853,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                  Text(
                                                    "Rp0",
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeBold
                                                        .value
                                                        .copyWith(
                                                          color:
                                                              cancelOrder
                                                                      .state ==
                                                                  10
                                                              ? Color(
                                                                  0XFFB3B3B3,
                                                                )
                                                              : [
                                                                  1,
                                                                  2,
                                                                  3,
                                                                  4,
                                                                  5,
                                                                  6,
                                                                  7,
                                                                ].contains(
                                                                  cancelOrder
                                                                      .state,
                                                                )
                                                              ? Color(
                                                                  0XFF0573EA,
                                                                )
                                                              : Color(
                                                                  0XFF34A853,
                                                                ),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .destinationLocation ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .captionLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: Color(0XFFB3B3B3),
                                                    ),
                                              ),
                                              Text(
                                                cancelOrder.endAddress!,
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value
                                                    .copyWith(
                                                      color:
                                                          cancelOrder.state ==
                                                              10
                                                          ? Color(0XFFB3B3B3)
                                                          : controller
                                                                .themeColorServices
                                                                .textColor
                                                                .value,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
