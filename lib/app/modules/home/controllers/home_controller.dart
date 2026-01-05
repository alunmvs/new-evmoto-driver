import 'dart:async';
import 'dart:io';

import 'package:action_slider/action_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_driver/app/data/consts/order_state_const.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/data/models/service_order_model.dart';
import 'package:new_evmoto_driver/app/data/models/socket_order_status_data_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/data/models/vehicle_statistics_model.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import 'package:new_evmoto_driver/app/repositories/vehicle_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/push_notification_services.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/common_helper.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final VehicleRepository vehicleRepository;
  final OrderRepository orderRepository;
  final UserRepository userRepository;
  final AccountRepository accountRepository;

  HomeController({
    required this.vehicleRepository,
    required this.orderRepository,
    required this.userRepository,
    required this.accountRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final pushNotificationServices = Get.find<PushNotificationServices>();
  final socketServices = Get.find<SocketServices>();
  final languageServices = Get.find<LanguageServices>();

  final userInfo = UserInfo().obs;
  final vehicleStatistics = VehicleStatistics().obs;

  late TabController tabController;

  final orderGrabbingHallRefreshController = RefreshController();
  final orderGrabbingHallList = <Order>[].obs;
  final orderGrabbingHallPageNum = 1.obs;
  final isSeeMoreOrderGrabbingHall = true.obs;

  final orderInServiceRefreshController = RefreshController();
  final orderInServiceList = <Order>[].obs;
  final orderInServicePageNum = 1.obs;
  final isSeeMoreOrderInService = true.obs;

  final orderToBeServedRefreshController = RefreshController();
  final orderToBeServedList = <Order>[].obs;
  final orderToBeServedPageNum = 1.obs;
  final isSeeMoreOrderToBeServed = true.obs;

  final serviceOrderList = <ServiceOrder>[].obs;

  // coachmark
  final activityStatisticsGlobalKey = GlobalKey();
  final buttonSeeAllMyActivityGlobalKey = GlobalKey();
  final buttonOfflineOnlineGlobalKey = GlobalKey();
  final balanceGlobalKey = GlobalKey();
  final topUpGlobalKey = GlobalKey();
  final withdrawGlobalKey = GlobalKey();
  final historyGlobalKey = GlobalKey();
  final menuGlobalKey = GlobalKey();

  final coachmarkWorkStatus = 2.obs;
  final isCoachmarkActive = false.obs;

  final workStatus = 2.obs;
  final selectedIndex = 0.obs;

  final lastPressedBackDateTime = DateTime.now().obs;
  final errorInfoBottomSheet = "".obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController = TabController(length: 3, vsync: this);
    await requestLocation();
    await refreshAll();
    await Future.wait([socketServices.setupWebsocket()]);
    isFetch.value = false;

    ShowcaseView.register();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await displayCoachmark();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    await socketServices.closeWebsocket();
  }

  Future<void> requestLocation() async {
    var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.requestPermission();

    if (isLocationServiceEnabled == false ||
        (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever)) {
      return;
    }
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? "";
    }

    return "";
  }

  Future<String> getVersion() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> refreshAll() async {
    await Future.wait([
      getUserInfoDetail(),
      getVehicleStatistics(),
      getOrderGrabbingHallList(),
      getOrderInServiceList(),
      getOrderToBeServedList(),
      getServiceOrderList(),
    ]);

    workStatus.value = vehicleStatistics.value.work ?? 2;
  }

  Future<void> getVehicleStatistics() async {
    vehicleStatistics.value = (await vehicleRepository
        .getVehicleStatisticsDetail(language: 2));
  }

  Future<void> getOrderGrabbingHallList() async {
    isSeeMoreOrderGrabbingHall.value = true;
    orderGrabbingHallPageNum.value = 1;

    orderGrabbingHallList.value = (await orderRepository.getOrderList(
      size: 10,
      language: 2,
      state: 3,
      pageNum: orderGrabbingHallPageNum.value,
    ));

    if (orderGrabbingHallList.isEmpty) {
      isSeeMoreOrderGrabbingHall.value = false;
    }
  }

  Future<void> seeMoreOrderGrabbingHallList() async {
    if (isSeeMoreOrderGrabbingHall.value == true) {
      orderGrabbingHallPageNum.value += 1;

      var orderGrabbingHallList = (await orderRepository.getOrderList(
        size: 10,
        language: 2,
        state: 3,
        pageNum: orderGrabbingHallPageNum.value,
      ));

      this.orderGrabbingHallList.addAll(orderGrabbingHallList);

      if (orderGrabbingHallList.isEmpty) {
        isSeeMoreOrderGrabbingHall.value = false;
      }
    }
  }

  Future<void> getOrderInServiceList() async {
    isSeeMoreOrderInService.value = true;
    orderInServicePageNum.value = 1;

    orderInServiceList.value = (await orderRepository.getOrderList(
      size: 10,
      language: 2,
      state: 1,
      pageNum: orderInServicePageNum.value,
    ));

    if (orderInServiceList.isEmpty) {
      isSeeMoreOrderInService.value = false;
    }
  }

  Future<void> seeMoreOrderInServiceList() async {
    if (isSeeMoreOrderInService.value == true) {
      orderInServicePageNum.value += 1;

      var orderInServiceList = (await orderRepository.getOrderList(
        size: 10,
        language: 2,
        state: 3,
        pageNum: orderInServicePageNum.value,
      ));

      this.orderInServiceList.addAll(orderInServiceList);

      if (orderInServiceList.isEmpty) {
        isSeeMoreOrderInService.value = false;
      }
    }
  }

  Future<void> getServiceOrderList() async {
    serviceOrderList.value = await accountRepository.getServiceOrderList(
      size: 999999,
      pageNum: 1,
      language: 2,
    );
  }

  Future<void> getOrderToBeServedList() async {
    isSeeMoreOrderToBeServed.value = true;
    orderToBeServedPageNum.value = 1;

    orderToBeServedList.value = (await orderRepository.getOrderList(
      size: 10,
      language: 2,
      state: 2,
      pageNum: orderInServicePageNum.value,
    ));

    if (orderToBeServedList.isEmpty) {
      isSeeMoreOrderToBeServed.value = false;
    }
  }

  Future<void> seeMoreOrderToBeServedList() async {
    if (isSeeMoreOrderToBeServed.value == true) {
      orderToBeServedPageNum.value += 1;

      var orderToBeServedList = (await orderRepository.getOrderList(
        size: 10,
        language: 2,
        state: 3,
        pageNum: orderToBeServedPageNum.value,
      ));

      this.orderToBeServedList.addAll(orderToBeServedList);

      if (orderToBeServedList.isEmpty) {
        isSeeMoreOrderToBeServed.value = false;
      }
    }
  }

  Future<void> getUserInfoDetail() async {
    userInfo.value = await userRepository.getUserInfoDetail(language: 2);
  }

  Future<void> onSwitchStatusWork() async {
    try {
      if (vehicleStatistics.value.work == 2) {
        await userRepository.startWork(language: 2, type: 1);
        workStatus.value = 1;
      } else {
        await userRepository.stopWork(language: 2);
        workStatus.value = 2;
      }
    } catch (e) {
      errorInfoBottomSheet.value = e.toString();
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }

    await getVehicleStatistics();
  }

  Future<void> onTapGrabDialog({required Order order}) async {
    try {
      await orderRepository.grabOrder(
        orderType: order.type!,
        orderId: order.id.toString(),
        language: 2,
      );

      Get.toNamed(
        Routes.ORDER_DETAIL,
        arguments: {"order_id": order.id, "order_type": order.type},
      );
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
    await orderGrabbingHallRefreshController.requestRefresh();
    await orderToBeServedRefreshController.requestRefresh();
  }

  String getStringOrderState({required int state}) {
    switch (state) {
      case OrderState.WAITING_LIST:
        return languageServices.language.value.orderStateWaitingList ?? "-";
      case OrderState.TO_BE_STARTED:
        return languageServices.language.value.orderStateToBeStarted ?? "-";
      case OrderState.SCHEDULED_ARRIVAL_PLACE:
        return languageServices
                .language
                .value
                .orderStateScheduledArrivalPlace ??
            "-";
      case OrderState.WAIT_FOR_PASSENGERS_TO_BOARD:
        return languageServices
                .language
                .value
                .orderStateWaitForPassengersToBoard ??
            "-";
      case OrderState.SERVING:
        return languageServices.language.value.orderStateServing ?? "-";
      case OrderState.COMPLETION_SERVICE:
        return languageServices.language.value.orderStateCompletionService ??
            "-";
      case OrderState.TO_BE_PAID:
        return languageServices.language.value.orderStateToBePaid ?? "-";
      case OrderState.TO_BE_EVALUATED:
        return languageServices.language.value.orderStateToBeEvaluated ?? "-";
      case OrderState.COMPLETED:
        return languageServices.language.value.orderStateCompleted ?? "-";
      case OrderState.CANCELLED:
        return languageServices.language.value.orderStateCancelled ?? "-";
      case OrderState.BEING_REASSIGNED:
        return languageServices.language.value.orderStateBeingReassigned ?? "-";
      case OrderState.CANCEL_PENDING_PAYMENT:
        return languageServices.language.value.orderStateCancelPendingPayment ??
            "-";
      default:
        return '-';
    }
  }

  Color getBackgroundColorOrderState({required int state}) {
    switch (state) {
      case OrderState.WAITING_LIST:
        return Color(0XFFFFA3A3);
      case OrderState.TO_BE_STARTED:
        return Color(0XFFD7EAFF);
      case OrderState.SCHEDULED_ARRIVAL_PLACE:
        return Color(0XFFD7EAFF);
      default:
        return Color(0XFFFFA3A3);
    }
  }

  Future<void> showDialogOrderConfirmation({
    required SocketOrderStatusData socketOrderStatusData,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var isDialogShow =
        prefs.getBool(
          'dialog_order_confirmation_${socketOrderStatusData.orderId}',
        ) ??
        false;

    if (isDialogShow == false) {
      await prefs.setBool(
        'dialog_order_confirmation_${socketOrderStatusData.orderId}',
        true,
      );

      var orderData = await orderRepository.getOrderDetail(
        orderType: socketOrderStatusData.orderType!,
        orderId: socketOrderStatusData.orderId.toString(),
        language: 2,
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

      late GoogleMapController googleMapController;

      final durationAccept = 0.obs;
      durationAccept.value = socketOrderStatusData.time ?? 0;

      late Timer timerDuration;
      timerDuration = Timer.periodic(Duration(seconds: 1), (timer) async {
        durationAccept.value -= 1;
        if (durationAccept.value == 0) {
          await prefs.setBool(
            'dialog_order_confirmation_${socketOrderStatusData.orderId}',
            false,
          );
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
                        decoration: BoxDecoration(
                          color: themeColorServices.primaryBlue.value,
                        ),
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
                                        orderData.user ?? "-",
                                        style: typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(
                                              color: themeColorServices
                                                  .textColor
                                                  .value,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_star.svg",
                                            width: 9.17,
                                            height: 10,
                                            color: themeColorServices
                                                .sematicColorYellow400
                                                .value,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "5.0 (0)",
                                            style: typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color: themeColorServices
                                                      .textColor
                                                      .value,
                                                ),
                                          ),
                                        ],
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
                              boxShadow: [],
                              action: (actionController) async {
                                actionController.loading();
                                Get.back(result: true);
                                try {
                                  await orderRepository.grabOrder(
                                    orderType: socketOrderStatusData.orderType!,
                                    orderId: socketOrderStatusData.orderId
                                        .toString(),
                                    language: 2,
                                  );
                                } catch (e) {}
                                Get.toNamed(
                                  Routes.ORDER_DETAIL,
                                  arguments: {
                                    "order_id": socketOrderStatusData.orderId,
                                    "order_type":
                                        socketOrderStatusData.orderType,
                                  },
                                );
                                refreshAll();
                                actionController.success();
                                actionController.reset();
                              },
                              toggleMargin: EdgeInsetsGeometry.all(0),
                              outerBackgroundBuilder: (context, state, child) {
                                return Container(color: Colors.transparent);
                              },
                              foregroundBuilder: (context, state, child) {
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  padding: const EdgeInsets.all(8.0),
                                  child: state.sliderMode == SliderMode.loading
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
                                if (state.sliderMode == SliderMode.loading) {
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
                                                    "Swipe untuk mendapatkan orderan",
                                                    style: typographyServices
                                                        .bodyLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: themeColorServices
                                                              .neutralsColorGrey400
                                                              .value,
                                                        ),
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

      if (result != true) {
        await prefs.setBool(
          'dialog_order_confirmation_${socketOrderStatusData.orderId}',
          false,
        );
      }

      try {
        timerDuration.cancel();
      } catch (e) {}
    }
  }

  Future<void> onTapSaveServiceOrder() async {
    for (var serviceOrder in serviceOrderList) {
      if (serviceOrder.state != serviceOrder.updatedState) {
        try {
          await accountRepository.updateServiceOrderStatus(
            language: 2,
            type: serviceOrder.type,
          );
        } catch (e) {
          Get.close(1);
          final SnackBar snackBar = SnackBar(
            behavior: SnackBarBehavior.fixed,
            backgroundColor: themeColorServices.sematicColorRed400.value,
            content: Text(
              e.toString(),
              style: typographyServices.bodySmallRegular.value.copyWith(
                color: themeColorServices.neutralsColorGrey0.value,
              ),
            ),
          );
          rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
          await getServiceOrderList();
          return;
        }
      }
    }

    Get.close(1);
    final SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: themeColorServices.sematicColorGreen400.value,
      content: Text(
        "Berhasil mengubah layanan",
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
    );
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    await getServiceOrderList();
  }

  Future<void> displayCoachmark() async {
    var prefs = await SharedPreferences.getInstance();
    var isCoachmarkDisplayed = prefs.getBool('is_coachmark_displayed') ?? false;

    if (isCoachmarkDisplayed == false) {
      await Get.dialog(
        barrierDismissible: false,
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  color: themeColorServices.neutralsColorGrey0.value,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 325 / 110,
                        child: Image.asset(
                          "assets/images/img_coachmark.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              languageServices
                                      .language
                                      .value
                                      .dialogCoachmarkTitle ??
                                  "-",
                              style: typographyServices.bodyLargeBold.value
                                  .copyWith(
                                    color: themeColorServices.textColor.value,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              languageServices
                                      .language
                                      .value
                                      .dialogCoachmarkDescription ??
                                  "-",
                              style: typographyServices.bodySmallRegular.value
                                  .copyWith(
                                    color: themeColorServices.textColor.value,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: Get.width,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () async {
                                  Get.close(1);

                                  isCoachmarkActive.value = true;

                                  ShowcaseView.get().startShowCase([
                                    activityStatisticsGlobalKey,
                                    buttonSeeAllMyActivityGlobalKey,
                                    buttonOfflineOnlineGlobalKey,
                                    balanceGlobalKey,
                                    topUpGlobalKey,
                                    withdrawGlobalKey,
                                    historyGlobalKey,
                                    menuGlobalKey,
                                  ]);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      themeColorServices.primaryBlue.value,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  languageServices
                                          .language
                                          .value
                                          .dialogCoachmarkButton ??
                                      "-",
                                  style: typographyServices.bodySmallBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey0
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
              ),
            ],
          ),
        ),
      );
    }
  }
}
