import 'dart:io';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/data/models/socket_order_status_data_model.dart';
import 'package:new_evmoto_driver/app/modules/account/views/account_view.dart';
import 'package:new_evmoto_driver/app/modules/home/views/home_view/home_balance_sub_view.dart';
import 'package:new_evmoto_driver/app/modules/home/views/home_view/home_guarantee_income_progress_bar_card_full_screen_sub_view.dart';
import 'package:new_evmoto_driver/app/modules/home/views/home_view/home_guarantee_income_progress_bar_card_sub_view.dart';
import 'package:new_evmoto_driver/app/modules/home/views/home_view/home_statistics_card_sub_view.dart';
import 'package:new_evmoto_driver/app/modules/home/views/home_view/order_card_home_sub_view.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (Platform.isAndroid) {
            var now = DateTime.now();

            if (now.difference(controller.lastPressedBackDateTime.value) >
                Duration(seconds: 2)) {
              controller.lastPressedBackDateTime.value = now;
            } else {
              SystemNavigator.pop();
            }
          }
        },
        child: Scaffold(
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
                          children: [
                            NestedScrollView(
                              headerSliverBuilder: (context, innerBoxIsScrolled) {
                                return [
                                  Obx(
                                    () => SliverOverlapAbsorber(
                                      handle:
                                          NestedScrollView.sliverOverlapAbsorberHandleFor(
                                            context,
                                          ),
                                      sliver: MultiSliver(
                                        children: [
                                          SliverToBoxAdapter(
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                                  height:
                                                      controller
                                                              .activeGuaranteeIncomeProgressBar
                                                              .value
                                                              ?.id ==
                                                          null
                                                      ? 140
                                                      : 200,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/img_background_home.png",
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
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
                                                ),
                                                Column(
                                                  children: [
                                                    SizedBox(height: 40),
                                                    SizedBox(height: 16),
                                                    if (controller
                                                            .activeGuaranteeIncomeProgressBar
                                                            .value
                                                            ?.id !=
                                                        null) ...[
                                                      HomeGuaranteeIncomeProgressBarCardSubView(),
                                                      SizedBox(height: 16),
                                                    ],
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
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
                                                                    color: Color(
                                                                      0XFF0052AA,
                                                                    ),
                                                                    borderRadius: BorderRadius.only(
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
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Showcase.withWidget(
                                                                disableBarrierInteraction:
                                                                    true,
                                                                key: controller
                                                                    .activityStatisticsGlobalKey,
                                                                onTargetClick:
                                                                    () {},
                                                                disposeOnTap:
                                                                    false,
                                                                targetBorderRadius:
                                                                    BorderRadius.circular(
                                                                      16,
                                                                    ),
                                                                targetShapeBorder:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            16,
                                                                          ),
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
                                                                                color: controller.themeColorServices.neutralsColorGrey0.value,
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(
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
                                                                        SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Container(
                                                                          padding: EdgeInsets.all(
                                                                            16,
                                                                          ),
                                                                          width: MediaQuery.of(
                                                                            context,
                                                                          ).size.width,
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                controller.themeColorServices.neutralsColorGrey0.value,
                                                                            borderRadius: BorderRadius.circular(
                                                                              16,
                                                                            ),
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children:
                                                                                <
                                                                                  Widget
                                                                                >[
                                                                                  Text(
                                                                                    controller.languageServices.language.value.coachmarkTitle1 ??
                                                                                        "-",
                                                                                    style: controller.typographyServices.bodyLargeBold.value.copyWith(
                                                                                      color: controller.themeColorServices.textColor.value,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 4,
                                                                                  ),
                                                                                  Text(
                                                                                    controller.languageServices.language.value.coachmarkDescription1 ??
                                                                                        "-",
                                                                                    style: controller.typographyServices.bodySmallRegular.value.copyWith(
                                                                                      color: controller.themeColorServices.textColor.value,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 16,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        "1/8",
                                                                                        style: controller.typographyServices.captionLargeBold.value.copyWith(
                                                                                          color: controller.themeColorServices.neutralsColorGrey500.value,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 30,
                                                                                        child: ElevatedButton(
                                                                                          onPressed: () {
                                                                                            ShowcaseView.get().next();
                                                                                          },
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: controller.themeColorServices.primaryBlue.value,
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(
                                                                                                8,
                                                                                              ),
                                                                                            ),
                                                                                            padding: EdgeInsets.symmetric(
                                                                                              horizontal: 16,
                                                                                              vertical: 0,
                                                                                            ),
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              controller.languageServices.language.value.buttonNext1 ??
                                                                                                  "-",
                                                                                              style: controller.typographyServices.bodySmallBold.value.copyWith(
                                                                                                color: controller.themeColorServices.neutralsColorGrey0.value,
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
                                                                child:
                                                                    HomeStatisticsCardSubView(),
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
                                          ),
                                          SliverPersistentHeader(
                                            pinned: true,
                                            delegate: _PinnedHeaderDelegate(
                                              minHeight: 50,
                                              maxHeight: 50,
                                              child: Container(
                                                color: controller
                                                    .themeColorServices
                                                    .backgroundColor
                                                    .value,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                          ),
                                                      child: Showcase.withWidget(
                                                        disableBarrierInteraction:
                                                            true,
                                                        key: controller
                                                            .buttonSeeAllMyActivityGlobalKey,
                                                        onTargetClick: () {},
                                                        disposeOnTap: false,
                                                        targetBorderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        targetShapeBorder:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                            ),
                                                        container: Stack(
                                                          children: [
                                                            Positioned(
                                                              left: 0,
                                                              right: 0,
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
                                                                      height:
                                                                          16,
                                                                      decoration: BoxDecoration(
                                                                        color: controller
                                                                            .themeColorServices
                                                                            .neutralsColorGrey0
                                                                            .value,
                                                                        borderRadius: BorderRadius.only(
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
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets.all(
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
                                                                        controller.languageServices.language.value.coachmarkTitle2 ??
                                                                            "-",
                                                                        style: controller
                                                                            .typographyServices
                                                                            .bodyLargeBold
                                                                            .value
                                                                            .copyWith(
                                                                              color: controller.themeColorServices.textColor.value,
                                                                            ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                        controller.languageServices.language.value.coachmarkDescription2 ??
                                                                            "-",
                                                                        style: controller
                                                                            .typographyServices
                                                                            .bodySmallRegular
                                                                            .value
                                                                            .copyWith(
                                                                              color: controller.themeColorServices.textColor.value,
                                                                            ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            16,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "2/8",
                                                                            style: controller.typographyServices.captionLargeBold.value.copyWith(
                                                                              color: controller.themeColorServices.neutralsColorGrey500.value,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                30,
                                                                            child: ElevatedButton(
                                                                              onPressed: () {
                                                                                ShowcaseView.get().next();
                                                                                Future.delayed(
                                                                                  Duration(
                                                                                    milliseconds: 500,
                                                                                  ),
                                                                                ).whenComplete(
                                                                                  () {
                                                                                    controller.coachmarkWorkStatus.value = 1;
                                                                                  },
                                                                                );
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: controller.themeColorServices.primaryBlue.value,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    8,
                                                                                  ),
                                                                                ),
                                                                                padding: EdgeInsets.symmetric(
                                                                                  horizontal: 16,
                                                                                  vertical: 0,
                                                                                ),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  controller.languageServices.language.value.buttonNext1 ??
                                                                                      "-",
                                                                                  style: controller.typographyServices.bodySmallBold.value.copyWith(
                                                                                    color: controller.themeColorServices.neutralsColorGrey0.value,
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
                                                          children: [
                                                            Expanded(
                                                              child: GestureDetector(
                                                                onTap: () async {
                                                                  await Get.toNamed(
                                                                    Routes
                                                                        .MY_ORDER,
                                                                  );
                                                                  await controller
                                                                      .refreshAll();
                                                                  // await Get.toNamed(
                                                                  //   Routes
                                                                  //       .MY_ORDER_V2,
                                                                  // );
                                                                  // await controller
                                                                  //     .refreshAll();
                                                                  // await controller
                                                                  //     .showDialogAdvancedBookingConfirmation(
                                                                  //       socketOrderStatusData:
                                                                  //           SocketOrderStatusData(),
                                                                  //     );
                                                                },
                                                                child: Container(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                        16,
                                                                      ),
                                                                  width: MediaQuery.of(
                                                                    context,
                                                                  ).size.width,
                                                                  decoration: BoxDecoration(
                                                                    color: Color(
                                                                      0XFF0052AA,
                                                                    ),
                                                                    borderRadius: BorderRadius.only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                            16,
                                                                          ),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                            0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Text(
                                                                        "Order Saya",
                                                                        style: controller
                                                                            .typographyServices
                                                                            .bodySmallBold
                                                                            .value
                                                                            .copyWith(
                                                                              color: controller.themeColorServices.neutralsColorGrey0.value,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: GestureDetector(
                                                                onTap: () async {
                                                                  await Get.toNamed(
                                                                    Routes
                                                                        .MY_ACTIVITY,
                                                                  );
                                                                  await controller
                                                                      .refreshAll();
                                                                },
                                                                child: Container(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                        16,
                                                                      ),
                                                                  width: MediaQuery.of(
                                                                    context,
                                                                  ).size.width,
                                                                  decoration: BoxDecoration(
                                                                    color: Color(
                                                                      0XFF0052AA,
                                                                    ),
                                                                    borderRadius: BorderRadius.only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                            0,
                                                                          ),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                            16,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Text(
                                                                        "Aktivitas Saya",
                                                                        style: controller
                                                                            .typographyServices
                                                                            .bodySmallBold
                                                                            .value
                                                                            .copyWith(
                                                                              color: controller.themeColorServices.neutralsColorGrey0.value,
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SliverPersistentHeader(
                                            pinned: true,
                                            delegate: _PinnedHeaderDelegate(
                                              minHeight: 50,
                                              maxHeight: 93,
                                              child: Container(
                                                color: controller
                                                    .themeColorServices
                                                    .backgroundColor
                                                    .value,
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 16),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                          ),
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                          16,
                                                        ),
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
                                                                  .withValues(
                                                                    alpha: 0.10,
                                                                  ),
                                                              blurRadius: 8,
                                                              spreadRadius: 0,
                                                              offset: Offset(
                                                                0,
                                                                4,
                                                              ),
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Showcase.withWidget(
                                                                targetPadding:
                                                                    EdgeInsets.only(
                                                                      top: 16,
                                                                      right: 16,
                                                                      left: 16,
                                                                      bottom:
                                                                          16,
                                                                    ),
                                                                disableBarrierInteraction:
                                                                    true,
                                                                key: controller
                                                                    .balanceGlobalKey,
                                                                onTargetClick:
                                                                    () {},
                                                                disposeOnTap:
                                                                    false,
                                                                targetBorderRadius:
                                                                    BorderRadius.circular(
                                                                      16,
                                                                    ),
                                                                targetShapeBorder:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            16,
                                                                          ),
                                                                    ),
                                                                container: Stack(
                                                                  children: [
                                                                    Positioned(
                                                                      left:
                                                                          16 *
                                                                          5,
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
                                                                                color: controller.themeColorServices.neutralsColorGrey0.value,
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(
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
                                                                        SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Container(
                                                                          padding: EdgeInsets.all(
                                                                            16,
                                                                          ),
                                                                          width: MediaQuery.of(
                                                                            context,
                                                                          ).size.width,
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                controller.themeColorServices.neutralsColorGrey0.value,
                                                                            borderRadius: BorderRadius.circular(
                                                                              16,
                                                                            ),
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children:
                                                                                <
                                                                                  Widget
                                                                                >[
                                                                                  Text(
                                                                                    controller.languageServices.language.value.coachmarkTitle4 ??
                                                                                        "-",
                                                                                    style: controller.typographyServices.bodyLargeBold.value.copyWith(
                                                                                      color: controller.themeColorServices.textColor.value,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 4,
                                                                                  ),
                                                                                  Text(
                                                                                    controller.languageServices.language.value.coachmarkDescription4 ??
                                                                                        "-",
                                                                                    style: controller.typographyServices.bodySmallRegular.value.copyWith(
                                                                                      color: controller.themeColorServices.textColor.value,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 16,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        "4/8",
                                                                                        style: controller.typographyServices.captionLargeBold.value.copyWith(
                                                                                          color: controller.themeColorServices.neutralsColorGrey500.value,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 30,
                                                                                        child: ElevatedButton(
                                                                                          onPressed: () {
                                                                                            ShowcaseView.get().next();
                                                                                          },
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: controller.themeColorServices.primaryBlue.value,
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(
                                                                                                8,
                                                                                              ),
                                                                                            ),
                                                                                            padding: EdgeInsets.symmetric(
                                                                                              horizontal: 16,
                                                                                              vertical: 0,
                                                                                            ),
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              controller.languageServices.language.value.buttonNext1 ??
                                                                                                  "-",
                                                                                              style: controller.typographyServices.bodySmallBold.value.copyWith(
                                                                                                color: controller.themeColorServices.neutralsColorGrey0.value,
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
                                                                child:
                                                                    HomeBalanceSubView(),
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Row(
                                                              children: [
                                                                Showcase.withWidget(
                                                                  targetPadding:
                                                                      EdgeInsets.only(
                                                                        top: 16,
                                                                        right:
                                                                            16,
                                                                        left:
                                                                            16,
                                                                        bottom:
                                                                            16,
                                                                      ),
                                                                  disableBarrierInteraction:
                                                                      true,
                                                                  key: controller
                                                                      .topUpGlobalKey,
                                                                  onTargetClick:
                                                                      () {},
                                                                  disposeOnTap:
                                                                      false,
                                                                  targetBorderRadius:
                                                                      BorderRadius.circular(
                                                                        16,
                                                                      ),
                                                                  targetShapeBorder:
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              16,
                                                                            ),
                                                                      ),
                                                                  container: Stack(
                                                                    children: [
                                                                      Positioned(
                                                                        right:
                                                                            16 *
                                                                            10.25,
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
                                                                                  color: controller.themeColorServices.neutralsColorGrey0.value,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(
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
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Container(
                                                                            padding: EdgeInsets.all(
                                                                              16,
                                                                            ),
                                                                            width: MediaQuery.of(
                                                                              context,
                                                                            ).size.width,
                                                                            decoration: BoxDecoration(
                                                                              color: controller.themeColorServices.neutralsColorGrey0.value,
                                                                              borderRadius: BorderRadius.circular(
                                                                                16,
                                                                              ),
                                                                            ),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children:
                                                                                  <
                                                                                    Widget
                                                                                  >[
                                                                                    Text(
                                                                                      controller.languageServices.language.value.coachmarkTitle5 ??
                                                                                          "-",
                                                                                      style: controller.typographyServices.bodyLargeBold.value.copyWith(
                                                                                        color: controller.themeColorServices.textColor.value,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 4,
                                                                                    ),
                                                                                    Text(
                                                                                      controller.languageServices.language.value.coachmarkDescription5 ??
                                                                                          "-",
                                                                                      style: controller.typographyServices.bodySmallRegular.value.copyWith(
                                                                                        color: controller.themeColorServices.textColor.value,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 16,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          "5/8",
                                                                                          style: controller.typographyServices.captionLargeBold.value.copyWith(
                                                                                            color: controller.themeColorServices.neutralsColorGrey500.value,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 30,
                                                                                          child: ElevatedButton(
                                                                                            onPressed: () {
                                                                                              ShowcaseView.get().next();
                                                                                            },
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: controller.themeColorServices.primaryBlue.value,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(
                                                                                                  8,
                                                                                                ),
                                                                                              ),
                                                                                              padding: EdgeInsets.symmetric(
                                                                                                horizontal: 16,
                                                                                                vertical: 0,
                                                                                              ),
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                controller.languageServices.language.value.buttonNext1 ??
                                                                                                    "-",
                                                                                                style: controller.typographyServices.bodySmallBold.value.copyWith(
                                                                                                  color: controller.themeColorServices.neutralsColorGrey0.value,
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
                                                                        Routes
                                                                            .DEPOSIT_BALANCE,
                                                                      );

                                                                      await controller
                                                                          .refreshAll();
                                                                    },
                                                                    child: Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      child: Column(
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                            "assets/icons/icon_add_circle.svg",
                                                                            width:
                                                                                18,
                                                                            height:
                                                                                18,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          Text(
                                                                            controller.languageServices.language.value.recharge ??
                                                                                "-",
                                                                            style:
                                                                                controller.typographyServices.captionLargeRegular.value,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Showcase.withWidget(
                                                                  targetPadding:
                                                                      EdgeInsets.only(
                                                                        top: 16,
                                                                        right:
                                                                            16,
                                                                        left:
                                                                            16,
                                                                        bottom:
                                                                            16,
                                                                      ),
                                                                  disableBarrierInteraction:
                                                                      true,
                                                                  key: controller
                                                                      .withdrawGlobalKey,
                                                                  onTargetClick:
                                                                      () {},
                                                                  disposeOnTap:
                                                                      false,
                                                                  targetBorderRadius:
                                                                      BorderRadius.circular(
                                                                        16,
                                                                      ),
                                                                  targetShapeBorder:
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              16,
                                                                            ),
                                                                      ),
                                                                  container: Stack(
                                                                    children: [
                                                                      Positioned(
                                                                        right:
                                                                            16 *
                                                                            6,
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
                                                                                  color: controller.themeColorServices.neutralsColorGrey0.value,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(
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
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Container(
                                                                            padding: EdgeInsets.all(
                                                                              16,
                                                                            ),
                                                                            width: MediaQuery.of(
                                                                              context,
                                                                            ).size.width,
                                                                            decoration: BoxDecoration(
                                                                              color: controller.themeColorServices.neutralsColorGrey0.value,
                                                                              borderRadius: BorderRadius.circular(
                                                                                16,
                                                                              ),
                                                                            ),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children:
                                                                                  <
                                                                                    Widget
                                                                                  >[
                                                                                    Text(
                                                                                      controller.languageServices.language.value.coachmarkTitle6 ??
                                                                                          "-",
                                                                                      style: controller.typographyServices.bodyLargeBold.value.copyWith(
                                                                                        color: controller.themeColorServices.textColor.value,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 4,
                                                                                    ),
                                                                                    Text(
                                                                                      controller.languageServices.language.value.coachmarkDescription6 ??
                                                                                          "-",
                                                                                      style: controller.typographyServices.bodySmallRegular.value.copyWith(
                                                                                        color: controller.themeColorServices.textColor.value,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 16,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          "6/8",
                                                                                          style: controller.typographyServices.captionLargeBold.value.copyWith(
                                                                                            color: controller.themeColorServices.neutralsColorGrey500.value,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 30,
                                                                                          child: ElevatedButton(
                                                                                            onPressed: () {
                                                                                              ShowcaseView.get().next();
                                                                                            },
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: controller.themeColorServices.primaryBlue.value,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(
                                                                                                  8,
                                                                                                ),
                                                                                              ),
                                                                                              padding: EdgeInsets.symmetric(
                                                                                                horizontal: 16,
                                                                                                vertical: 0,
                                                                                              ),
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                "Lanjut",
                                                                                                style: controller.typographyServices.bodySmallBold.value.copyWith(
                                                                                                  color: controller.themeColorServices.neutralsColorGrey0.value,
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
                                                                        Routes
                                                                            .WITHDRAW,
                                                                      );

                                                                      await controller
                                                                          .refreshAll();
                                                                    },
                                                                    child: Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      child: Column(
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                            "assets/icons/icon_withdraw.svg",
                                                                            width:
                                                                                19,
                                                                            height:
                                                                                19,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          Text(
                                                                            controller.languageServices.language.value.withdraw ??
                                                                                "-",
                                                                            style:
                                                                                controller.typographyServices.captionLargeRegular.value,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Showcase.withWidget(
                                                                  targetPadding:
                                                                      EdgeInsets.only(
                                                                        top: 16,
                                                                        right:
                                                                            16,
                                                                        left:
                                                                            16,
                                                                        bottom:
                                                                            16,
                                                                      ),
                                                                  disableBarrierInteraction:
                                                                      true,
                                                                  key: controller
                                                                      .historyGlobalKey,
                                                                  onTargetClick:
                                                                      () {},
                                                                  disposeOnTap:
                                                                      false,
                                                                  targetBorderRadius:
                                                                      BorderRadius.circular(
                                                                        16,
                                                                      ),
                                                                  targetShapeBorder:
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              16,
                                                                            ),
                                                                      ),
                                                                  container: Stack(
                                                                    children: [
                                                                      Positioned(
                                                                        right:
                                                                            16 *
                                                                            2,
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
                                                                                  color: controller.themeColorServices.neutralsColorGrey0.value,
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(
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
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Container(
                                                                            padding: EdgeInsets.all(
                                                                              16,
                                                                            ),
                                                                            width: MediaQuery.of(
                                                                              context,
                                                                            ).size.width,
                                                                            decoration: BoxDecoration(
                                                                              color: controller.themeColorServices.neutralsColorGrey0.value,
                                                                              borderRadius: BorderRadius.circular(
                                                                                16,
                                                                              ),
                                                                            ),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children:
                                                                                  <
                                                                                    Widget
                                                                                  >[
                                                                                    Text(
                                                                                      controller.languageServices.language.value.coachmarkTitle7 ??
                                                                                          "-",
                                                                                      style: controller.typographyServices.bodyLargeBold.value.copyWith(
                                                                                        color: controller.themeColorServices.textColor.value,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 4,
                                                                                    ),
                                                                                    Text(
                                                                                      controller.languageServices.language.value.coachmarkDescription7 ??
                                                                                          "-",
                                                                                      style: controller.typographyServices.bodySmallRegular.value.copyWith(
                                                                                        color: controller.themeColorServices.textColor.value,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 16,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          "7/8",
                                                                                          style: controller.typographyServices.captionLargeBold.value.copyWith(
                                                                                            color: controller.themeColorServices.neutralsColorGrey500.value,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 30,
                                                                                          child: ElevatedButton(
                                                                                            onPressed: () {
                                                                                              ShowcaseView.get().next();
                                                                                              controller.selectedIndex.value = 1;
                                                                                            },
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: controller.themeColorServices.primaryBlue.value,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(
                                                                                                  8,
                                                                                                ),
                                                                                              ),
                                                                                              padding: EdgeInsets.symmetric(
                                                                                                horizontal: 16,
                                                                                                vertical: 0,
                                                                                              ),
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                controller.languageServices.language.value.buttonNext1 ??
                                                                                                    "-",
                                                                                                style: controller.typographyServices.bodySmallBold.value.copyWith(
                                                                                                  color: controller.themeColorServices.neutralsColorGrey0.value,
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
                                                                        Routes
                                                                            .HISTORY_BALANCE_ALL,
                                                                      );
                                                                      await controller
                                                                          .refreshAll();
                                                                    },
                                                                    child: Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      child: Column(
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                            "assets/icons/icon_others.svg",
                                                                            width:
                                                                                18,
                                                                            height:
                                                                                18,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          Text(
                                                                            controller.languageServices.language.value.history ??
                                                                                "-",
                                                                            style:
                                                                                controller.typographyServices.captionLargeRegular.value,
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ];
                              },
                              body: Builder(
                                builder: (context) => Obx(
                                  () => SmartRefresher(
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
                                    enablePullUp: false,
                                    onRefresh: () async {
                                      await Future.wait([
                                        controller.getUserInfoDetail(),
                                        controller.getWorking(),
                                      ]);
                                      controller
                                          .orderGrabbingHallRefreshController
                                          .refreshCompleted();
                                    },
                                    // onLoading: () async {
                                    //   await Future.wait([
                                    //     controller.seeMoreOrderGrabbingHallList(),
                                    //   ]);
                                    //   controller.orderGrabbingHallRefreshController
                                    //       .loadComplete();
                                    // },
                                    controller: controller
                                        .orderGrabbingHallRefreshController,
                                    child: CustomScrollView(
                                      slivers: [
                                        SliverOverlapInjector(
                                          handle:
                                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                                context,
                                              ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 16),
                                                if (controller
                                                        .working
                                                        .value
                                                        .id ==
                                                    null) ...[
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
                                                            .noOrderTitle ??
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
                                                            .noOrderAcceptOrderDescription ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallRegular
                                                        .value,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 16),
                                                  SizedBox(
                                                    width: 150,
                                                    child: LoaderElevatedButton(
                                                      child: Text(
                                                        "Refresh",
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
                                                      onPressed: () async {
                                                        await controller
                                                            .getWorking();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                                if (controller
                                                        .working
                                                        .value
                                                        .id !=
                                                    null) ...[
                                                  OrderCardHomeSubView(
                                                    order: Order(
                                                      // name: controller
                                                      //     .working
                                                      //     .value
                                                      //     .name,
                                                      //     historyNum: controller.working.value,
                                                      startAddress: controller
                                                          .working
                                                          .value
                                                          .startAddress,
                                                      endAddress: controller
                                                          .working
                                                          .value
                                                          .endAddress,
                                                      orderMoney: controller
                                                          .working
                                                          .value
                                                          .orderMoney,
                                                      id: controller
                                                          .working
                                                          .value
                                                          .id,
                                                      type: controller
                                                          .working
                                                          .value
                                                          .type,
                                                    ),
                                                  ),
                                                ],
                                                // if (controller
                                                //     .orderGrabbingHallList
                                                //     .isEmpty) ...[
                                                //   SizedBox(height: 16 * 3),
                                                //   SvgPicture.asset(
                                                //     "assets/images/img_history_activity_not_found.svg",
                                                //     height: 80,
                                                //     width: 80,
                                                //   ),
                                                //   SizedBox(height: 16),
                                                //   Text(
                                                //     controller
                                                //             .languageServices
                                                //             .language
                                                //             .value
                                                //             .noOrderTitle ??
                                                //         "-",
                                                //     style: controller
                                                //         .typographyServices
                                                //         .bodyLargeBold
                                                //         .value,
                                                //     textAlign: TextAlign.center,
                                                //   ),
                                                //   SizedBox(height: 8),
                                                //   Text(
                                                //     controller
                                                //             .languageServices
                                                //             .language
                                                //             .value
                                                //             .noOrderAcceptOrderDescription ??
                                                //         "-",
                                                //     style: controller
                                                //         .typographyServices
                                                //         .bodySmallRegular
                                                //         .value,
                                                //     textAlign: TextAlign.center,
                                                //   ),
                                                // ],
                                                // for (var orderGrabbingHall
                                                //     in controller
                                                //         .orderGrabbingHallList) ...[
                                                //   OrderCardHomeSubView(
                                                //     order: orderGrabbingHall,
                                                //   ),
                                                //   SizedBox(height: 16),
                                                // ],
                                                SizedBox(height: 16),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (controller
                                    .isActiveGuaranteeIncomeProgressBarOpen
                                    .value ==
                                true) ...[
                              Positioned(
                                top: 40 + 16,
                                left: 16,
                                right: 16,
                                child:
                                    HomeGuaranteeIncomeProgressBarCardFullScreenSubView(),
                              ),
                            ],
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
                        onTap: () async {
                          await Get.bottomSheet(
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
                                                  controller
                                                          .languageServices
                                                          .language
                                                          .value
                                                          .status ??
                                                      "-",
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  controller
                                                          .languageServices
                                                          .language
                                                          .value
                                                          .currentStatus ??
                                                      "-",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallBold
                                                      .value,
                                                ),
                                                AnimatedToggleSwitch<int>.dual(
                                                  current: controller
                                                      .workStatus
                                                      .value,
                                                  first: 2,
                                                  second: 1,
                                                  height: 50,
                                                  borderWidth: 0,
                                                  customIconBuilder:
                                                      (context, local, global) {
                                                        if (local.value == 2) {
                                                          return CircleAvatar(
                                                            backgroundColor:
                                                                Color(
                                                                  0XFF999898,
                                                                ),
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
                                                          backgroundColor:
                                                              Color(0XFF37C086),
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
                                                                Color(
                                                                  0XFFCECECE,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  9999,
                                                                ),
                                                            indicatorColor:
                                                                Colors
                                                                    .transparent,
                                                          );
                                                        }
                                                        return ToggleStyle(
                                                          backgroundColor:
                                                              Color(0XFF1FF79B),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                9999,
                                                              ),
                                                          indicatorColor: Colors
                                                              .transparent,
                                                        );
                                                      },
                                                  onChanged: (value) async {
                                                    await controller
                                                        .onSwitchStatusWork();
                                                  },
                                                  customTextBuilder: (context, local, global) {
                                                    return Text(
                                                      local.value == 2
                                                          ? controller
                                                                    .languageServices
                                                                    .language
                                                                    .value
                                                                    .offline ??
                                                                "-"
                                                          : controller
                                                                    .languageServices
                                                                    .language
                                                                    .value
                                                                    .online ??
                                                                "-",
                                                      style: controller
                                                          .typographyServices
                                                          .bodyLargeBold
                                                          .value
                                                          .copyWith(
                                                            color:
                                                                local.value == 2
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
                                                  controller
                                                          .languageServices
                                                          .language
                                                          .value
                                                          .yourTotalOrder ??
                                                      "-",
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
                                                              controller
                                                                      .languageServices
                                                                      .language
                                                                      .value
                                                                      .homeOrderToday ??
                                                                  "-",
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
                                                              "${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(controller.vehicleStatistics.value.dayNum ?? 0)} ${controller.languageServices.language.value.order ?? "-"}",
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
                                                              controller
                                                                      .languageServices
                                                                      .language
                                                                      .value
                                                                      .homeOrderThisMonth ??
                                                                  "-",
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
                                                              "${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(controller.vehicleStatistics.value.mouthNum ?? 0)} ${controller.languageServices.language.value.order ?? "-"}",
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
                                            padding: EdgeInsetsGeometry.only(
                                              left: 16,
                                              right: 16,
                                              top: 16,
                                              bottom: 8,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller
                                                          .languageServices
                                                          .language
                                                          .value
                                                          .selectService ??
                                                      "-",
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
                                                      controller
                                                          .serviceOrderList
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
                                                              ? Color(
                                                                  0XFFB3B3B3,
                                                                )
                                                              : Color(
                                                                  0XFFE8E8E8,
                                                                ),
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
                                                                          ? controller.themeColorServices.textColor.value
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
                                          if (controller
                                                  .errorInfoBottomSheet
                                                  .value !=
                                              "") ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      controller
                                                          .errorInfoBottomSheet
                                                          .value,
                                                      style: controller
                                                          .typographyServices
                                                          .captionLargeRegular
                                                          .value
                                                          .copyWith(
                                                            color: controller
                                                                .themeColorServices
                                                                .redColor
                                                                .value,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                          ],
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: LoaderElevatedButton(
                                              onPressed: () async {
                                                await controller
                                                    .onTapSaveServiceOrder();
                                              },
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .save ??
                                                    "-",
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
                                          SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          controller.errorInfoBottomSheet.value = "";
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
                                onTap: () async {
                                  controller.selectedIndex.value = 0;
                                  await controller.refreshAll();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              controller.selectedIndex.value ==
                                                      0
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
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .home ??
                                            "-",
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
                                    key:
                                        controller.buttonOfflineOnlineGlobalKey,
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
                                                    controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .coachmarkTitle3 ??
                                                        "-",
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
                                                    controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .coachmarkDescription3 ??
                                                        "-",
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
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 0,
                                                                ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              controller
                                                                      .languageServices
                                                                      .language
                                                                      .value
                                                                      .buttonNext1 ??
                                                                  "-",
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
                                              backgroundColor: Color(
                                                0XFF37C086,
                                              ),
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
                                              backgroundColor: Color(
                                                0XFF1FF79B,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(9999),
                                              indicatorColor:
                                                  Colors.transparent,
                                            );
                                          },
                                      onChanged: (value) async {
                                        await controller.onSwitchStatusWork();
                                      },
                                      customTextBuilder:
                                          (context, local, global) {
                                            return Text(
                                              local.value == 2
                                                  ? controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .offline ??
                                                        "-"
                                                  : controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .online ??
                                                        "-",
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
                                onTap: () async {
                                  controller.selectedIndex.value = 1;
                                  await controller.refreshAll();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .coachmarkTitle8 ??
                                                            "-",
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
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .coachmarkDescription8 ??
                                                            "-",
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
                                                                      vertical:
                                                                          0,
                                                                    ),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  controller
                                                                          .languageServices
                                                                          .language
                                                                          .value
                                                                          .coachmarkButton8 ??
                                                                      "-",
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
                                              controller
                                                      .languageServices
                                                      .language
                                                      .value
                                                      .menu ??
                                                  "-",
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
      ),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _PinnedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return false;
  }
}
