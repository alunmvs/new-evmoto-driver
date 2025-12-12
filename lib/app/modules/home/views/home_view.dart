import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
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
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(0XFFF9F9F9),
                              width: 4,
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 35 / 2,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
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
                                            controller.userInfo.value.name ??
                                                "-",
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
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0XFFF5F5F5),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
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
                                              "Pesanan\nHari Ini",
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
                                                  .mouthNum
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
                                              "Pesanan\nBulan Ini",
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
                                                  .score!
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
                                              "Rating\nSaya",
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
                                                  .activity
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
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              "Aktivitas\nSaya",
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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            border: Border.all(color: Color(0XFFE6E6E6)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue100
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
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
                                          controller.userInfo.value.balance,
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
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await Get.toNamed(Routes.DEPOSIT_BALANCE);

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
                                  SizedBox(width: 14),
                                  Column(
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
                                  SizedBox(width: 14),
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_others.svg",
                                        width: 18,
                                        height: 18,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Lainnya",
                                        style: controller
                                            .typographyServices
                                            .captionLargeRegular
                                            .value,
                                      ),
                                    ],
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
                                        controller.getVehicleStatistics(),
                                        controller.getOrderGrabbingHallList(),
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
                                        controller.getVehicleStatistics(),

                                        controller.getOrderInServiceList(),
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
                                        controller.getVehicleStatistics(),
                                        controller.getOrderToBeServedList(),
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
                                  Tab(text: 'Menerima Pesanan'),
                                  Tab(text: 'Dalam Layanan'),
                                  Tab(text: 'Menunggu'),
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
                                              if (controller
                                                  .orderGrabbingHallList
                                                  .isEmpty) ...[
                                                SizedBox(height: 16 * 3),
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
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  "Tidak ada pesanan pada bagian Menerima Pesanan",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallRegular
                                                      .value,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
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
                                                                  .getBackgroundColorOrderState(
                                                                    state: orderGrabbingHall
                                                                        .state!,
                                                                  ),
                                                            ),
                                                            child: Text(
                                                              controller.getStringOrderState(
                                                                state:
                                                                    orderGrabbingHall
                                                                        .state!,
                                                              ),
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
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width,
                                                              height: 46,
                                                              child: ElevatedButton(
                                                                onPressed: () async {
                                                                  await controller
                                                                      .onTapGrabDialog(
                                                                        order:
                                                                            orderGrabbingHall,
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
                                                                          16,
                                                                        ),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  "Grab",
                                                                  style: controller
                                                                      .typographyServices
                                                                      .bodyLargeBold
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
                                              if (controller
                                                  .orderInServiceList
                                                  .isEmpty) ...[
                                                SizedBox(height: 16 * 3),
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
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  "Tidak ada pesanan pada bagian Dalam Layanan",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallRegular
                                                      .value,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                              for (var orderInService
                                                  in controller
                                                      .orderInServiceList) ...[
                                                GestureDetector(
                                                  onTap: () async {
                                                    await Get.toNamed(
                                                      Routes.ORDER_DETAIL,
                                                      arguments: {
                                                        "order_id":
                                                            orderInService.id,
                                                        "order_type":
                                                            orderInService.type,
                                                      },
                                                    );
                                                    await controller
                                                        .refreshAll();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
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
                                                                    horizontal:
                                                                        8,
                                                                    vertical: 4,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      9999,
                                                                    ),
                                                                color: controller
                                                                    .getBackgroundColorOrderState(
                                                                      state: orderInService
                                                                          .state!,
                                                                    ),
                                                              ),
                                                              child: Text(
                                                                controller.getStringOrderState(
                                                                  state:
                                                                      orderInService
                                                                          .state!,
                                                                ),
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
                                                              orderInService
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
                                              if (controller
                                                  .orderToBeServedList
                                                  .isEmpty) ...[
                                                SizedBox(height: 16 * 3),
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
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  "Tidak ada pesanan pada bagian Menunggu",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallRegular
                                                      .value,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                              for (var orderToBeServed
                                                  in controller
                                                      .orderToBeServedList) ...[
                                                GestureDetector(
                                                  onTap: () async {
                                                    await Get.toNamed(
                                                      Routes.ORDER_DETAIL,
                                                      arguments: {
                                                        "order_id":
                                                            orderToBeServed.id,
                                                        "order_type":
                                                            orderToBeServed
                                                                .type,
                                                      },
                                                    );

                                                    await controller
                                                        .refreshAll();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
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
                                                                    horizontal:
                                                                        8,
                                                                    vertical: 4,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      9999,
                                                                    ),
                                                                color: controller
                                                                    .getBackgroundColorOrderState(
                                                                      state: orderToBeServed
                                                                          .state!,
                                                                    ),
                                                              ),
                                                              child: Text(
                                                                controller.getStringOrderState(
                                                                  state:
                                                                      orderToBeServed
                                                                          .state!,
                                                                ),
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
                                                              orderToBeServed
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
