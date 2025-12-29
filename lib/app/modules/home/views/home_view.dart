import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/account/views/account_view.dart';
import 'package:new_evmoto_driver/app/modules/home/views/home_view/order_card_home_sub_view.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.selectedIndex.value == 0) ...[
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 140,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/img_background_home.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 40),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 100,
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            decoration: BoxDecoration(
                                              color: Color(0XFF0052AA),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(16),
                                                bottomRight: Radius.circular(
                                                  16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Showcase.withWidget(
                                          disableBarrierInteraction: true,
                                          key: controller
                                              .activityStatisticsGlobalKey,
                                          onTargetClick: () {},
                                          disposeOnTap: false,
                                          targetBorderRadius:
                                              BorderRadius.circular(16),
                                          targetShapeBorder:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                          container: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Transform.rotate(
                                                      angle:
                                                          45 *
                                                          3.1415926535 /
                                                          180,
                                                      child: Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration: BoxDecoration(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey0
                                                              .value,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                topLeft:
                                                                    Radius.circular(
                                                                      4,
                                                                    ),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  SizedBox(height: 8),
                                                  Container(
                                                    padding: EdgeInsets.all(16),
                                                    width: MediaQuery.of(
                                                      context,
                                                    ).size.width,
                                                    decoration: BoxDecoration(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey0
                                                          .value,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "Ringkasan Aktivitas Kamu",
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
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          'Memantau performa kamu setiap hari dalam jumlah pesanan harian, total bulanan, dan rating dari pelanggan.',
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
                                                        SizedBox(height: 16),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "1/8",
                                                              style: controller
                                                                  .typographyServices
                                                                  .captionLargeBold
                                                                  .value
                                                                  .copyWith(
                                                                    color: controller
                                                                        .themeColorServices
                                                                        .neutralsColorGrey500
                                                                        .value,
                                                                  ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                              child: ElevatedButton(
                                                                onPressed: () {
                                                                  ShowcaseView.get()
                                                                      .next();
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      controller
                                                                          .themeColorServices
                                                                          .primaryBlue
                                                                          .value,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  padding:
                                                                      EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16,
                                                                        vertical:
                                                                            0,
                                                                      ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Lanjut",
                                                                    style: controller
                                                                        .typographyServices
                                                                        .bodySmallBold
                                                                        .value
                                                                        .copyWith(
                                                                          color: controller
                                                                              .themeColorServices
                                                                              .neutralsColorGrey0
                                                                              .value,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            decoration: BoxDecoration(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              // border: Border.all(
                                              //   color: Color(0XFFF9F9F9),
                                              //   width: 4,
                                              // ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: controller
                                                      .themeColorServices
                                                      .overlayDark200
                                                      .value
                                                      .withValues(alpha: 0.10),
                                                  blurRadius: 8,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 35 / 2,
                                                        backgroundImage:
                                                            CachedNetworkImageProvider(
                                                              controller
                                                                  .userInfo
                                                                  .value
                                                                  .avatar!,
                                                            ),
                                                      ),
                                                      SizedBox(width: 16),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              controller
                                                                      .userInfo
                                                                      .value
                                                                      .name ??
                                                                  "-",
                                                              style: controller
                                                                  .typographyServices
                                                                  .bodyLargeBold
                                                                  .value,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 16),
                                                      Text(
                                                        DateFormat(
                                                          'MM/dd\nEEEE',
                                                        ).format(
                                                          DateTime.now(),
                                                        ),
                                                        style: controller
                                                            .typographyServices
                                                            .bodySmallBold
                                                            .value
                                                            .copyWith(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .textColor
                                                                  .value,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: 8,
                                                    left: 8,
                                                    right: 8,
                                                    bottom: 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0XFFF5F5F5),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                16,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                16,
                                                              ),
                                                        ),
                                                  ),
                                                  child: IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                NumberFormat.currency(
                                                                  locale:
                                                                      'id_ID',
                                                                  symbol: '',
                                                                  decimalDigits:
                                                                      0,
                                                                ).format(
                                                                  controller
                                                                      .vehicleStatistics
                                                                      .value
                                                                      .dayNum,
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
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              Text(
                                                                "Pesanan Hari Ini",
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
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
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
                                                                  locale:
                                                                      'id_ID',
                                                                  symbol: '',
                                                                  decimalDigits:
                                                                      0,
                                                                ).format(
                                                                  controller
                                                                      .vehicleStatistics
                                                                      .value
                                                                      .mouthNum,
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
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              Text(
                                                                "Pesanan Bulan Ini",
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
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
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
                                                                controller
                                                                    .vehicleStatistics
                                                                    .value
                                                                    .score!
                                                                    .toStringAsFixed(
                                                                      1,
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
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              Text(
                                                                "Rating Saya",
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
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
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
                                        ),
                                        Showcase.withWidget(
                                          disableBarrierInteraction: true,
                                          key: controller
                                              .buttonSeeAllMyActivityGlobalKey,
                                          onTargetClick: () {},
                                          disposeOnTap: false,
                                          targetBorderRadius:
                                              BorderRadius.circular(16),
                                          targetShapeBorder:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                          container: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Transform.rotate(
                                                      angle:
                                                          45 *
                                                          3.1415926535 /
                                                          180,
                                                      child: Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration: BoxDecoration(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey0
                                                              .value,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                topLeft:
                                                                    Radius.circular(
                                                                      4,
                                                                    ),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  SizedBox(height: 8),
                                                  Container(
                                                    padding: EdgeInsets.all(16),
                                                    width: MediaQuery.of(
                                                      context,
                                                    ).size.width,
                                                    decoration: BoxDecoration(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey0
                                                          .value,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "Detail Perjalanan & Pendapatan",
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
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          'Lihat riwayat perjalanan, pendapatan, dan aktivitas kerja kamu secara lengkap di sini.',
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
                                                        SizedBox(height: 16),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "2/8",
                                                              style: controller
                                                                  .typographyServices
                                                                  .captionLargeBold
                                                                  .value
                                                                  .copyWith(
                                                                    color: controller
                                                                        .themeColorServices
                                                                        .neutralsColorGrey500
                                                                        .value,
                                                                  ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                              child: ElevatedButton(
                                                                onPressed: () {
                                                                  ShowcaseView.get()
                                                                      .next();
                                                                  Future.delayed(
                                                                    Duration(
                                                                      milliseconds:
                                                                          500,
                                                                    ),
                                                                  ).whenComplete(() {
                                                                    controller
                                                                            .coachmarkWorkStatus
                                                                            .value =
                                                                        1;
                                                                  });
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      controller
                                                                          .themeColorServices
                                                                          .primaryBlue
                                                                          .value,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  padding:
                                                                      EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16,
                                                                        vertical:
                                                                            0,
                                                                      ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Lanjut",
                                                                    style: controller
                                                                        .typographyServices
                                                                        .bodySmallBold
                                                                        .value
                                                                        .copyWith(
                                                                          color: controller
                                                                              .themeColorServices
                                                                              .neutralsColorGrey0
                                                                              .value,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed(Routes.ACTIVITY);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              width: MediaQuery.of(
                                                context,
                                              ).size.width,
                                              decoration: BoxDecoration(
                                                color: Color(0XFF0052AA),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                    16,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    16,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Lihat Aktivitas Saya",
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallBold
                                                        .value
                                                        .copyWith(
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
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
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
                                            .withValues(alpha: 0.10),
                                        blurRadius: 8,
                                        spreadRadius: 0,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Showcase.withWidget(
                                        targetPadding: EdgeInsets.only(
                                          top: 16,
                                          right: 16,
                                          left: 16,
                                          bottom: 16,
                                        ),
                                        disableBarrierInteraction: true,
                                        key: controller.balanceGlobalKey,
                                        onTargetClick: () {},
                                        disposeOnTap: false,
                                        targetBorderRadius:
                                            BorderRadius.circular(16),
                                        targetShapeBorder:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                        container: Stack(
                                          children: [
                                            Positioned(
                                              left: 16 * 5,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Transform.rotate(
                                                    angle:
                                                        45 * 3.1415926535 / 180,
                                                    child: Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey0
                                                            .value,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(height: 8),
                                                Container(
                                                  padding: EdgeInsets.all(16),
                                                  width: MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey0
                                                        .value,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "Saldo Akun Kamu",
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
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        'Menampilkan saldo yang tercatat dari aktivitas berkendara dan transaksi yang sedang berjalan di EVMoto Driver.',
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
                                                      SizedBox(height: 16),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "4/8",
                                                            style: controller
                                                                .typographyServices
                                                                .captionLargeBold
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .neutralsColorGrey500
                                                                      .value,
                                                                ),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                ShowcaseView.get()
                                                                    .next();
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    controller
                                                                        .themeColorServices
                                                                        .primaryBlue
                                                                        .value,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                ),
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          0,
                                                                    ),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "Lanjut",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodySmallBold
                                                                      .value
                                                                      .copyWith(
                                                                        color: controller
                                                                            .themeColorServices
                                                                            .neutralsColorGrey0
                                                                            .value,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .themeColorServices
                                                    .sematicColorBlue100
                                                    .value,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_wallet.svg",
                                                    width: 16,
                                                    height: 16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Saldo Kamu",
                                                  style: controller
                                                      .typographyServices
                                                      .captionSmallRegular
                                                      .value
                                                      .copyWith(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey500
                                                            .value,
                                                      ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  NumberFormat.currency(
                                                    locale: 'id_ID',
                                                    symbol: 'Rp ',
                                                    decimalDigits: 0,
                                                  ).format(
                                                    controller
                                                        .userInfo
                                                        .value
                                                        .balance,
                                                  ),
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallBold
                                                      .value
                                                      .copyWith(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey800
                                                            .value,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Showcase.withWidget(
                                            targetPadding: EdgeInsets.only(
                                              top: 16,
                                              right: 16,
                                              left: 16,
                                              bottom: 16,
                                            ),
                                            disableBarrierInteraction: true,
                                            key: controller.topUpGlobalKey,
                                            onTargetClick: () {},
                                            disposeOnTap: false,
                                            targetBorderRadius:
                                                BorderRadius.circular(16),
                                            targetShapeBorder:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                            container: Stack(
                                              children: [
                                                Positioned(
                                                  right: 16 * 10.25,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Transform.rotate(
                                                        angle:
                                                            45 *
                                                            3.1415926535 /
                                                            180,
                                                        child: Container(
                                                          width: 16,
                                                          height: 16,
                                                          decoration: BoxDecoration(
                                                            color: controller
                                                                .themeColorServices
                                                                .neutralsColorGrey0
                                                                .value,
                                                            borderRadius:
                                                                BorderRadius.only(
                                                                  topLeft:
                                                                      Radius.circular(
                                                                        4,
                                                                      ),
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    SizedBox(height: 8),
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                        16,
                                                      ),
                                                      width: MediaQuery.of(
                                                        context,
                                                      ).size.width,
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey0
                                                            .value,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "Isi Ulang Saldo",
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
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            'Gunakan fitur ini untuk menambahkan saldo sesuai kebutuhan penggunaan akun di aplikasi EVMoto Driver.',
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
                                                          SizedBox(height: 16),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "5/8",
                                                                style: controller
                                                                    .typographyServices
                                                                    .captionLargeBold
                                                                    .value
                                                                    .copyWith(
                                                                      color: controller
                                                                          .themeColorServices
                                                                          .neutralsColorGrey500
                                                                          .value,
                                                                    ),
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                                child: ElevatedButton(
                                                                  onPressed: () {
                                                                    ShowcaseView.get()
                                                                        .next();
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: controller
                                                                        .themeColorServices
                                                                        .primaryBlue
                                                                        .value,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          0,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Lanjut",
                                                                      style: controller
                                                                          .typographyServices
                                                                          .bodySmallBold
                                                                          .value
                                                                          .copyWith(
                                                                            color:
                                                                                controller.themeColorServices.neutralsColorGrey0.value,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () async {
                                                await Get.toNamed(
                                                  Routes.DEPOSIT_BALANCE,
                                                );

                                                await controller.refreshAll();
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/icon_add_circle.svg",
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      "Isi Ulang",
                                                      style: controller
                                                          .typographyServices
                                                          .captionLargeRegular
                                                          .value,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 14),
                                          Showcase.withWidget(
                                            targetPadding: EdgeInsets.only(
                                              top: 16,
                                              right: 16,
                                              left: 16,
                                              bottom: 16,
                                            ),
                                            disableBarrierInteraction: true,
                                            key: controller.withdrawGlobalKey,
                                            onTargetClick: () {},
                                            disposeOnTap: false,
                                            targetBorderRadius:
                                                BorderRadius.circular(16),
                                            targetShapeBorder:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                            container: Stack(
                                              children: [
                                                Positioned(
                                                  right: 16 * 6,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Transform.rotate(
                                                        angle:
                                                            45 *
                                                            3.1415926535 /
                                                            180,
                                                        child: Container(
                                                          width: 16,
                                                          height: 16,
                                                          decoration: BoxDecoration(
                                                            color: controller
                                                                .themeColorServices
                                                                .neutralsColorGrey0
                                                                .value,
                                                            borderRadius:
                                                                BorderRadius.only(
                                                                  topLeft:
                                                                      Radius.circular(
                                                                        4,
                                                                      ),
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    SizedBox(height: 8),
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                        16,
                                                      ),
                                                      width: MediaQuery.of(
                                                        context,
                                                      ).size.width,
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey0
                                                            .value,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "Tarik Dana",
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
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            'Ajukan penarikan saldo yang tersedia ke metode penarikan yang telah terdaftar di akun kamu.',
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
                                                          SizedBox(height: 16),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "6/8",
                                                                style: controller
                                                                    .typographyServices
                                                                    .captionLargeBold
                                                                    .value
                                                                    .copyWith(
                                                                      color: controller
                                                                          .themeColorServices
                                                                          .neutralsColorGrey500
                                                                          .value,
                                                                    ),
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                                child: ElevatedButton(
                                                                  onPressed: () {
                                                                    ShowcaseView.get()
                                                                        .next();
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: controller
                                                                        .themeColorServices
                                                                        .primaryBlue
                                                                        .value,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          0,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Lanjut",
                                                                      style: controller
                                                                          .typographyServices
                                                                          .bodySmallBold
                                                                          .value
                                                                          .copyWith(
                                                                            color:
                                                                                controller.themeColorServices.neutralsColorGrey0.value,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () async {
                                                await Get.toNamed(
                                                  Routes.WITHDRAW,
                                                );

                                                await controller.refreshAll();
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/icon_withdraw.svg",
                                                      width: 19,
                                                      height: 19,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      "Tarik Dana",
                                                      style: controller
                                                          .typographyServices
                                                          .captionLargeRegular
                                                          .value,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 14),
                                          Showcase.withWidget(
                                            targetPadding: EdgeInsets.only(
                                              top: 16,
                                              right: 16,
                                              left: 16,
                                              bottom: 16,
                                            ),
                                            disableBarrierInteraction: true,
                                            key: controller.historyGlobalKey,
                                            onTargetClick: () {},
                                            disposeOnTap: false,
                                            targetBorderRadius:
                                                BorderRadius.circular(16),
                                            targetShapeBorder:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                            container: Stack(
                                              children: [
                                                Positioned(
                                                  right: 16 * 2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Transform.rotate(
                                                        angle:
                                                            45 *
                                                            3.1415926535 /
                                                            180,
                                                        child: Container(
                                                          width: 16,
                                                          height: 16,
                                                          decoration: BoxDecoration(
                                                            color: controller
                                                                .themeColorServices
                                                                .neutralsColorGrey0
                                                                .value,
                                                            borderRadius:
                                                                BorderRadius.only(
                                                                  topLeft:
                                                                      Radius.circular(
                                                                        4,
                                                                      ),
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    SizedBox(height: 8),
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                        16,
                                                      ),
                                                      width: MediaQuery.of(
                                                        context,
                                                      ).size.width,
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey0
                                                            .value,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "Riwayat Transaksi",
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
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            'Lihat catatan transaksi saldo, termasuk isi ulang dan penarikan, yang tercatat di akun EVMoto Driver.',
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
                                                          SizedBox(height: 16),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "7/8",
                                                                style: controller
                                                                    .typographyServices
                                                                    .captionLargeBold
                                                                    .value
                                                                    .copyWith(
                                                                      color: controller
                                                                          .themeColorServices
                                                                          .neutralsColorGrey500
                                                                          .value,
                                                                    ),
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                                child: ElevatedButton(
                                                                  onPressed: () {
                                                                    ShowcaseView.get()
                                                                        .next();
                                                                    controller
                                                                            .selectedIndex
                                                                            .value =
                                                                        1;
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: controller
                                                                        .themeColorServices
                                                                        .primaryBlue
                                                                        .value,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          0,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Lanjut",
                                                                      style: controller
                                                                          .typographyServices
                                                                          .bodySmallBold
                                                                          .value
                                                                          .copyWith(
                                                                            color:
                                                                                controller.themeColorServices.neutralsColorGrey0.value,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                  Routes.HISTORY_BALANCE_ALL,
                                                );
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/icon_others.svg",
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      "Riwayat",
                                                      style: controller
                                                          .typographyServices
                                                          .captionLargeRegular
                                                          .value,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: DefaultTabController(
                                  length: 3,
                                  child: Column(
                                    children: [
                                      TabBar(
                                        labelColor: controller
                                            .themeColorServices
                                            .textColor
                                            .value,
                                        indicatorColor: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                        unselectedLabelColor: controller
                                            .themeColorServices
                                            .textColor
                                            .value,
                                        dividerColor: controller
                                            .themeColorServices
                                            .neutralsColorGrey200
                                            .value,
                                        labelStyle: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                        unselectedLabelStyle: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                        isScrollable: true,
                                        controller: controller.tabController,
                                        tabAlignment: TabAlignment.start,
                                        overlayColor: WidgetStateProperty.all(
                                          Colors.transparent,
                                        ),
                                        onTap: (value) async {
                                          switch (value) {
                                            case 0:
                                              await Future.wait([
                                                controller.getUserInfoDetail(),
                                                controller
                                                    .getVehicleStatistics(),
                                                controller
                                                    .getOrderGrabbingHallList(),
                                              ]);

                                              controller.workStatus.value =
                                                  controller
                                                      .vehicleStatistics
                                                      .value
                                                      .work ??
                                                  2;
                                              break;
                                            case 1:
                                              await Future.wait([
                                                controller.getUserInfoDetail(),
                                                controller
                                                    .getVehicleStatistics(),

                                                controller
                                                    .getOrderInServiceList(),
                                              ]);

                                              controller.workStatus.value =
                                                  controller
                                                      .vehicleStatistics
                                                      .value
                                                      .work ??
                                                  2;
                                              break;
                                            case 2:
                                              await Future.wait([
                                                controller.getUserInfoDetail(),
                                                controller
                                                    .getVehicleStatistics(),
                                                controller
                                                    .getOrderToBeServedList(),
                                              ]);

                                              controller.workStatus.value =
                                                  controller
                                                      .vehicleStatistics
                                                      .value
                                                      .work ??
                                                  2;
                                              break;
                                            default:
                                              break;
                                          }
                                        },
                                        tabs: [
                                          Tab(
                                            child: Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Menerima Pesanan',
                                                      style: controller
                                                          .typographyServices
                                                          .bodySmallBold
                                                          .value,
                                                    ),
                                                    if (controller
                                                        .orderGrabbingHallList
                                                        .isNotEmpty) ...[
                                                      SizedBox(width: 10),
                                                    ],
                                                  ],
                                                ),
                                                if (controller
                                                    .orderGrabbingHallList
                                                    .isNotEmpty) ...[
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                            .themeColorServices
                                                            .redColor
                                                            .value,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
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
                                            child: Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Dalam Layanan',
                                                      style: controller
                                                          .typographyServices
                                                          .bodySmallBold
                                                          .value,
                                                    ),
                                                    if (controller
                                                        .orderInServiceList
                                                        .isNotEmpty) ...[
                                                      SizedBox(width: 10),
                                                    ],
                                                  ],
                                                ),
                                                if (controller
                                                    .orderInServiceList
                                                    .isNotEmpty) ...[
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                            .themeColorServices
                                                            .redColor
                                                            .value,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
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
                                            child: Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Menunggu',
                                                      style: controller
                                                          .typographyServices
                                                          .bodySmallBold
                                                          .value,
                                                    ),
                                                    if (controller
                                                        .orderToBeServedList
                                                        .isNotEmpty) ...[
                                                      SizedBox(width: 10),
                                                    ],
                                                  ],
                                                ),
                                                if (controller
                                                    .orderToBeServedList
                                                    .isNotEmpty) ...[
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                            .themeColorServices
                                                            .redColor
                                                            .value,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
                                                            minWidth: 5,
                                                            minHeight: 5,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ],
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
                                              enablePullUp: controller
                                                  .isSeeMoreOrderGrabbingHall
                                                  .value,
                                              onRefresh: () async {
                                                await Future.wait([
                                                  controller
                                                      .getUserInfoDetail(),
                                                  controller
                                                      .getVehicleStatistics(),
                                                  controller
                                                      .getOrderGrabbingHallList(),
                                                ]);
                                                controller
                                                    .orderGrabbingHallRefreshController
                                                    .refreshCompleted();
                                              },
                                              onLoading: () async {
                                                await Future.wait([
                                                  controller
                                                      .seeMoreOrderGrabbingHallList(),
                                                ]);
                                                controller
                                                    .orderGrabbingHallRefreshController
                                                    .loadComplete();
                                              },
                                              controller: controller
                                                  .orderGrabbingHallRefreshController,
                                              child: SingleChildScrollView(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                      ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 16),
                                                      if (controller
                                                          .orderGrabbingHallList
                                                          .isEmpty) ...[
                                                        SizedBox(
                                                          height: 16 * 3,
                                                        ),
                                                        SvgPicture.asset(
                                                          "assets/images/img_history_activity_not_found.svg",
                                                          height: 80,
                                                          width: 80,
                                                        ),
                                                        SizedBox(height: 16),
                                                        Text(
                                                          "Belum Ada Pesanan",
                                                          style: controller
                                                              .typographyServices
                                                              .bodyLargeBold
                                                              .value,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          "Tidak ada pesanan pada bagian Menerima Pesanan",
                                                          style: controller
                                                              .typographyServices
                                                              .bodySmallRegular
                                                              .value,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                      for (var orderGrabbingHall
                                                          in controller
                                                              .orderGrabbingHallList) ...[
                                                        OrderCardHomeSubView(
                                                          order:
                                                              orderGrabbingHall,
                                                        ),
                                                        SizedBox(height: 16),
                                                      ],
                                                      SizedBox(height: 16),
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
                                              enablePullUp: controller
                                                  .isSeeMoreOrderInService
                                                  .value,
                                              onRefresh: () async {
                                                await Future.wait([
                                                  controller
                                                      .getUserInfoDetail(),
                                                  controller
                                                      .getVehicleStatistics(),
                                                  controller
                                                      .getOrderInServiceList(),
                                                ]);
                                                controller
                                                    .orderInServiceRefreshController
                                                    .refreshCompleted();
                                              },
                                              onLoading: () async {
                                                await Future.wait([
                                                  controller
                                                      .seeMoreOrderInServiceList(),
                                                ]);
                                                controller
                                                    .orderInServiceRefreshController
                                                    .loadComplete();
                                              },
                                              controller: controller
                                                  .orderInServiceRefreshController,
                                              child: SingleChildScrollView(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                      ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 16),
                                                      if (controller
                                                          .orderInServiceList
                                                          .isEmpty) ...[
                                                        SizedBox(
                                                          height: 16 * 3,
                                                        ),
                                                        SvgPicture.asset(
                                                          "assets/images/img_history_activity_not_found.svg",
                                                          height: 80,
                                                          width: 80,
                                                        ),
                                                        SizedBox(height: 16),
                                                        Text(
                                                          "Belum Ada Pesanan",
                                                          style: controller
                                                              .typographyServices
                                                              .bodyLargeBold
                                                              .value,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          "Tidak ada pesanan pada bagian Dalam Layanan",
                                                          style: controller
                                                              .typographyServices
                                                              .bodySmallRegular
                                                              .value,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                      for (var orderInService
                                                          in controller
                                                              .orderInServiceList) ...[
                                                        OrderCardHomeSubView(
                                                          order: orderInService,
                                                        ),
                                                        SizedBox(height: 16),
                                                      ],
                                                      SizedBox(height: 16),
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
                                              enablePullUp: controller
                                                  .isSeeMoreOrderToBeServed
                                                  .value,
                                              onRefresh: () async {
                                                await Future.wait([
                                                  controller
                                                      .getUserInfoDetail(),
                                                  controller
                                                      .getVehicleStatistics(),
                                                  controller
                                                      .getOrderToBeServedList(),
                                                ]);
                                                controller
                                                    .orderToBeServedRefreshController
                                                    .refreshCompleted();
                                              },
                                              onLoading: () async {
                                                await Future.wait([
                                                  controller
                                                      .seeMoreOrderToBeServedList(),
                                                ]);
                                                controller
                                                    .orderToBeServedRefreshController
                                                    .loadComplete();
                                              },
                                              controller: controller
                                                  .orderToBeServedRefreshController,
                                              child: SingleChildScrollView(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                      ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 16),
                                                      if (controller
                                                          .orderToBeServedList
                                                          .isEmpty) ...[
                                                        SizedBox(
                                                          height: 16 * 3,
                                                        ),
                                                        SvgPicture.asset(
                                                          "assets/images/img_history_activity_not_found.svg",
                                                          height: 80,
                                                          width: 80,
                                                        ),
                                                        SizedBox(height: 16),
                                                        Text(
                                                          "Belum Ada Pesanan",
                                                          style: controller
                                                              .typographyServices
                                                              .bodyLargeBold
                                                              .value,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          "Tidak ada pesanan pada bagian Menunggu",
                                                          style: controller
                                                              .typographyServices
                                                              .bodySmallRegular
                                                              .value,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                      for (var orderToBeServed
                                                          in controller
                                                              .orderToBeServedList) ...[
                                                        OrderCardHomeSubView(
                                                          order:
                                                              orderToBeServed,
                                                        ),
                                                        SizedBox(height: 16),
                                                      ],
                                                      SizedBox(height: 16),
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (controller.selectedIndex.value == 1) ...[
                    Expanded(child: AccountView()),
                  ],
                ],
              ),
        bottomNavigationBar: controller.isFetch.value
            ? null
            : BottomAppBar(
                color: controller.themeColorServices.neutralsColorGrey0.value,
                height: 80 + 20,
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Divider(height: 0, color: Color(0XFFE1E1E1)),
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          isScrollControlled: true,
                          Obx(
                            () => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16),
                                  ),
                                  child: Material(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Status",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeBold
                                                    .value,
                                              ),
                                              SizedBox(width: 5),
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/icon_arrow_down.svg",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey200
                                              .value,
                                        ),
                                        Padding(
                                          padding: EdgeInsetsGeometry.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Status Saat Ini",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallBold
                                                    .value,
                                              ),
                                              AnimatedToggleSwitch<int>.dual(
                                                current:
                                                    controller.workStatus.value,
                                                first: 2,
                                                second: 1,
                                                height: 50,
                                                borderWidth: 0,
                                                customIconBuilder:
                                                    (context, local, global) {
                                                      if (local.value == 2) {
                                                        return CircleAvatar(
                                                          backgroundColor:
                                                              Color(0XFF999898),
                                                          child: SvgPicture.asset(
                                                            "assets/icons/icon_scooter.svg",
                                                            width: 28.57,
                                                            height: 28.57,
                                                            color: Color(
                                                              0XFF696969,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      return CircleAvatar(
                                                        backgroundColor: Color(
                                                          0XFF37C086,
                                                        ),
                                                        child: SvgPicture.asset(
                                                          "assets/icons/icon_scooter.svg",
                                                          width: 28.57,
                                                          height: 28.57,
                                                          color: Color(
                                                            0XFFFFFFFF,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                customStyleBuilder:
                                                    (context, local, global) {
                                                      if (local.value == 2) {
                                                        return ToggleStyle(
                                                          backgroundColor:
                                                              Color(0XFFCECECE),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                9999,
                                                              ),
                                                          indicatorColor: Colors
                                                              .transparent,
                                                        );
                                                      }
                                                      return ToggleStyle(
                                                        backgroundColor: Color(
                                                          0XFF1FF79B,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9999,
                                                            ),
                                                        indicatorColor:
                                                            Colors.transparent,
                                                      );
                                                    },
                                                onChanged: (value) async {
                                                  controller
                                                      .onSwitchStatusWork();
                                                },
                                                customTextBuilder:
                                                    (context, local, global) {
                                                      return Text(
                                                        local.value == 2
                                                            ? "Offline"
                                                            : "Online",
                                                        style: controller
                                                            .typographyServices
                                                            .bodyLargeBold
                                                            .value
                                                            .copyWith(
                                                              color:
                                                                  local.value ==
                                                                      2
                                                                  ? Color(
                                                                      0XFF747474,
                                                                    )
                                                                  : Color(
                                                                      0XFF07824D,
                                                                    ),
                                                            ),
                                                      );
                                                    },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey200
                                              .value,
                                        ),
                                        Padding(
                                          padding: EdgeInsetsGeometry.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Total Pesanan Kamu",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallBold
                                                    .value,
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFE7F3FF,
                                                        ),

                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Pesanan Hari Ini",
                                                            style: controller
                                                                .typographyServices
                                                                .bodySmallRegular
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .primaryBlue
                                                                      .value,
                                                                ),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            "${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(controller.vehicleStatistics.value.dayNum)} Pesanan",
                                                            style: controller
                                                                .typographyServices
                                                                .bodyLargeBold
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .primaryBlue
                                                                      .value,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFE7F3FF,
                                                        ),

                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Pesanan Bulan Ini",
                                                            style: controller
                                                                .typographyServices
                                                                .bodySmallRegular
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .primaryBlue
                                                                      .value,
                                                                ),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            "${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(controller.vehicleStatistics.value.mouthNum)} Pesanan",
                                                            style: controller
                                                                .typographyServices
                                                                .bodyLargeBold
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .primaryBlue
                                                                      .value,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey200
                                              .value,
                                        ),
                                        Padding(
                                          padding: EdgeInsetsGeometry.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Pilih Layanan Kamu",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallBold
                                                    .value,
                                              ),
                                              SizedBox(height: 8),
                                              for (var updatedServiceOrder
                                                  in controller
                                                      .serviceOrderList) ...[
                                                GestureDetector(
                                                  onTap: () {
                                                    if (updatedServiceOrder
                                                            .updatedState ==
                                                        2) {
                                                      updatedServiceOrder
                                                              .updatedState =
                                                          1;
                                                    } else {
                                                      updatedServiceOrder
                                                              .updatedState =
                                                          2;
                                                    }
                                                    controller.serviceOrderList
                                                        .refresh();
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey0
                                                          .value,
                                                      border: Border.all(
                                                        color:
                                                            updatedServiceOrder
                                                                    .updatedState ==
                                                                2
                                                            ? Color(0XFFB3B3B3)
                                                            : Color(0XFFE8E8E8),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 16),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              updatedServiceOrder
                                                                      .name ??
                                                                  "-",
                                                              style: controller
                                                                  .typographyServices
                                                                  .bodySmallRegular
                                                                  .value
                                                                  .copyWith(
                                                                    color:
                                                                        updatedServiceOrder.updatedState ==
                                                                            2
                                                                        ? controller
                                                                              .themeColorServices
                                                                              .textColor
                                                                              .value
                                                                        : Color(
                                                                            0XFFB3B3B3,
                                                                          ),
                                                                  ),
                                                            ),
                                                            SizedBox(
                                                              width: 25,
                                                              height: 25,
                                                              child: Checkbox(
                                                                value:
                                                                    updatedServiceOrder
                                                                        .updatedState ==
                                                                    2,
                                                                activeColor: controller
                                                                    .themeColorServices
                                                                    .primaryBlue
                                                                    .value,
                                                                side: BorderSide(
                                                                  color: Color(
                                                                    0XFFB3B3B3,
                                                                  ),
                                                                ),
                                                                onChanged: (value) {
                                                                  if (value ==
                                                                      false) {
                                                                    updatedServiceOrder
                                                                            .updatedState =
                                                                        1;
                                                                  } else {
                                                                    updatedServiceOrder
                                                                            .updatedState =
                                                                        2;
                                                                  }
                                                                  controller
                                                                      .serviceOrderList
                                                                      .refresh();
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 16),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: SizedBox(
                                            height: 46,
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                await controller
                                                    .onTapSaveServiceOrder();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                              child: Text(
                                                "Simpan",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallBold
                                                    .value
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_arrow_up.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedIndex.value = 0;
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            controller.selectedIndex.value == 0
                                                ? "assets/icons/icon_home_selected.svg"
                                                : "assets/icons/icon_home.svg",
                                            width: 22,
                                            height: 22,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Beranda",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color:
                                                controller
                                                        .selectedIndex
                                                        .value ==
                                                    0
                                                ? controller
                                                      .themeColorServices
                                                      .textColor
                                                      .value
                                                : Color(0XFFB3B3B3),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Showcase.withWidget(
                                  targetPadding: EdgeInsets.only(
                                    top: 16 * 2,
                                    right: 16,
                                    left: 16,
                                    bottom: 16,
                                  ),
                                  disableBarrierInteraction: true,
                                  key: controller.buttonOfflineOnlineGlobalKey,
                                  onTargetClick: () {},
                                  disposeOnTap: false,
                                  targetBorderRadius: BorderRadius.circular(16),
                                  targetShapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  container: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Transform.rotate(
                                              angle: 45 * 3.1415926535 / 180,
                                              child: Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey0
                                                      .value,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(4),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            decoration: BoxDecoration(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Mulai Kerja Sekarang",
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
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Geser ke Online untuk mulai menerima pesanan dan menghasilkan pendapatan.',
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
                                                SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "3/8",
                                                      style: controller
                                                          .typographyServices
                                                          .captionLargeBold
                                                          .value
                                                          .copyWith(
                                                            color: controller
                                                                .themeColorServices
                                                                .neutralsColorGrey500
                                                                .value,
                                                          ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          ShowcaseView.get()
                                                              .next();
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              controller
                                                                  .themeColorServices
                                                                  .primaryBlue
                                                                  .value,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 0,
                                                              ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Lanjut",
                                                            style: controller
                                                                .typographyServices
                                                                .bodySmallBold
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .neutralsColorGrey0
                                                                      .value,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    ],
                                  ),
                                  child: AnimatedToggleSwitch<int>.dual(
                                    current:
                                        controller.isCoachmarkActive.value ==
                                            true
                                        ? controller.coachmarkWorkStatus.value
                                        : controller.workStatus.value,
                                    first: 2,
                                    second: 1,
                                    height: 50,
                                    borderWidth: 0,
                                    customIconBuilder:
                                        (context, local, global) {
                                          if (local.value == 2) {
                                            return CircleAvatar(
                                              backgroundColor: Color(
                                                0XFF999898,
                                              ),
                                              child: SvgPicture.asset(
                                                "assets/icons/icon_scooter.svg",
                                                width: 28.57,
                                                height: 28.57,
                                                color: Color(0XFF696969),
                                              ),
                                            );
                                          }
                                          return CircleAvatar(
                                            backgroundColor: Color(0XFF37C086),
                                            child: SvgPicture.asset(
                                              "assets/icons/icon_scooter.svg",
                                              width: 28.57,
                                              height: 28.57,
                                              color: Color(0XFFFFFFFF),
                                            ),
                                          );
                                        },
                                    customStyleBuilder:
                                        (context, local, global) {
                                          if (local.value == 2) {
                                            return ToggleStyle(
                                              backgroundColor: Color(
                                                0XFFCECECE,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(9999),
                                              indicatorColor:
                                                  Colors.transparent,
                                            );
                                          }
                                          return ToggleStyle(
                                            backgroundColor: Color(0XFF1FF79B),
                                            borderRadius: BorderRadius.circular(
                                              9999,
                                            ),
                                            indicatorColor: Colors.transparent,
                                          );
                                        },
                                    onChanged: (value) async {
                                      controller.onSwitchStatusWork();
                                    },
                                    customTextBuilder:
                                        (context, local, global) {
                                          return Text(
                                            local.value == 2
                                                ? "Offline"
                                                : "Online",
                                            style: controller
                                                .typographyServices
                                                .bodyLargeBold
                                                .value
                                                .copyWith(
                                                  color: local.value == 2
                                                      ? Color(0XFF747474)
                                                      : Color(0XFF07824D),
                                                ),
                                          );
                                        },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedIndex.value = 1;
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Showcase.withWidget(
                                      targetPadding: EdgeInsets.only(
                                        top: 0,
                                        right: 16,
                                        left: 16,
                                        bottom: 0,
                                      ),
                                      disableBarrierInteraction: true,
                                      key: controller.menuGlobalKey,
                                      onTargetClick: () {},
                                      disposeOnTap: false,
                                      targetBorderRadius: BorderRadius.circular(
                                        16,
                                      ),
                                      targetShapeBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      container: Stack(
                                        children: [
                                          Positioned(
                                            right: 16 * 2.5,
                                            bottom: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Transform.rotate(
                                                  angle:
                                                      45 * 3.1415926535 / 180,
                                                  child: Container(
                                                    width: 16,
                                                    height: 16,
                                                    decoration: BoxDecoration(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey0
                                                          .value,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                  4,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                width: MediaQuery.of(
                                                  context,
                                                ).size.width,
                                                decoration: BoxDecoration(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey0
                                                      .value,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "Pengaturan & Informasi Akun Driver",
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
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Akses berbagai fitur akun seperti notifikasi, evaluasi kinerja, pengelolaan data kendaraan dan kontak, hingga memberikan masukan serta membagikan EVMoto kepada rekan',
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
                                                    SizedBox(height: 16),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "8/8",
                                                          style: controller
                                                              .typographyServices
                                                              .captionLargeBold
                                                              .value
                                                              .copyWith(
                                                                color: controller
                                                                    .themeColorServices
                                                                    .neutralsColorGrey500
                                                                    .value,
                                                              ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          child: ElevatedButton(
                                                            onPressed: () async {
                                                              ShowcaseView.get()
                                                                  .next();
                                                              controller
                                                                      .isCoachmarkActive
                                                                      .value =
                                                                  false;
                                                              controller
                                                                      .coachmarkWorkStatus
                                                                      .value =
                                                                  2;
                                                              controller
                                                                      .selectedIndex
                                                                      .value =
                                                                  0;

                                                              var prefs =
                                                                  await SharedPreferences.getInstance();
                                                              await prefs.setBool(
                                                                'is_coachmark_displayed',
                                                                true,
                                                              );
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  controller
                                                                      .themeColorServices
                                                                      .primaryBlue
                                                                      .value,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical: 0,
                                                                  ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "Menuju Halaman Depan",
                                                                style: controller
                                                                    .typographyServices
                                                                    .bodySmallBold
                                                                    .value
                                                                    .copyWith(
                                                                      color: controller
                                                                          .themeColorServices
                                                                          .neutralsColorGrey0
                                                                          .value,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                            ],
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 27,
                                            height: 22,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  controller
                                                              .selectedIndex
                                                              .value ==
                                                          1
                                                      ? "assets/icons/icon_more_horizontal_selected.svg"
                                                      : "assets/icons/icon_more_horizontal.svg",
                                                  width: 27,
                                                  height: 22,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "Menu",
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color:
                                                      controller
                                                              .selectedIndex
                                                              .value ==
                                                          1
                                                      ? controller
                                                            .themeColorServices
                                                            .textColor
                                                            .value
                                                      : Color(0XFFB3B3B3),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }
}
