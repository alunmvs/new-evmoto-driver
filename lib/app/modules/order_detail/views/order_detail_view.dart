import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/modules/order_detail/views/order_detail_view/order_detail_footer_sub_view.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/utils/general_helper.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: controller.isFetch.value == false,
        child: Scaffold(
          appBar:
              controller.locationServices.isPermissionLocationAllow.value ==
                  true
              ? null
              : AppBar(
                  backgroundColor:
                      controller.themeColorServices.neutralsColorGrey0.value,
                  surfaceTintColor:
                      controller.themeColorServices.neutralsColorGrey0.value,
                ),
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              if (controller.locationServices.isPermissionLocationAllow.value ==
                  false) ...[
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
                        style:
                            controller.typographyServices.bodyLargeBold.value,
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
                          // await checkAndEnableLocation();
                          // controller.locationServices.isPermissionLocationAllow.value =
                          //     await isLocationReady();
                          if (controller
                                  .locationServices
                                  .isPermissionLocationAllow
                                  .value ==
                              true) {
                            await controller.onInit();
                          }
                        },
                        borderSide: BorderSide(
                          color:
                              controller.themeColorServices.primaryBlue.value,
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
              if (controller.locationServices.isPermissionLocationAllow.value ==
                  true) ...[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition:
                        controller.initialCameraPosition.value,
                    onMapCreated: (GoogleMapController googleMapController) {
                      controller.googleMapController = googleMapController;
                    },
                    markers: controller.markers,
                    polylines: controller.polylines,
                  ),
                ),
                if (controller.isFetch.value == false) ...[
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                        borderRadius: BorderRadius.circular(8),
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
                                          // Text(
                                          //   controller
                                          //       .orderDetail
                                          //       .value
                                          //       .nickName
                                          //       .toString(),
                                          //   style: controller
                                          //       .typographyServices
                                          //       .bodySmallRegular
                                          //       .value
                                          //       .copyWith(
                                          //         color: Color(0XFFB3B3B3),
                                          //       ),
                                          // ),
                                          // SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                                      .orderUser
                                                                      .value
                                                                      .name ??
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
                                                            SizedBox(height: 2),
                                                            Text(
                                                              "${controller.getStatusOnGoing()} • ${formatDoubleToString(controller.getKmOnGoing())} km",
                                                              style: controller
                                                                  .typographyServices
                                                                  .captionLargeRegular
                                                                  .value
                                                                  .copyWith(
                                                                    color: Color(
                                                                      0XFF7D7D7D,
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
                                              SizedBox(width: 12),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // GestureDetector(
                                                  //   onTap: () async {
                                                  //     Get.toNamed(
                                                  //       Routes.ORDER_CALL,
                                                  //       arguments: {
                                                  //         "call_type": "caller",
                                                  //       },
                                                  //     );
                                                  //   },
                                                  //   child: Container(
                                                  //     width: 34,
                                                  //     height: 34,
                                                  //     decoration: BoxDecoration(
                                                  //       color: controller
                                                  //           .themeColorServices
                                                  //           .primaryBlue
                                                  //           .value,
                                                  //       borderRadius:
                                                  //           BorderRadius.circular(
                                                  //             8,
                                                  //           ),
                                                  //     ),
                                                  //     child: Row(
                                                  //       mainAxisAlignment:
                                                  //           MainAxisAlignment
                                                  //               .center,
                                                  //       crossAxisAlignment:
                                                  //           CrossAxisAlignment
                                                  //               .center,
                                                  //       children: [
                                                  //         SvgPicture.asset(
                                                  //           "assets/icons/icon_call.svg",
                                                  //           width: 21.15,
                                                  //           height: 21.15,
                                                  //         ),
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // SizedBox(width: 8),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                        Routes.CHAT_DETAIL,
                                                        arguments: {
                                                          "doc_id": controller
                                                              .evmotoOrderChatParticipants
                                                              .value
                                                              .docId,
                                                        },
                                                      );
                                                    },
                                                    child: Badge(
                                                      isLabelVisible:
                                                          (controller
                                                                  .evmotoOrderChatParticipants
                                                                  .value
                                                                  .totalUnreadChatUser ??
                                                              0) >
                                                          0,
                                                      label: Text(
                                                        (controller
                                                                        .evmotoOrderChatParticipants
                                                                        .value
                                                                        .totalUnreadChatUser ??
                                                                    0) >
                                                                99
                                                            ? "99+"
                                                            : (controller
                                                                          .evmotoOrderChatParticipants
                                                                          .value
                                                                          .totalUnreadChatUser ??
                                                                      0)
                                                                  .toString(),
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value,
                                                      ),
                                                      backgroundColor: controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value,
                                                      child: Container(
                                                        width: 34,
                                                        height: 34,
                                                        decoration: BoxDecoration(
                                                          color: Color(
                                                            0XFFE6E6E6,
                                                          ),
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
                                                              color: Color(
                                                                0XFF7D7D7D,
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
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                        borderRadius: BorderRadius.circular(8),
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
                                              color: Color(0XFFE2E2E2),
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
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 16),
                                                  Divider(
                                                    height: 0,
                                                    color: Color(0XFFE2E2E2),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Total Biaya",
                                                        style: controller
                                                            .typographyServices
                                                            .bodySmallRegular
                                                            .value,
                                                      ),
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'id_ID',
                                                          symbol: 'Rp',
                                                          decimalDigits: 0,
                                                        ).format(
                                                          controller
                                                              .orderDetail
                                                              .value
                                                              .orderMoney,
                                                        ),
                                                        style: controller
                                                            .typographyServices
                                                            .bodyLargeBold
                                                            .value
                                                            .copyWith(
                                                              fontSize: 18,
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
                    child: OrderDetailFooterSubView(),
                  ),
                ],
                if (controller.isFetch.value) ...[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    child: Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color:
                              controller.themeColorServices.primaryBlue.value,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
