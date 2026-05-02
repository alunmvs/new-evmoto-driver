import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/my_order/controllers/my_order_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../routes/app_pages.dart';

class MyOrderCancelledSubView extends GetView<MyOrderController> {
  const MyOrderCancelledSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SmartRefresher(
        header: MaterialClassicHeader(
          color: controller.themeColorServices.primaryBlue.value,
        ),
        footer: ClassicFooter(
          loadStyle: LoadStyle.HideAlways,
          textStyle: controller.typographyServices.bodySmallRegular.value
              .copyWith(color: controller.themeColorServices.primaryBlue.value),
          canLoadingIcon: null,
          loadingIcon: null,
          idleIcon: null,
          noMoreIcon: null,
          failedIcon: null,
        ),
        enablePullDown: true,
        enablePullUp: controller.isSeeMoreCancelOrder.value,
        onRefresh: () async {
          await Future.wait([controller.getCancelOrderList()]);
          controller.cancelOrderRefreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.wait([controller.seeMoreCancelOrderList()]);
          controller.cancelOrderRefreshController.loadComplete();
        },
        controller: controller.cancelOrderRefreshController,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    controller.languageServices.language.value.noActivityYet ??
                        "-",
                    style: controller.typographyServices.bodyLargeBold.value,
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
                    style: controller.typographyServices.bodySmallRegular.value,
                    textAlign: TextAlign.center,
                  ),
                ],
                for (var cancelOrder in controller.cancelOrderList) ...[
                  GestureDetector(
                    onTap: () {
                      if ([10, 11, 12].contains(cancelOrder.state) == false) {
                        Get.toNamed(
                          Routes.ORDER_DETAIL,
                          arguments: {
                            "order_id": cancelOrder.id,
                            "order_type": cancelOrder.type,
                          },
                        );
                      }
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
                        border: Border.all(color: Color(0XFFD3D3D3)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (cancelOrder.state == 10) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFDFDFDF),
                                    borderRadius: BorderRadius.circular(9999),
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
                                        .copyWith(color: Color(0XFF979797)),
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
                              ].contains(cancelOrder.state)) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFD6EAFF),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Text(
                                    "Dalam Layanan",
                                    style: controller
                                        .typographyServices
                                        .captionSmallRegular
                                        .value
                                        .copyWith(color: Color(0XFF0573EA)),
                                  ),
                                ),
                              ],
                              if ([8, 9].contains(cancelOrder.state)) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFD0FFDD),
                                    borderRadius: BorderRadius.circular(9999),
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
                                        .copyWith(color: Color(0XFF34A853)),
                                  ),
                                ),
                              ],
                              // Text(
                              //   NumberFormat.currency(
                              //     locale: 'id_ID',
                              //     symbol: 'Rp ',
                              //     decimalDigits: 0,
                              //   ).format(cancelOrder.totalOrderCost ?? 0),
                              //   style: controller
                              //       .typographyServices
                              //       .captionLargeBold
                              //       .value
                              //       .copyWith(
                              //         color: cancelOrder.state == 10
                              //             ? Color(0XFFB3B3B3)
                              //             : [
                              //                 1,
                              //                 2,
                              //                 3,
                              //                 4,
                              //                 5,
                              //                 6,
                              //                 7,
                              //               ].contains(cancelOrder.state)
                              //             ? Color(0XFF0573EA)
                              //             : Color(0XFF34A853),
                              //       ),
                              // ),
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
                                .copyWith(color: Color(0XFFB3B3B3)),
                          ),
                          Text(
                            cancelOrder.endAddress!,
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: cancelOrder.state == 10
                                      ? Color(0XFFB3B3B3)
                                      : controller
                                            .themeColorServices
                                            .textColor
                                            .value,
                                  fontWeight: FontWeight.w600,
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
    );
  }
}
