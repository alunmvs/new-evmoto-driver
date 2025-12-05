import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
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
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
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
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_menu.svg",
                                        width: 24,
                                        height: 24,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 14),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_bubble_chat.svg",
                                        width: 24,
                                        height: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              "assets/logos/logo_evmoto_white.svg",
                              width: 67.69,
                              height: 20.96,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 35 / 2,
                                    backgroundImage: CachedNetworkImageProvider(
                                      controller.userInfo.value.avatar!,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.userInfo.value.name ?? "-",
                                          style: controller
                                              .typographyServices
                                              .bodyLargeBold
                                              .value,
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
                                  Text(
                                    DateFormat(
                                      'MM/dd\nEEEE',
                                    ).format(DateTime.now()),
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .textColor
                                              .value,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey200
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              controller
                                                  .vehicleStatistics
                                                  .value
                                                  .dayNum
                                                  .toString(),
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
                                              "Order\nToday",
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
                                              controller
                                                  .vehicleStatistics
                                                  .value
                                                  .dayNum
                                                  .toString(),
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
                                              "Order\nThis Month",
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
                                              controller
                                                  .vehicleStatistics
                                                  .value
                                                  .dayNum
                                                  .toString(),
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
                                              "My Rating",
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
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_arrow_up_right.svg",
                                        width: 18,
                                        height: 18,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "My Activities",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    controller.vehicleStatistics.value.activity
                                        .toString(),
                                    style: controller
                                        .typographyServices
                                        .bodyLargeBold
                                        .value,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              TabBar(
                                labelColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                indicatorColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                unselectedLabelColor: controller
                                    .themeColorServices
                                    .primaryBlue
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
                                tabAlignment: TabAlignment.start,
                                overlayColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                                tabs: [
                                  Tab(text: 'Order Grabbing Hall'),
                                  Tab(text: 'In Service'),
                                  Tab(text: 'To be Served'),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    SmartRefresher(
                                      header: MaterialClassicHeader(
                                        color: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                      ),
                                      enablePullDown: true,
                                      enablePullUp: controller
                                          .isSeeMoreOrderGrabbingHall
                                          .value,
                                      onRefresh: () async {
                                        await Future.wait([
                                          controller.getUserInfoDetail(),
                                          controller.getVehicleStatistics(),
                                          controller.getOrderGrabbingHallList(),
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
                                        physics: NeverScrollableScrollPhysics(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 16),
                                              for (var orderGrabbingHall
                                                  in controller
                                                      .orderGrabbingHallList) ...[
                                                Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey200
                                                          .value,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            orderGrabbingHall
                                                                        .type ==
                                                                    1
                                                                ? "Motorcycle"
                                                                : "-",
                                                            style: controller
                                                                .typographyServices
                                                                .bodyLargeRegular
                                                                .value
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .textColor
                                                                      .value,
                                                                ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9999,
                                                                  ),
                                                              color: controller
                                                                  .themeColorServices
                                                                  .scheduleArrivalPlaceBackgroundColor
                                                                  .value,
                                                            ),
                                                            child: Text(
                                                              orderGrabbingHall
                                                                  .state
                                                                  .toString(),
                                                              style: controller
                                                                  .typographyServices
                                                                  .captionLargeRegular
                                                                  .value
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: controller
                                                                        .themeColorServices
                                                                        .textColor
                                                                        .value,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 16),
                                                      Divider(
                                                        height: 0,
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey200
                                                            .value,
                                                      ),
                                                      SizedBox(height: 16),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_clock.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            orderGrabbingHall
                                                                .time
                                                                .toString(),
                                                            style: controller
                                                                .typographyServices
                                                                .bodyLargeRegular
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
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_location.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Dijemput",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodySmallRegular
                                                                      .value
                                                                      .copyWith(
                                                                        color: controller
                                                                            .themeColorServices
                                                                            .imageUploadVerticalDividerColor
                                                                            .value,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  orderGrabbingHall
                                                                          .startAddress ??
                                                                      "-",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodyLargeRegular
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
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_pin_location.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Lokasi Tujuan",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodySmallRegular
                                                                      .value
                                                                      .copyWith(
                                                                        color: controller
                                                                            .themeColorServices
                                                                            .imageUploadVerticalDividerColor
                                                                            .value,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  orderGrabbingHall
                                                                          .endAddress ??
                                                                      "-",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodyLargeRegular
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
                                                      SizedBox(height: 16),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              await controller
                                                                  .onTapGrabDialog(
                                                                    order:
                                                                        orderGrabbingHall,
                                                                  );
                                                            },
                                                            child: Text("Grab"),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
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
                                      enablePullDown: true,
                                      enablePullUp: controller
                                          .isSeeMoreOrderInService
                                          .value,
                                      onRefresh: () async {
                                        await Future.wait([
                                          controller.getUserInfoDetail(),
                                          controller.getVehicleStatistics(),
                                          controller.getOrderInServiceList(),
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
                                        physics: NeverScrollableScrollPhysics(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 16),
                                              for (var orderInService
                                                  in controller
                                                      .orderInServiceList) ...[
                                                Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey200
                                                          .value,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            orderInService
                                                                        .type ==
                                                                    1
                                                                ? "Motorcycle"
                                                                : "-",
                                                            style: controller
                                                                .typographyServices
                                                                .bodyLargeRegular
                                                                .value
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .textColor
                                                                      .value,
                                                                ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9999,
                                                                  ),
                                                              color: controller
                                                                  .themeColorServices
                                                                  .scheduleArrivalPlaceBackgroundColor
                                                                  .value,
                                                            ),
                                                            child: Text(
                                                              orderInService
                                                                  .state
                                                                  .toString(),
                                                              style: controller
                                                                  .typographyServices
                                                                  .captionLargeRegular
                                                                  .value
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: controller
                                                                        .themeColorServices
                                                                        .textColor
                                                                        .value,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 16),
                                                      Divider(
                                                        height: 0,
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey200
                                                            .value,
                                                      ),
                                                      SizedBox(height: 16),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_clock.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            orderInService.time
                                                                .toString(),
                                                            style: controller
                                                                .typographyServices
                                                                .bodyLargeRegular
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
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_location.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Dijemput",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodySmallRegular
                                                                      .value
                                                                      .copyWith(
                                                                        color: controller
                                                                            .themeColorServices
                                                                            .imageUploadVerticalDividerColor
                                                                            .value,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  orderInService
                                                                          .startAddress ??
                                                                      "-",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodyLargeRegular
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
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_pin_location.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Lokasi Tujuan",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodySmallRegular
                                                                      .value
                                                                      .copyWith(
                                                                        color: controller
                                                                            .themeColorServices
                                                                            .imageUploadVerticalDividerColor
                                                                            .value,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  orderInService
                                                                          .endAddress ??
                                                                      "-",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodyLargeRegular
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
                                                    ],
                                                  ),
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
                                      enablePullDown: true,
                                      enablePullUp: controller
                                          .isSeeMoreOrderToBeServed
                                          .value,
                                      onRefresh: () async {
                                        await Future.wait([
                                          controller.getUserInfoDetail(),
                                          controller.getVehicleStatistics(),
                                          controller.getOrderToBeServedList(),
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
                                        physics: NeverScrollableScrollPhysics(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 16),
                                              for (var orderToBeServed
                                                  in controller
                                                      .orderToBeServedList) ...[
                                                Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey200
                                                          .value,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            orderToBeServed
                                                                        .type ==
                                                                    1
                                                                ? "Motorcycle"
                                                                : "-",
                                                            style: controller
                                                                .typographyServices
                                                                .bodyLargeRegular
                                                                .value
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .textColor
                                                                      .value,
                                                                ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    9999,
                                                                  ),
                                                              color: controller
                                                                  .themeColorServices
                                                                  .scheduleArrivalPlaceBackgroundColor
                                                                  .value,
                                                            ),
                                                            child: Text(
                                                              orderToBeServed
                                                                  .state
                                                                  .toString(),
                                                              style: controller
                                                                  .typographyServices
                                                                  .captionLargeRegular
                                                                  .value
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: controller
                                                                        .themeColorServices
                                                                        .textColor
                                                                        .value,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 16),
                                                      Divider(
                                                        height: 0,
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey200
                                                            .value,
                                                      ),
                                                      SizedBox(height: 16),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_clock.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            orderToBeServed.time
                                                                .toString(),
                                                            style: controller
                                                                .typographyServices
                                                                .bodyLargeRegular
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
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_location.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Dijemput",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodySmallRegular
                                                                      .value
                                                                      .copyWith(
                                                                        color: controller
                                                                            .themeColorServices
                                                                            .imageUploadVerticalDividerColor
                                                                            .value,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  orderToBeServed
                                                                          .startAddress ??
                                                                      "-",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodyLargeRegular
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
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_pin_location.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Lokasi Tujuan",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodySmallRegular
                                                                      .value
                                                                      .copyWith(
                                                                        color: controller
                                                                            .themeColorServices
                                                                            .imageUploadVerticalDividerColor
                                                                            .value,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  orderToBeServed
                                                                          .endAddress ??
                                                                      "-",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodyLargeRegular
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
                                                    ],
                                                  ),
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
                  Positioned(
                    bottom: 16 + 2,
                    right: 0,
                    left: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedToggleSwitch<int>.dual(
                          current: controller.workStatus.value,
                          first: 2,
                          second: 1,
                          height: 50,
                          borderWidth: 0,
                          customIconBuilder: (context, local, global) {
                            if (local.value == 2) {
                              return CircleAvatar(
                                backgroundColor: Color(0XFF999898),
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
                          customStyleBuilder: (context, local, global) {
                            if (local.value == 2) {
                              return ToggleStyle(
                                backgroundColor: Color(0XFFCECECE),
                                borderRadius: BorderRadius.circular(9999),
                                indicatorColor: Colors.transparent,
                              );
                            }
                            return ToggleStyle(
                              backgroundColor: Color(0XFF1FF79B),
                              borderRadius: BorderRadius.circular(9999),
                              indicatorColor: Colors.transparent,
                            );
                          },
                          onChanged: (value) async {
                            controller.onSwitchStatusWork();
                          },
                          customTextBuilder: (context, local, global) {
                            return Text(
                              local.value == 2 ? "Offline" : "Online",
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
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
