import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/utils/location_helper.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: controller.isLocationReadyStatus.value == true
            ? null
            : AppBar(
                backgroundColor:
                    controller.themeColorServices.neutralsColorGrey0.value,
                surfaceTintColor:
                    controller.themeColorServices.neutralsColorGrey0.value,
              ),
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
                  if (controller.isLocationReadyStatus.value == false) ...[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/img_location_required_2.png",
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Persetujuan Akses Lokasi",
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Lokasi digunakan untuk menampilkan fitur dan layanan berdasarkan posisi Anda saat ini.",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          LoaderElevatedButton(
                            onPressed: () async {
                              await checkAndEnableLocation();
                              controller.isLocationReadyStatus.value =
                                  await isLocationReady();
                              if (controller.isLocationReadyStatus.value ==
                                  true) {
                                await controller.onInit();
                              }
                            },
                            borderSide: BorderSide(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                            child: Text(
                              "Aktifkan Lokasi",
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
                    ),
                  ],
                  if (controller.isLocationReadyStatus.value == true) ...[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition:
                            controller.initialCameraPosition.value,
                        onMapCreated:
                            (GoogleMapController googleMapController) {
                              controller.googleMapController =
                                  googleMapController;
                            },
                        markers: controller.markers,
                        polylines: controller.polylines,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                      borderRadius: BorderRadius.circular(9999),
                                      boxShadow: [
                                        BoxShadow(
                                          color: controller
                                              .themeColorServices
                                              .overlayDark200
                                              .value
                                              .withValues(alpha: 0.3),
                                          blurRadius: 32,
                                          spreadRadius: -6,
                                          offset: Offset(0, -1),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_arrow_left.svg",
                                          width: 22,
                                          height: 22,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey300
                                                .value,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller
                                                  .orderDetail
                                                  .value
                                                  .nickName
                                                  .toString(),
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallRegular
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFFB3B3B3),
                                                  ),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 16,
                                                            height: 16,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  "assets/icons/icon_passenger.svg",
                                                                  width: 11.7,
                                                                  height: 14.17,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 4),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                controller
                                                                        .orderDetail
                                                                        .value
                                                                        .user ??
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
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 16,
                                                                    height: 16,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          "assets/icons/icon_star.svg",
                                                                          width:
                                                                              15,
                                                                          height:
                                                                              15,
                                                                          color: controller
                                                                              .themeColorServices
                                                                              .sematicColorYellow400
                                                                              .value,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    "5.0 (0)",
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
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        Get.toNamed(
                                                          Routes.ORDER_CALL,
                                                          arguments: {
                                                            "call_type":
                                                                "caller",
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 34,
                                                        height: 34,
                                                        decoration: BoxDecoration(
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
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
                                                              "assets/icons/icon_call.svg",
                                                              width: 21.15,
                                                              height: 21.15,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed(
                                                          Routes.ORDER_CHAT,
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 34,
                                                        height: 34,
                                                        decoration: BoxDecoration(
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
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
                                                              "assets/icons/icon_bubble_chat_2.svg",
                                                              width: 21.15,
                                                              height: 21.15,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                          border: Border.all(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey300
                                                .value,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                controller
                                                    .isInformationShow
                                                    .value = !controller
                                                    .isInformationShow
                                                    .value;
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                padding: EdgeInsets.all(12),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/icon_clock.svg",
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      controller
                                                              .orderDetail
                                                              .value
                                                              .travelTime ??
                                                          "-",
                                                      style: controller
                                                          .typographyServices
                                                          .bodySmallRegular
                                                          .value,
                                                    ),
                                                    Spacer(),
                                                    SvgPicture.asset(
                                                      controller
                                                              .isInformationShow
                                                              .value
                                                          ? "assets/icons/icon_arrow_down.svg"
                                                          : "assets/icons/icon_arrow_up.svg",
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (controller
                                                .isInformationShow
                                                .value) ...[
                                              Divider(
                                                height: 0,
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey300
                                                    .value,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(12),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/icon_card_origin.svg",
                                                          width: 18,
                                                          height: 18,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Expanded(
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
                                                                        .pickedUp ??
                                                                    "-",
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
                                                                controller
                                                                        .orderDetail
                                                                        .value
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
                                                          "assets/icons/icon_card_destination.svg",
                                                          width: 18,
                                                          height: 18,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Expanded(
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
                                                                        .destinationLocation ??
                                                                    "-",
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
                                                                controller
                                                                        .orderDetail
                                                                        .value
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
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await controller.onTapOpenGoogleMaps();
                                      },
                                      child: Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                          border: Border.all(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey300
                                                .value,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_navigation.svg",
                                              width: 21.15,
                                              height: 21.15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        await controller.onTapRefocus();
                                      },
                                      child: Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                          border: Border.all(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey300
                                                .value,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_gps.svg",
                                              width: 21.15,
                                              height: 21.15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await controller.onTapCallEmergency();
                                      },
                                      child: Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                          border: Border.all(
                                            color: Color(0XFFFB958C),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/icon_emergency.png",
                                              width: 17,
                                              height: 17,
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
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (controller.orderDetail.value.state ==
                                    1) ...[
                                  ActionSlider.custom(
                                    height: 60,
                                    action: (actionController) async {
                                      actionController.loading();
                                      await controller.updateStateGrabOrder();
                                      actionController.success();
                                      actionController.reset();
                                    },
                                    toggleMargin: EdgeInsetsGeometry.all(0),
                                    outerBackgroundBuilder:
                                        (context, state, child) {
                                          return Container(
                                            color: Colors.transparent,
                                          );
                                        },
                                    foregroundBuilder: (context, state, child) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            state.status ==
                                                SliderStatus.loading()
                                            ? CircleAvatar(
                                                backgroundColor: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 24.5,
                                                    height: 24.5,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey0
                                                              .value,
                                                        ),
                                                  ),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundColor:
                                                    state.position >= 0.5
                                                    ? Color(0XFF2579D4)
                                                    : controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value,
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/icon_arrow_slide_right.svg",
                                                    width: 24.5,
                                                    height: 24.5,
                                                  ),
                                                ),
                                              ),
                                      );
                                    },
                                    backgroundBuilder: (context, state, child) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: state.position >= 0.5
                                              ? Color(0XFF2F8AEC)
                                              : Color(0XFFF1F1F1),
                                          borderRadius: BorderRadius.circular(
                                            9999,
                                          ),
                                          border: Border.all(
                                            color: state.position >= 0.5
                                                ? Color(0XFF0573EA)
                                                : controller
                                                      .themeColorServices
                                                      .neutralsColorGrey300
                                                      .value,
                                            width: state.position >= 0.5
                                                ? 5
                                                : 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              state.position >= 0.5
                                                  ? "Orderan sudah diambil"
                                                  : "Swipe untuk mulai orderan",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: state.position >= 0.5
                                                        ? Colors.white
                                                        : controller
                                                              .themeColorServices
                                                              .neutralsColorGrey400
                                                              .value,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                if (controller.orderDetail.value.state ==
                                    2) ...[
                                  ActionSlider.custom(
                                    height: 60,
                                    action: (actionController) async {
                                      actionController.loading();
                                      await controller
                                          .updateStateStartOrderTrip();
                                      actionController.success();
                                      actionController.reset();
                                    },
                                    toggleMargin: EdgeInsetsGeometry.all(0),
                                    outerBackgroundBuilder:
                                        (context, state, child) {
                                          return Container(
                                            color: Colors.transparent,
                                          );
                                        },
                                    foregroundBuilder: (context, state, child) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            state.status ==
                                                SliderStatus.loading()
                                            ? CircleAvatar(
                                                backgroundColor: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 24.5,
                                                    height: 24.5,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey0
                                                              .value,
                                                        ),
                                                  ),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundColor:
                                                    state.position >= 0.5
                                                    ? Color(0XFF2579D4)
                                                    : controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value,
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/icon_arrow_slide_right.svg",
                                                    width: 24.5,
                                                    height: 24.5,
                                                  ),
                                                ),
                                              ),
                                      );
                                    },
                                    backgroundBuilder: (context, state, child) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: state.position >= 0.5
                                              ? Color(0XFF2F8AEC)
                                              : Color(0XFFF1F1F1),
                                          borderRadius: BorderRadius.circular(
                                            9999,
                                          ),
                                          border: Border.all(
                                            color: state.position >= 0.5
                                                ? Color(0XFF0573EA)
                                                : controller
                                                      .themeColorServices
                                                      .neutralsColorGrey300
                                                      .value,
                                            width: state.position >= 0.5
                                                ? 5
                                                : 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              state.position >= 0.5
                                                  ? controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .pickingUp ??
                                                        "-"
                                                  : controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .departToPickup ??
                                                        "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: state.position >= 0.5
                                                        ? Colors.white
                                                        : controller
                                                              .themeColorServices
                                                              .neutralsColorGrey400
                                                              .value,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                if (controller.orderDetail.value.state ==
                                    3) ...[
                                  ActionSlider.custom(
                                    height: 60,
                                    action: (actionController) async {
                                      actionController.loading();
                                      await controller
                                          .updateStateArrivedOrigin();
                                      actionController.success();
                                      actionController.reset();
                                    },
                                    toggleMargin: EdgeInsetsGeometry.all(0),
                                    outerBackgroundBuilder:
                                        (context, state, child) {
                                          return Container(
                                            color: Colors.transparent,
                                          );
                                        },
                                    foregroundBuilder: (context, state, child) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            state.status ==
                                                SliderStatus.loading()
                                            ? CircleAvatar(
                                                backgroundColor: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 24.5,
                                                    height: 24.5,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey0
                                                              .value,
                                                        ),
                                                  ),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundColor:
                                                    state.position >= 0.5
                                                    ? Color(0XFF2579D4)
                                                    : controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value,
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/icon_arrow_slide_right.svg",
                                                    width: 24.5,
                                                    height: 24.5,
                                                  ),
                                                ),
                                              ),
                                      );
                                    },
                                    backgroundBuilder: (context, state, child) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: state.position >= 0.5
                                              ? Color(0XFF2F8AEC)
                                              : Color(0XFFF1F1F1),
                                          borderRadius: BorderRadius.circular(
                                            9999,
                                          ),
                                          border: Border.all(
                                            color: state.position >= 0.5
                                                ? Color(0XFF0573EA)
                                                : controller
                                                      .themeColorServices
                                                      .neutralsColorGrey300
                                                      .value,
                                            width: state.position >= 0.5
                                                ? 5
                                                : 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              state.position >= 0.5
                                                  ? controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .arriveAtThePickUpLocation ??
                                                        "-"
                                                  : controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .arriveAtThePickUpLocation ??
                                                        "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: state.position >= 0.5
                                                        ? Colors.white
                                                        : controller
                                                              .themeColorServices
                                                              .neutralsColorGrey400
                                                              .value,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                if (controller.orderDetail.value.state ==
                                    4) ...[
                                  ActionSlider.custom(
                                    height: 60,
                                    action: (actionController) async {
                                      actionController.loading();
                                      await controller.updateStateOnProgress();
                                      actionController.success();
                                      actionController.reset();
                                    },
                                    toggleMargin: EdgeInsetsGeometry.all(0),
                                    outerBackgroundBuilder:
                                        (context, state, child) {
                                          return Container(
                                            color: Colors.transparent,
                                          );
                                        },
                                    foregroundBuilder: (context, state, child) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            state.status ==
                                                SliderStatus.loading()
                                            ? CircleAvatar(
                                                backgroundColor: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 24.5,
                                                    height: 24.5,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey0
                                                              .value,
                                                        ),
                                                  ),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundColor:
                                                    state.position >= 0.5
                                                    ? Color(0XFF2579D4)
                                                    : controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value,
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/icon_arrow_slide_right.svg",
                                                    width: 24.5,
                                                    height: 24.5,
                                                  ),
                                                ),
                                              ),
                                      );
                                    },
                                    backgroundBuilder: (context, state, child) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: state.position >= 0.5
                                              ? Color(0XFF2F8AEC)
                                              : Color(0XFFF1F1F1),
                                          borderRadius: BorderRadius.circular(
                                            9999,
                                          ),
                                          border: Border.all(
                                            color: state.position >= 0.5
                                                ? Color(0XFF0573EA)
                                                : controller
                                                      .themeColorServices
                                                      .neutralsColorGrey300
                                                      .value,
                                            width: state.position >= 0.5
                                                ? 5
                                                : 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              state.position >= 0.5
                                                  ? controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .delivering ??
                                                        "-"
                                                  : controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .deliveringPassengers ??
                                                        "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: state.position >= 0.5
                                                        ? Colors.white
                                                        : controller
                                                              .themeColorServices
                                                              .neutralsColorGrey400
                                                              .value,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                if (controller.orderDetail.value.state ==
                                    5) ...[
                                  ActionSlider.custom(
                                    height: 60,
                                    action: (actionController) async {
                                      actionController.loading();
                                      await controller
                                          .updateStateArrivedAtDestination();
                                      actionController.success();
                                      actionController.reset();
                                    },
                                    toggleMargin: EdgeInsetsGeometry.all(0),
                                    outerBackgroundBuilder:
                                        (context, state, child) {
                                          return Container(
                                            color: Colors.transparent,
                                          );
                                        },
                                    foregroundBuilder: (context, state, child) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            state.status ==
                                                SliderStatus.loading()
                                            ? CircleAvatar(
                                                backgroundColor: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 24.5,
                                                    height: 24.5,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey0
                                                              .value,
                                                        ),
                                                  ),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundColor:
                                                    state.position >= 0.5
                                                    ? Color(0XFF2579D4)
                                                    : controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value,
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/icon_arrow_slide_right.svg",
                                                    width: 24.5,
                                                    height: 24.5,
                                                  ),
                                                ),
                                              ),
                                      );
                                    },
                                    backgroundBuilder: (context, state, child) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: state.position >= 0.5
                                              ? Color(0XFF2F8AEC)
                                              : Color(0XFFF1F1F1),
                                          borderRadius: BorderRadius.circular(
                                            9999,
                                          ),
                                          border: Border.all(
                                            color: state.position >= 0.5
                                                ? Color(0XFF0573EA)
                                                : controller
                                                      .themeColorServices
                                                      .neutralsColorGrey300
                                                      .value,
                                            width: state.position >= 0.5
                                                ? 5
                                                : 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              state.position >= 0.5
                                                  ? controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .finishedDroppingOffPassenger ??
                                                        "-"
                                                  : controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .finishedDroppingOffPassenger ??
                                                        "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: state.position >= 0.5
                                                        ? Colors.white
                                                        : controller
                                                              .themeColorServices
                                                              .neutralsColorGrey400
                                                              .value,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                SizedBox(height: 16),
                                SizedBox(
                                  height: 46,
                                  width: MediaQuery.of(context).size.width,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey300
                                            .value,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await controller.onTapCancelOrder();
                                    },
                                    child: Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .cancel ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey400
                                                .value,
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
                  ],
                ],
              ),
      ),
    );
  }
}
