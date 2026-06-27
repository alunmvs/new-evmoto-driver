import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/modules/my_order/controllers/my_order_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../routes/app_pages.dart';

class MyOrderAllSubView extends GetView<MyOrderController> {
  const MyOrderAllSubView({super.key});

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
        enablePullUp: controller.isSeeMoreAllOrder.value,
        onRefresh: () async {
          await Future.wait([controller.getAllOrderList()]);
          controller.allOrderRefreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.wait([controller.seeMoreAllOrderList()]);
          controller.allOrderRefreshController.loadComplete();
        },
        controller: controller.allOrderRefreshController,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            .thereIsNoActivityAllActivities ??
                        "-",
                    style: controller.typographyServices.bodySmallRegular.value,
                    textAlign: TextAlign.center,
                  ),
                ],
                for (var allOrder in controller.allOrderList) ...[
                  GestureDetector(
                    onTap: () async {
                      if (allOrder.reservation == 1) {
                        if ([10, 11, 12].contains(allOrder.state) == false) {
                          Get.toNamed(
                            Routes.ORDER_DETAIL,
                            arguments: {
                              "order_id": allOrder.id,
                              "order_type": allOrder.type,
                            },
                          );
                          return;
                        }
                      }

                      if (allOrder.reservation == 2) {
                        if ([2].contains(allOrder.state)) {
                          await controller
                              .showDialogAdvancedBookingConfirmation(
                                selectedOrder: allOrder,
                              );
                          return;
                        }
                        if ([3, 4].contains(allOrder.state)) {
                          Get.toNamed(
                            Routes.ORDER_DETAIL,
                            arguments: {
                              "order_id": allOrder.id,
                              "order_type": allOrder.type,
                            },
                          );
                          return;
                        }

                        if ([5].contains(allOrder.state)) {
                          return;
                        }

                        if ([10, 11, 12].contains(allOrder.state) == false) {
                          Get.toNamed(
                            Routes.ORDER_DETAIL,
                            arguments: {
                              "order_id": allOrder.id,
                              "order_type": allOrder.type,
                            },
                          );
                        }
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
                              if (allOrder.reservation == 1) ...[
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
                              if (allOrder.reservation == 2) ...[
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
                              if (allOrder.reservation == 1) ...[
                                if (allOrder.state == 10) ...[
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
                                ].contains(allOrder.state)) ...[
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
                                if ([8, 9].contains(allOrder.state)) ...[
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
                              if (allOrder.reservation == 2) ...[
                                if (allOrder.advanceBookingState == 3) ...[
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
                                if (allOrder.advanceBookingState == 2) ...[
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
                                if (allOrder.advanceBookingState == 4) ...[
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
                                if (allOrder.advanceBookingState == 5) ...[
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
                              // Chat
                              if (allOrder.reservation == 2 &&
                                  [
                                    2,
                                    3,
                                  ].contains(allOrder.advanceBookingState)) ...[
                                Spacer(),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection(
                                        'evmoto_order_chat_participants',
                                      )
                                      .where(
                                        'orderId',
                                        isEqualTo:
                                            allOrder.id?.toString() ?? '',
                                      )
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    int unreadCount = 0;
                                    if (snapshot.hasData &&
                                        snapshot.data!.docs.isNotEmpty) {
                                      final data =
                                          snapshot.data!.docs.first.data()
                                              as Map<String, dynamic>;
                                      unreadCount =
                                          (data['totalUnreadChatDriver']
                                              as int?) ??
                                          0;
                                    }
                                    return Badge(
                                      isLabelVisible: unreadCount > 0,
                                      label: Text(
                                        unreadCount > 99
                                            ? "99+"
                                            : unreadCount.toString(),
                                        style: controller
                                            .typographyServices
                                            .captionSmallRegular
                                            .value,
                                      ),
                                      backgroundColor: controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                      child: SvgPicture.asset(
                                        "assets/icons/icon_chat_filled.svg",
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                          if (allOrder.reservation == 2) ...[
                            if (allOrder.state != 10) ...[
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
                                    allOrder.advanceBookingTravelTime!
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
                                .bodySmallRegular
                                .value
                                .copyWith(color: Color(0XFFB3B3B3)),
                          ),
                          SizedBox(height: 2),
                          Text(
                            allOrder.endAddress!,
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
