import 'dart:async';

import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_user_model.dart';
import 'package:new_evmoto_driver/app/data/models/socket_order_status_data_model.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MyOrderV2Controller extends GetxController
    with GetSingleTickerProviderStateMixin {
  final OrderRepository orderRepository;

  MyOrderV2Controller({required this.orderRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  TabController? tabController;

  final allOrderRefreshController = RefreshController();
  final allOrderList = <Order>[].obs;
  final allOrderPageNum = 1.obs;
  final isSeeMoreAllOrder = true.obs;

  final toBePaidRefreshController = RefreshController();
  final toBePaidList = <Order>[].obs;
  final toBePaidPageNum = 1.obs;
  final isSeeMoreToBePaid = true.obs;

  final cancelOrderRefreshController = RefreshController();
  final cancelOrderList = <Order>[].obs;
  final cancelOrderPageNum = 1.obs;
  final isSeeMoreCancelOrder = true.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController ??= TabController(length: 3, vsync: this);
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> showDialogAdvancedBookingConfirmation({
    required SocketOrderStatusData socketOrderStatusData,
  }) async {
    var orderData = OrderDetail(
      startLat: -6.1744651,
      endLat: 106.822745,
      startLon: -6.1744651,
      endLon: 106.822745,
      startMileage: 11.11,
    );
    var orderUserData = OrderUser();

    // var orderData = await orderRepository.getOrderDetail(
    //   orderType: socketOrderStatusData.orderType!,
    //   orderId: socketOrderStatusData.orderId.toString(),
    //   language: languageServices.languageCodeSystem.value,
    // );
    // var orderUserData = await orderRepository.getOrderUserDetail(
    //   orderType: socketOrderStatusData.orderType!,
    //   orderId: socketOrderStatusData.orderId.toString(),
    // );

    var initialCameraPosition = CameraPosition(
      target: LatLng(orderData.startLat!, orderData.startLon!),
      zoom: 18,
    ).obs;

    var markers = <Marker>{}.obs;
    var newMarkers = Marker(
      markerId: MarkerId("pinpoint"),
      position: LatLng(orderData.startLat!, orderData.startLon!),
    );
    markers.add(newMarkers);

    final durationAccept = 0.obs;
    durationAccept.value = socketOrderStatusData.time ?? 0;

    late Timer timerDuration;
    timerDuration = Timer.periodic(Duration(seconds: 1), (timer) async {
      durationAccept.value -= 1;
      if (durationAccept.value == 0) {
        timerDuration.cancel();
        Get.close(1);
      }
    });

    var result = await Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(color: Color(0XFFEA7405)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Konfirmasi Pesanan Terjadwal",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                              ),
                              Text(
                                "Kamis, 21 Mei 2026 · 10:05",
                                style: typographyServices.bodySmallRegular.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              Get.back(result: true);
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_close.svg",
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_passenger.svg",
                                      width: 11.7,
                                      height: 14.17,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Franky Fransisco Marlissa",
                                      style: typographyServices
                                          .bodyLargeRegular
                                          .value
                                          .copyWith(
                                            color: themeColorServices
                                                .textColor
                                                .value,
                                          ),
                                    ),
                                    // Text(
                                    //   "(${orderData.historyNum})",
                                    //   style: typographyServices
                                    //       .bodySmallRegular
                                    //       .value
                                    //       .copyWith(
                                    //         color: themeColorServices
                                    //             .textColor
                                    //             .value,
                                    //       ),
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     SvgPicture.asset(
                                    //       "assets/icons/icon_star.svg",
                                    //       width: 9.17,
                                    //       height: 10,
                                    //       color: themeColorServices
                                    //           .sematicColorYellow400
                                    //           .value,
                                    //     ),
                                    //     SizedBox(width: 4),
                                    //     Text(
                                    //       "5.0 (0)",
                                    //       style: typographyServices
                                    //           .bodySmallRegular
                                    //           .value
                                    //           .copyWith(
                                    //             color: themeColorServices
                                    //                 .textColor
                                    //                 .value,
                                    //           ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_card_origin.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      languageServices
                                              .language
                                              .value
                                              .pickedUp ??
                                          "-",
                                      style: typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: themeColorServices
                                                .imageUploadVerticalDividerColor
                                                .value,
                                          ),
                                    ),
                                    Text(
                                      "Jl. Wijaya I No.67, RT.6/RW.4, Petogogan, Kec. Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12160",
                                      style: typographyServices
                                          .bodyLargeRegular
                                          .value
                                          .copyWith(
                                            color: themeColorServices
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_card_destination.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      languageServices
                                              .language
                                              .value
                                              .destinationLocation ??
                                          "-",
                                      style: typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: themeColorServices
                                                .imageUploadVerticalDividerColor
                                                .value,
                                          ),
                                    ),
                                    Text(
                                      "Jl. Raya Pd. Gede, RT.001/RW.001, Jatiwaringin, Kec. Pd. Gede, Kota Bks, Jawa Barat 17411",
                                      style: typographyServices
                                          .bodyLargeRegular
                                          .value
                                          .copyWith(
                                            color: themeColorServices
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
                          Divider(color: Color(0XFFE7E7E7), height: 0),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Biaya",
                                style: typographyServices.bodySmallRegular.value
                                    .copyWith(
                                      color: themeColorServices
                                          .imageUploadVerticalDividerColor
                                          .value,
                                    ),
                              ),
                              Text(
                                "Rp110.000",
                                style: typographyServices.headingSmallBold.value
                                    .copyWith(
                                      color: themeColorServices.textColor.value,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                              aspectRatio: 298 / 75,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                zoomControlsEnabled: true,
                                tiltGesturesEnabled: true,
                                zoomGesturesEnabled: true,
                                rotateGesturesEnabled: true,
                                scrollGesturesEnabled: true,
                                initialCameraPosition:
                                    initialCameraPosition.value,
                                onMapCreated:
                                    (GoogleMapController googleMapController) {
                                      googleMapController = googleMapController;
                                    },
                                markers: markers,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: Get.width,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeColorServices.neutralsColorGrey0.value,
                        boxShadow: [
                          BoxShadow(
                            color: themeColorServices.overlayDark200.value
                                .withValues(alpha: 0.05),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ActionSlider.custom(
                            height: 60,
                            action: (actionController) async {
                              // await onSlideOrderConfirmation(
                              //   actionController: actionController,
                              //   socketOrderStatusData: socketOrderStatusData,
                              // );
                            },
                            toggleMargin: EdgeInsetsGeometry.all(0),
                            outerBackgroundBuilder: (context, state, child) {
                              return Container(color: Colors.transparent);
                            },
                            foregroundBuilder: (context, state, child) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                padding: const EdgeInsets.all(8.0),
                                child: state.status == SliderStatus.loading()
                                    ? CircleAvatar(
                                        backgroundColor: themeColorServices
                                            .primaryBlue
                                            .value,
                                        child: Center(
                                          child: SizedBox(
                                            width: 24.5,
                                            height: 24.5,
                                            child: CircularProgressIndicator(
                                              color: themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                            ),
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: state.position >= 0.5
                                            ? Color(0XFF2579D4)
                                            : themeColorServices
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
                              if (state.status == SliderStatus.loading()) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color(0XFF2F8AEC),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                );
                              }

                              return AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                height: 60,
                                decoration: BoxDecoration(
                                  color: state.position >= 0.5
                                      ? Color(0XFF2F8AEC)
                                      : Color(0XFFF1F1F1),
                                  borderRadius: BorderRadius.circular(9999),
                                  border: Border.all(
                                    color: state.position >= 0.5
                                        ? Color(0XFF0060C6)
                                        : themeColorServices
                                              .neutralsColorGrey300
                                              .value,
                                    width: state.position >= 0.5 ? 5 : 1,
                                  ),
                                ),
                                padding: EdgeInsets.only(right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (state.position < 0.5) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 55),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Swipe untuk mendapatkan orderan",
                                                  style: typographyServices
                                                      .bodyLargeRegular
                                                      .value
                                                      .copyWith(
                                                        color: themeColorServices
                                                            .neutralsColorGrey400
                                                            .value,
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Obx(
                                                  () => Text(
                                                    "(${durationAccept.value}s)",
                                                    style: typographyServices
                                                        .bodyLargeBold
                                                        .value
                                                        .copyWith(
                                                          color:
                                                              themeColorServices
                                                                  .primaryBlue
                                                                  .value,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (state.position >= 0.5) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Orderan sudah diambil",
                                            style: typographyServices
                                                .bodyLargeRegular
                                                .value
                                                .copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 46,
                            width: MediaQuery.of(
                              navigatorKey.currentContext!,
                            ).size.width,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0XFFE54C3F)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () async {
                                Get.close(1);
                                await onTapCancelOrder();
                              },
                              child: Text(
                                languageServices.language.value.cancel ?? "-",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(color: Color(0XFFE54C3F)),
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
          ),
        ],
      ),
    );

    if (result != true) {}

    try {
      timerDuration.cancel();
    } catch (e) {}
  }

  Future<void> onTapCancelOrder() async {
    Get.dialog(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Apakah Anda yakin ingin membatalkan pesanan?",
                        style: typographyServices.bodyLargeBold.value,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              width: Get.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: themeColorServices
                                        .neutralsColorGrey300
                                        .value,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  Get.close(1);
                                },
                                child: Text(
                                  "Tutup",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              width: MediaQuery.of(
                                navigatorKey.currentContext!,
                              ).size.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Color(0XFFE54C3F)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    // await orderRepository.cancelOrder(
                                    //   orderType: orderType.value,
                                    //   orderId: orderId.value,
                                    //   language: languageServices
                                    //       .languageCodeSystem
                                    //       .value,
                                    // );
                                    // Get.close(1);
                                    // Get.back();
                                    // Get.find<HomeController>().refreshAll();

                                    SnackbarHelper.showSnackbarSuccess(
                                      text: "Berhasil membatalkan pesanan",
                                    );
                                  } catch (e) {
                                    SnackbarHelper.showSnackbarError(
                                      text: e.toString(),
                                    );
                                  }
                                },
                                child: Text(
                                  languageServices.language.value.cancel ?? "-",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(color: Color(0XFFE54C3F)),
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
            ),
          ],
        ),
      ),
    );
  }
}
