import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/modules/my_order/controllers/my_order_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../routes/app_pages.dart';

class MyOrderPendingPaymentSubView extends GetView<MyOrderController> {
  const MyOrderPendingPaymentSubView({super.key});

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
        enablePullUp: controller.isSeeMoreToBePaid.value,
        onRefresh: () async {
          await Future.wait([controller.getToBePaidList()]);
          controller.toBePaidRefreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.wait([controller.seeMoreToBePaidList()]);
          controller.toBePaidRefreshController.loadComplete();
        },
        controller: controller.toBePaidRefreshController,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            .thereIsNoActivityWaitingForPayment ??
                        "-",
                    style: controller.typographyServices.bodySmallRegular.value,
                    textAlign: TextAlign.center,
                  ),
                ],
                for (var toBePaid in controller.toBePaidList) ...[
                  GestureDetector(
                    onTap: () {
                      if ([10, 11, 12].contains(toBePaid.state) == false) {
                        Get.toNamed(
                          Routes.ORDER_DETAIL,
                          arguments: {
                            "order_id": toBePaid.id,
                            "order_type": toBePaid.type,
                          },
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Reservation
                              if (toBePaid.reservation == 1) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9999),
                                    color: Color(0XFF0060C6),
                                  ),
                                  child: Text(
                                    "Reguler",
                                    style: controller
                                        .typographyServices
                                        .captionLargeBold
                                        .value
                                        .copyWith(color: Color(0XFFFFFFFF)),
                                  ),
                                ),
                              ],
                              if (toBePaid.reservation == 2) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9999),
                                    color: Color(0XFFEA7405),
                                  ),
                                  child: Text(
                                    "Booking",
                                    style: controller
                                        .typographyServices
                                        .captionLargeBold
                                        .value
                                        .copyWith(color: Color(0XFFFFFFFF)),
                                  ),
                                ),
                              ],
                              SizedBox(width: 6),
                              // Status
                              if (toBePaid.reservation == 1) ...[
                                if (toBePaid.state == 10) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9999),
                                      border: Border.all(
                                        color: Color(0XFF979797),
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
                                          .captionLargeRegular
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
                                ].contains(toBePaid.state)) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0XFF0060C6),
                                      ),
                                      borderRadius: BorderRadius.circular(9999),
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
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFF0060C6)),
                                    ),
                                  ),
                                ],
                                if ([8, 9].contains(toBePaid.state)) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9999),
                                      border: Border.all(
                                        color: Color(0XFF00731F),
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
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFF00731F)),
                                    ),
                                  ),
                                ],
                              ],
                              if (toBePaid.reservation == 2) ...[
                                if (toBePaid.advanceBookingState == 3) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9999),
                                      border: Border.all(
                                        color: Color(0XFF0060C6),
                                      ),
                                    ),
                                    child: Text(
                                      "Dalam Layanan",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFF0060C6)),
                                    ),
                                  ),
                                ],
                                if (toBePaid.advanceBookingState == 2) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9999),
                                      border: Border.all(
                                        color: Color(0XFFCE6400),
                                      ),
                                    ),
                                    child: Text(
                                      "Sedang Menunggu",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFFCE6400)),
                                    ),
                                  ),
                                ],
                                if (toBePaid.advanceBookingState == 3) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9999),
                                      border: Border.all(
                                        color: Color(0XFF00731F),
                                      ),
                                    ),
                                    child: Text(
                                      "Selesai",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFF00731F)),
                                    ),
                                  ),
                                ],
                                if (toBePaid.advanceBookingState == 5) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9999),
                                      border: Border.all(
                                        color: Color(0XFF979797),
                                      ),
                                    ),
                                    child: Text(
                                      "Dibatalkan",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFF979797)),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                          if (toBePaid.reservation == 2) ...[
                            if (toBePaid.state != 10) ...[
                              SizedBox(height: 8),
                              Text(
                                "Tanggal dan Waktu",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value
                                    .copyWith(color: Color(0XFFB3B3B3)),
                              ),
                              SizedBox(height: 2),
                              Text(
                                DateFormat(
                                  'EEEE, d MMMM yyyy · HH:mm',
                                  controller
                                      .languageServices
                                      .languageCode
                                      .value,
                                ).format(
                                  DateTime.parse(
                                    toBePaid.advanceBookingTravelTime!
                                        .replaceFirst(' ', 'T'),
                                  ),
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
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
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
                          SizedBox(height: 2),
                          Text(
                            toBePaid.endAddress!,
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
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
