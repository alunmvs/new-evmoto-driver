import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/common_helper.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_driver/app/widgets/advance_booking_cancel_dialog_widget.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final OrderRepository orderRepository;
  final AdvanceBookingRepository advanceBookingRepository;

  MyOrderController({
    required this.orderRepository,
    required this.advanceBookingRepository,
  });

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
    await refreshAll();
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

  Future<void> refreshAll() async {
    await Future.wait([
      getAllOrderList(),
      getToBePaidList(),
      getCancelOrderList(),
    ]);
  }

  Future<void> getAllOrderList() async {
    isSeeMoreAllOrder.value = true;
    allOrderPageNum.value = 1;

    allOrderList.value = (await orderRepository.getHistoryOrderListV2(
      size: 10,
      language: languageServices.languageCodeSystem.value,
      state: 1,
      pageNum: allOrderPageNum.value,
    ));

    if (allOrderList.isEmpty) {
      isSeeMoreAllOrder.value = false;
    }
  }

  Future<void> seeMoreAllOrderList() async {
    if (isSeeMoreAllOrder.value == true) {
      allOrderPageNum.value += 1;

      var allOrderList = (await orderRepository.getHistoryOrderListV2(
        size: 10,
        language: languageServices.languageCodeSystem.value,
        state: 1,
        pageNum: allOrderPageNum.value,
      ));

      this.allOrderList.addAll(allOrderList);

      if (allOrderList.isEmpty) {
        isSeeMoreAllOrder.value = false;
      }
    }
  }

  Future<void> getToBePaidList() async {
    isSeeMoreToBePaid.value = true;
    toBePaidPageNum.value = 1;

    toBePaidList.value = (await orderRepository.getHistoryOrderListV2(
      size: 10,
      language: languageServices.languageCodeSystem.value,
      state: 2,
      pageNum: toBePaidPageNum.value,
    ));

    if (toBePaidList.isEmpty) {
      isSeeMoreToBePaid.value = false;
    }
  }

  Future<void> seeMoreToBePaidList() async {
    if (isSeeMoreToBePaid.value == true) {
      toBePaidPageNum.value += 1;

      var toBePaidList = (await orderRepository.getHistoryOrderListV2(
        size: 10,
        language: languageServices.languageCodeSystem.value,
        state: 2,
        pageNum: toBePaidPageNum.value,
      ));

      this.toBePaidList.addAll(toBePaidList);

      if (toBePaidList.isEmpty) {
        isSeeMoreToBePaid.value = false;
      }
    }
  }

  Future<void> getCancelOrderList() async {
    isSeeMoreCancelOrder.value = true;
    cancelOrderPageNum.value = 1;

    cancelOrderList.value = (await orderRepository.getHistoryOrderListV2(
      size: 10,
      language: languageServices.languageCodeSystem.value,
      state: 3,
      pageNum: cancelOrderPageNum.value,
    ));

    if (cancelOrderList.isEmpty) {
      isSeeMoreCancelOrder.value = false;
    }
  }

  Future<void> seeMoreCancelOrderList() async {
    if (isSeeMoreCancelOrder.value == true) {
      cancelOrderPageNum.value += 1;

      var cancelOrderList = (await orderRepository.getHistoryOrderListV2(
        size: 10,
        language: languageServices.languageCodeSystem.value,
        state: 3,
        pageNum: cancelOrderPageNum.value,
      ));

      this.cancelOrderList.addAll(cancelOrderList);

      if (cancelOrderList.isEmpty) {
        isSeeMoreCancelOrder.value = false;
      }
    }
  }

  Future<void> showDialogAdvancedBookingConfirmation({
    required Order selectedOrder,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var isDialogShow =
        prefs.getBool(
          'dialog_advance_booking_reconfirmation_${selectedOrder.id}',
        ) ??
        false;

    if (isDialogShow == false) {
      await prefs.setBool(
        'dialog_advance_booking_reconfirmation_${selectedOrder.id}',
        true,
      );

      var orderData = await orderRepository.getOrderDetail(
        orderType: selectedOrder.type!,
        orderId: selectedOrder.id.toString(),
        language: languageServices.languageCodeSystem.value,
      );
      var orderUserData = await orderRepository.getOrderUserDetail(
        orderType: selectedOrder.type!,
        orderId: selectedOrder.id.toString(),
      );

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
                                  "Order EVMoto Motor",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                ),
                                Text(
                                  "${formatDouble(orderData.startMileage!)} km",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderUserData.name ?? "-",
                                        style: typographyServices
                                            .bodySmallRegular
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        orderData.startAddress ?? "-",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        orderData.endAddress ?? "-",
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
                            Divider(height: 0, color: Color(0XFFE7E7E7)),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Biaya",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(),
                                ),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(orderData.orderMoney),
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
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
                                      (
                                        GoogleMapController googleMapController,
                                      ) {
                                        googleMapController =
                                            googleMapController;
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
                                await onSlideAdvanceBookingConfirmation(
                                  actionController: actionController,
                                  selectedOrder: selectedOrder,
                                );
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
                                          ? Color(0XFF0573EA)
                                          : themeColorServices
                                                .neutralsColorGrey300
                                                .value,
                                      width: state.position >= 0.5 ? 5 : 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.only(right: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    "Swipe untuk berangkat menjemput",
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
                                              "Sedang Menjemput",
                                              style: typographyServices
                                                  .bodyLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
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
                                  await onTapCancelAdvanceBooking(
                                    selectedOrder: selectedOrder,
                                  );
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

      await prefs.setBool(
        'dialog_advance_booking_reconfirmation_${selectedOrder.id}',
        false,
      );
    }
  }

  Future<void> onSlideAdvanceBookingConfirmation({
    required ActionSliderController actionController,
    required Order selectedOrder,
  }) async {
    actionController.loading();
    try {
      await advanceBookingRepository.advanceBookingSecondConfirm(
        orderId: selectedOrder.id.toString(),
      );

      actionController.success();
      actionController.reset();

      Get.back(result: true);

      Get.toNamed(
        Routes.ORDER_DETAIL,
        arguments: {
          "order_id": selectedOrder.id,
          "order_type": selectedOrder.type,
        },
      );
      await refreshAll();
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());

      actionController.success();
      actionController.reset();
      Get.back(result: true);
      Get.until((route) => route.settings.name == Routes.HOME);
      await refreshAll();
    }
  }

  Future<void> onTapCancelAdvanceBooking({required Order selectedOrder}) async {
    Get.dialog(
      AdvanceBookingCancelDialogWidget(
        onTapConfirm: () async {
          await advanceBookingRepository.advanceBookingCancel(
            orderId: selectedOrder.id.toString(),
          );
          await refreshAll();
          Get.close(1);
          Get.close(1);
        },
      ),
    );
  }
}
