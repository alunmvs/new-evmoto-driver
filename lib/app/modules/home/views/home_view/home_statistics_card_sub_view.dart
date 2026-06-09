import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';

import '../../../../routes/app_pages.dart';

class HomeStatisticsCardSubView extends GetView<HomeController> {
  const HomeStatisticsCardSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0XFF0052AA),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          // border: Border.all(
          //   color: Color(0XFFF9F9F9),
          //   width: 4,
          // ),
          boxShadow: [
            BoxShadow(
              color: controller.themeColorServices.overlayDark200.value
                  .withValues(alpha: 0.10),
              blurRadius: 8,
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: controller.themeColorServices.neutralsColorGrey0.value,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.userInfo.value.avatar != null) ...[
                    CircleAvatar(
                      radius: 35 / 2,
                      backgroundImage: CachedNetworkImageProvider(
                        controller.userInfo.value.avatar!,
                      ),
                    ),
                  ],
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.userInfo.value.name ?? "-",
                          style:
                              controller.typographyServices.bodyLargeBold.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${controller.userInfo.value.licensePlate} | ${controller.userInfo.value.brand}",
                          style: controller
                              .typographyServices
                              .captionLargeBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .thirdTextColor
                                    .value,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      // -6.2455851,106.8080113 Accuracy : 17.08 m
                      // -6.2455573,106.8079953 Accuracy : 15.10 m
                      // var startPos = [
                      //   -6.2455851,
                      //   106.8080113,
                      // ];
                      // var endPos = [
                      //   -6.2455519,
                      //   106.8080061,
                      // ];

                      // var distanceInMeters = Geolocator.distanceBetween(
                      //   startPos[0],
                      //   startPos[1],
                      //   endPos[0],
                      //   endPos[1],
                      // );

                      // print(
                      //   "[DEBUG POSITION] $distanceInMeters m",
                      // );
                      await Get.toNamed(Routes.CHAT_LIST);
                      await controller.refreshAll();
                    },
                    child: Badge(
                      isLabelVisible:
                          controller.isSendbirdInit.value == false ||
                          controller.totalUnreadMessageCount.value > 0,
                      label: controller.isSendbirdInit.value == false
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 8,
                            )
                          : Text(
                              controller.totalUnreadMessageCount.value > 99
                                  ? "99+"
                                  : controller.totalUnreadMessageCount.value
                                        .toString(),
                              style: controller
                                  .typographyServices
                                  .captionSmallRegular
                                  .value,
                            ),
                      backgroundColor:
                          controller.themeColorServices.primaryBlue.value,
                      child: SvgPicture.asset(
                        'assets/icons/icon_chat_filled.svg',
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      await Get.toNamed(Routes.NOTIFICATION);
                      await controller.refreshAll();
                    },
                    child: SvgPicture.asset(
                      'assets/icons/icon_notification_filled.svg',
                    ),
                  ),
                  // Text(
                  //   DateFormat(
                  //     'MM/dd\nEEEE',
                  //     controller.languageServices.languageCode.value,
                  //   ).format(
                  //     DateTime.now(),
                  //   ),
                  //   style: controller.typographyServices.bodySmallBold.value.copyWith(
                  //     color:
                  //         controller.themeColorServices.textColor.value,
                  //     fontWeight:
                  //         FontWeight.w600,
                  //   ),
                  //   textAlign:
                  //       TextAlign.right,
                  // ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Color(0XFFF5F5F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: '',
                              decimalDigits: 0,
                            ).format(
                              controller.vehicleStatistics.value.dayNum ?? 0,
                            ),
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .textColor
                                      .value,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .homeOrderToday ??
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
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 19,
                        child: VerticalDivider(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: '',
                              decimalDigits: 0,
                            ).format(
                              controller.vehicleStatistics.value.mouthNum ?? 0,
                            ),
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .textColor
                                      .value,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .homeOrderThisMonth ??
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
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 19,
                        child: VerticalDivider(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            (controller.vehicleStatistics.value.score ?? 0.0)
                                .toStringAsFixed(1),
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .textColor
                                      .value,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .homeMyRating ??
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
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // Center(
                    //   child: SizedBox(
                    //     height: 19,
                    //     child: VerticalDivider(
                    //       color: controller
                    //           .themeColorServices
                    //           .neutralsColorGrey200
                    //           .value,
                    //     ),
                    //   ),
                    // ),
                    // Expanded(
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Get.toNamed(
                    //         Routes.ACTIVITY,
                    //       );
                    //     },
                    //     child: Container(
                    //       color: Colors.transparent,
                    //       child: Column(
                    //         children: [
                    //           Text(
                    //             controller
                    //                 .vehicleStatistics
                    //                 .value
                    //                 .activity
                    //                 .toString(),
                    //             style: controller
                    //                 .typographyServices
                    //                 .bodyLargeBold
                    //                 .value
                    //                 .copyWith(
                    //                   color: controller
                    //                       .themeColorServices
                    //                       .textColor
                    //                       .value,
                    //                   decoration:
                    //                       TextDecoration
                    //                           .underline,
                    //                 ),
                    //             textAlign:
                    //                 TextAlign.center,
                    //           ),
                    //           Text(
                    //             "Aktivitas\nSaya",
                    //             style: controller
                    //                 .typographyServices
                    //                 .captionLargeRegular
                    //                 .value
                    //                 .copyWith(
                    //                   color: controller
                    //                       .themeColorServices
                    //                       .textColor
                    //                       .value,
                    //                 ),
                    //             textAlign:
                    //                 TextAlign.center,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
