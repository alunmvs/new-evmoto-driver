import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/data/models/history_balance_revenue_model.dart';
import 'package:new_evmoto_driver/app/widgets/dashed_line.dart';

import '../controllers/history_balance_revenue_controller.dart';

class HistoryBalanceRevenueView
    extends GetView<HistoryBalanceRevenueController> {
  const HistoryBalanceRevenueView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.index.value == 0
                ? "Riwayat Pendapatan"
                : "Riwayat Pengeluaran",
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
            : Column(
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0XFF0573EA), Color(0XFF034184)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    scrollDirection: Axis.vertical,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    height: 87,
                                    onPageChanged: (index, reason) {
                                      controller.indexBanner.value = index
                                          .toDouble();
                                    },
                                  ),
                                  items: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Total Pendapatan Bulan Ini",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp',
                                            decimalDigits: 0,
                                          ).format(0.0),
                                          style: controller
                                              .typographyServices
                                              .headingMediumBold
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Total Pendapatan Hari Ini",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp',
                                            decimalDigits: 0,
                                          ).format(0.0),
                                          style: controller
                                              .typographyServices
                                              .headingMediumBold
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
                                  ],
                                ),
                              ),
                              DotsIndicator(
                                dotsCount: 2,
                                position: controller.indexBanner.value,
                                axis: Axis.vertical,
                                decorator: DotsDecorator(
                                  spacing: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 3,
                                  ),
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey300
                                      .value
                                      .withValues(alpha: 0.1),
                                  activeColor: controller
                                      .themeColorServices
                                      .neutralsColorGrey300
                                      .value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
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
                            tabs: [
                              Tab(text: "Pendapatan"),
                              Tab(text: "Pengeluaran"),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: controller.tabController,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 16),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        reverse: true,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(width: 16),
                                            for (var recommendationDateTime
                                                in controller
                                                    .recommendationDateTimeList
                                                    .reversed) ...[
                                              GestureDetector(
                                                onTap: () async {
                                                  controller
                                                          .selectedDateTime
                                                          .value =
                                                      recommendationDateTime;
                                                  await controller
                                                      .getHistoryBalanceRevenue();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        controller.isDateSelected(
                                                          recommendationDateTime,
                                                        )
                                                        ? controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value
                                                        : Colors.transparent,
                                                    border:
                                                        controller.isDateSelected(
                                                          recommendationDateTime,
                                                        )
                                                        ? Border.all(
                                                            color: controller
                                                                .themeColorServices
                                                                .primaryBlue
                                                                .value,
                                                          )
                                                        : Border.all(
                                                            color: Color(
                                                              0XFFDEDEDE,
                                                            ),
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                          'EEE',
                                                          'id_ID',
                                                        ).format(
                                                          recommendationDateTime,
                                                        ),
                                                        style: controller
                                                            .typographyServices
                                                            .captionLargeRegular
                                                            .value
                                                            .copyWith(
                                                              color:
                                                                  controller
                                                                      .isDateSelected(
                                                                        recommendationDateTime,
                                                                      )
                                                                  ? controller
                                                                        .themeColorServices
                                                                        .neutralsColorGrey0
                                                                        .value
                                                                  : Color(
                                                                      0XFFB3B3B3,
                                                                    ),
                                                            ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        recommendationDateTime
                                                            .day
                                                            .toString(),
                                                        style: controller
                                                            .typographyServices
                                                            .bodySmallBold
                                                            .value
                                                            .copyWith(
                                                              color:
                                                                  controller
                                                                      .isDateSelected(
                                                                        recommendationDateTime,
                                                                      )
                                                                  ? controller
                                                                        .themeColorServices
                                                                        .neutralsColorGrey0
                                                                        .value
                                                                  : Color(
                                                                      0XFFB3B3B3,
                                                                    ),
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Divider(
                                      height: 0,
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                    SizedBox(height: 8),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 8),
                                            if (controller
                                                    .historyBalanceRevenue
                                                    .value
                                                    .revenue
                                                    ?.isEmpty ??
                                                true) ...[
                                              SizedBox(height: 16 * 3),
                                              SvgPicture.asset(
                                                "assets/images/img_history_activity_not_found.svg",
                                                height: 80,
                                                width: 80,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                "Belum Ada Riwayat",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeBold
                                                    .value,
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Tidak ada riwayat pada bagian ini",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                            for (var revenue
                                                in controller
                                                        .historyBalanceRevenue
                                                        .value
                                                        .revenue ??
                                                    <Revenue>[]) ...[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey0
                                                        .value,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 42 / 2,
                                                                backgroundColor:
                                                                    Color(
                                                                      0XFFF3F3F3,
                                                                    ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                      "assets/icons/icon_history_revenue.svg",
                                                                      width:
                                                                          23.33,
                                                                      height:
                                                                          23.33,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                revenue.payTime ??
                                                                    "-",
                                                                style: controller
                                                                    .typographyServices
                                                                    .bodySmallRegular
                                                                    .value,
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 8,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Color(
                                                                    0XFF34A853,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                ),
                                                            child: Text(
                                                              revenue.orderType ==
                                                                      1
                                                                  ? "Motorcycle"
                                                                  : "City Express Delivery",
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
                                                              color: Color(
                                                                0XFFB3B3B3,
                                                              ),
                                                            ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
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
                                                      SizedBox(height: 16),
                                                      DashedLine(
                                                        color: Color(
                                                          0XFFD5D5D5,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Yang didapatkan driver :",
                                                            style: controller
                                                                .typographyServices
                                                                .bodySmallBold
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .textColor
                                                                      .value,
                                                                ),
                                                          ),
                                                          Text(
                                                            NumberFormat.currency(
                                                              locale: 'id_ID',
                                                              symbol: 'Rp',
                                                              decimalDigits: 0,
                                                            ).format(
                                                              revenue.payMoney,
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
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 16),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        reverse: true,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(width: 16),
                                            for (var recommendationDateTime
                                                in controller
                                                    .recommendationDateTimeList
                                                    .reversed) ...[
                                              GestureDetector(
                                                onTap: () async {
                                                  controller
                                                          .selectedDateTime
                                                          .value =
                                                      recommendationDateTime;
                                                  await controller
                                                      .getHistoryBalanceRevenue();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        controller.isDateSelected(
                                                          recommendationDateTime,
                                                        )
                                                        ? controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value
                                                        : Colors.transparent,
                                                    border:
                                                        controller.isDateSelected(
                                                          recommendationDateTime,
                                                        )
                                                        ? Border.all(
                                                            color: controller
                                                                .themeColorServices
                                                                .primaryBlue
                                                                .value,
                                                          )
                                                        : Border.all(
                                                            color: Color(
                                                              0XFFDEDEDE,
                                                            ),
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                          'EEE',
                                                          'id_ID',
                                                        ).format(
                                                          recommendationDateTime,
                                                        ),
                                                        style: controller
                                                            .typographyServices
                                                            .captionLargeRegular
                                                            .value
                                                            .copyWith(
                                                              color:
                                                                  controller
                                                                      .isDateSelected(
                                                                        recommendationDateTime,
                                                                      )
                                                                  ? controller
                                                                        .themeColorServices
                                                                        .neutralsColorGrey0
                                                                        .value
                                                                  : Color(
                                                                      0XFFB3B3B3,
                                                                    ),
                                                            ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        recommendationDateTime
                                                            .day
                                                            .toString(),
                                                        style: controller
                                                            .typographyServices
                                                            .bodySmallBold
                                                            .value
                                                            .copyWith(
                                                              color:
                                                                  controller
                                                                      .isDateSelected(
                                                                        recommendationDateTime,
                                                                      )
                                                                  ? controller
                                                                        .themeColorServices
                                                                        .neutralsColorGrey0
                                                                        .value
                                                                  : Color(
                                                                      0XFFB3B3B3,
                                                                    ),
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Divider(
                                      height: 0,
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                    SizedBox(height: 8),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 8),
                                            if (controller
                                                    .historyBalanceRevenue
                                                    .value
                                                    .revenue
                                                    ?.isEmpty ??
                                                true) ...[
                                              SizedBox(height: 16 * 3),
                                              SvgPicture.asset(
                                                "assets/images/img_history_activity_not_found.svg",
                                                height: 80,
                                                width: 80,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                "Belum Ada Riwayat",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeBold
                                                    .value,
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Tidak ada riwayat pada bagian ini",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                            for (var revenue
                                                in controller
                                                        .historyBalanceRevenue
                                                        .value
                                                        .revenue ??
                                                    <Revenue>[]) ...[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey0
                                                        .value,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 42 / 2,
                                                                backgroundColor:
                                                                    Color(
                                                                      0XFFF3F3F3,
                                                                    ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                      "assets/icons/icon_history_revenue.svg",
                                                                      width:
                                                                          23.33,
                                                                      height:
                                                                          23.33,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                revenue.payTime ??
                                                                    "-",
                                                                style: controller
                                                                    .typographyServices
                                                                    .bodySmallRegular
                                                                    .value,
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 8,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Color(
                                                                    0XFF34A853,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                ),
                                                            child: Text(
                                                              revenue.orderType ==
                                                                      1
                                                                  ? "Motorcycle"
                                                                  : "City Express Delivery",
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
                                                              color: Color(
                                                                0XFFB3B3B3,
                                                              ),
                                                            ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
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
                                                      SizedBox(height: 16),
                                                      DashedLine(
                                                        color: Color(
                                                          0XFFD5D5D5,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Potongan saldo aplikasi :",
                                                            style: controller
                                                                .typographyServices
                                                                .bodySmallBold
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .textColor
                                                                      .value,
                                                                ),
                                                          ),
                                                          Text(
                                                            NumberFormat.currency(
                                                              locale: 'id_ID',
                                                              symbol: '-Rp',
                                                              decimalDigits: 0,
                                                            ).format(
                                                              revenue.payMoney,
                                                            ),
                                                            style: controller
                                                                .typographyServices
                                                                .bodySmallBold
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .redColor
                                                                      .value,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                            ],
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
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
