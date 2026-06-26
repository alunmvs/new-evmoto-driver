import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:action_slider/action_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapsToolkit;
import 'package:new_evmoto_driver/app/data/consts/order_state_const.dart';
import 'package:new_evmoto_driver/app/data/models/guarantee_income_progress_bar_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/data/models/service_order_model.dart';
import 'package:new_evmoto_driver/app/data/models/service_time_schedule_model.dart';
import 'package:new_evmoto_driver/app/data/models/socket_order_status_data_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/data/models/vehicle_statistics_model.dart';
import 'package:new_evmoto_driver/app/data/models/versioning_server_model.dart';
import 'package:new_evmoto_driver/app/data/models/working_model.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_driver/app/repositories/guarantee_income_repository.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import 'package:new_evmoto_driver/app/repositories/vehicle_repository.dart';
import 'package:new_evmoto_driver/app/repositories/versioning_server_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/background_services.dart';
import 'package:new_evmoto_driver/app/services/chat_room_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/location_services.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';
import 'package:new_evmoto_driver/app/services/voice_services.dart';
import 'package:new_evmoto_driver/app/utils/common_helper.dart';
import 'package:new_evmoto_driver/app/utils/dialog_helper.dart';
import 'package:new_evmoto_driver/app/utils/dialog_tags.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_driver/app/widgets/dialog/guarantee_income_area_in_dialog.dart';
import 'package:new_evmoto_driver/app/widgets/dialog/guarantee_income_area_out_dialog.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_driver/app/widgets/order_payment_method_row.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final VehicleRepository vehicleRepository;
  final OrderRepository orderRepository;
  final UserRepository userRepository;
  final AccountRepository accountRepository;
  final VersioningServerRepository versioningServerRepository;
  final GuaranteeIncomeRepository guaranteeIncomeRepository;
  final AdvanceBookingRepository advanceBookingRepository;

  HomeController({
    required this.vehicleRepository,
    required this.orderRepository,
    required this.userRepository,
    required this.accountRepository,
    required this.versioningServerRepository,
    required this.guaranteeIncomeRepository,
    required this.advanceBookingRepository,
  });

  final userServices = Get.find<UserServices>();
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final socketServices = Get.find<SocketServices>();
  final firebasePushNotificationServices =
      Get.find<FirebasePushNotificationServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final voiceServices = Get.find<VoiceServices>();
  final locationServices = Get.find<LocationServices>();
  final backgroundServices = Get.find<BackgroundServices>();
  final chatRoomServices = Get.find<ChatRoomServices>();

  final userInfo = UserInfo().obs;
  final vehicleStatistics = VehicleStatistics().obs;

  TabController? tabController;

  final orderGrabbingHallRefreshController = RefreshController();
  final orderGrabbingHallList = <Order>[].obs;
  final orderGrabbingHallPageNum = 1.obs;
  final isSeeMoreOrderGrabbingHall = true.obs;

  final orderInServiceRefreshController = RefreshController();
  final orderInServiceList = <Order>[].obs;
  final orderInServicePageNum = 1.obs;
  final isSeeMoreOrderInService = true.obs;
  final isOrderInServiceListNotEmpty = false.obs;

  final orderToBeServedRefreshController = RefreshController();
  final orderToBeServedList = <Order>[].obs;
  final orderToBeServedPageNum = 1.obs;
  final isSeeMoreOrderToBeServed = true.obs;
  final isOrderToBeServedListNotEmpty = false.obs;

  final serviceOrderList = <ServiceOrder>[].obs;

  // Service Time Schedule
  final serviceTimeScheduleList = <ServiceTimeSchedule>[].obs;

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

  final working = Working().obs;
  final versioningServer = VersioningServer().obs;

  // sendbird SDK
  final isSendbirdInit = false.obs;

  // notification
  final totalUnreadMessageCount = 0.obs;
  final isFetchTotalUnreadMessageCount = false.obs;

  Timer? autoOfflineTimer;
  final initialLatitude = Rx<double?>(null);
  final initialLongitude = Rx<double?>(null);
  final onlineAt = Rx<DateTime?>(null);

  // Guarantee Income Progress Bar
  final ensureIncomeRuleId = Rx<int?>(null);
  final guaranteeIncomeProgressBarList = <GuaranteeIncomeProgressBar>[].obs;
  final activeGuaranteeIncomeProgressBar = Rx<GuaranteeIncomeProgressBar?>(
    null,
  );
  Timer? guaranteeIncomeProgressBarTimer;
  Timer? guaranteeIncomeVisibilityTimer;
  final isActiveGuaranteeIncomeProgressBarOpen = false.obs;
  final isGuaranteeIncomeProgressBarVisible = false.obs;
  final guaranteeIncomeProgress = 0.0.obs;
  final startTimeLocal = Rx<DateTime?>(null);
  final endTimeLocal = Rx<DateTime?>(null);
  final startTimeAdjustTz = Rx<String?>(null);
  final endTimeAdjustTz = Rx<String?>(null);

  final activeSocketOrderStatusData = SocketOrderStatusData().obs;
  final activeSocketAdvanceBookingStatusData = SocketOrderStatusData().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController ??= TabController(length: 3, vsync: this);

    await refreshAll();

    isSendbirdInit.value = true;
    isFetch.value = false;

    ShowcaseView.register();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkAppVersioning(isShowVersionNewestConfirmationDialog: false);

      // await displayCoachmark();
      await firebasePushNotificationServices.requestPermission();
      await backgroundServices.startService();
      await setHomeControllerRegistered();
      await Future.wait([
        setupAutoOfflineTimer(),
        setupGuaranteeIncomeProgressBarTimer(),
        setupGuaranteeIncomeVisibilityTimer(),
      ]);
      await backgroundServices.refreshState();

      await getServiceTimeScheduleList();
      await checkServiceTimeSchedule();
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
    autoOfflineTimer?.cancel();
    guaranteeIncomeProgressBarTimer?.cancel();
    guaranteeIncomeVisibilityTimer?.cancel();
  }

  // Working Time Schedule
  Future<void> getServiceTimeScheduleList() async {
    var serviceTimeScheduleList = <ServiceTimeSchedule>[];
    if (firebaseRemoteConfigServices.remoteConfig
        .getString("evmoto_global_service_time")
        .isNotEmpty) {
      var evmotoGlobalWorkingTime = jsonDecode(
        firebaseRemoteConfigServices.remoteConfig.getString(
          "evmoto_global_service_time",
        ),
      );

      for (var workingTimeSchedule
          in evmotoGlobalWorkingTime['service_time_schedule']) {
        serviceTimeScheduleList.add(
          ServiceTimeSchedule.fromJson(workingTimeSchedule),
        );
      }
    }

    this.serviceTimeScheduleList.value = serviceTimeScheduleList;
  }

  Future<void> checkServiceTimeSchedule() async {
    if (serviceTimeScheduleList.isNotEmpty) {
      var isInServiceTimeSchedule = false;

      for (var serviceTimeSchedule in serviceTimeScheduleList) {
        final now = DateTime.now();
        final startTime = parseTime(serviceTimeSchedule.startTime!);
        final endTime = parseTime(serviceTimeSchedule.endTime!);

        isInServiceTimeSchedule =
            (now.isAtSameMomentAs(startTime) || now.isAfter(startTime)) &&
            (now.isAtSameMomentAs(endTime) || now.isBefore(endTime));

        if (isInServiceTimeSchedule == true) {
          break;
        }
      }

      if (isInServiceTimeSchedule == false) {
        DialogHelper.show(
          tag: DialogTags.serviceTimeValidation,
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 400,
                      maxHeight: MediaQuery.of(
                        navigatorKey.currentContext!,
                      ).size.height,
                    ),
                    child: Material(
                      color: themeColorServices.neutralsColorGrey0.value,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/icons/icon_service_time.png",
                                  width: 64,
                                  height: 64,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Pemberitahuan Jam Operasional",
                                  style: typographyServices.bodyLargeBold.value,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Saat ini layanan mengikuti jam operasional yang berlaku. Penggunaan aplikasi tetap berjalan seperti biasa.",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                LoaderElevatedButton(
                                  child: Text(
                                    "Lanjutkan",
                                    style: typographyServices
                                        .bodyLargeBold
                                        .value
                                        .copyWith(
                                          color: themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                        ),
                                  ),
                                  onPressed: () async {
                                    DialogHelper.dismiss(
                                      DialogTags.serviceTimeValidation,
                                    );
                                  },
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  DialogHelper.dismiss(
                                    DialogTags.serviceTimeValidation,
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: 24,
                                  height: 24,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_close_1.svg",
                                        width: 18,
                                        height: 18,
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
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> requestLocation() async {
    try {
      var isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      var permission = await Geolocator.requestPermission();

      if (isLocationServiceEnabled == false ||
          (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever)) {
        return;
      }
    } catch (e) {}
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

  Future<void> getWorking() async {
    try {
      working.value =
          (await orderRepository.getWorking(
            language: languageServices.languageCodeSystem.value,
          )) ??
          Working();
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  Future<void> refreshAll() async {
    await locationServices.requestLocation();

    await Future.wait([
      getUserInfoDetail(),
      getVehicleStatistics(),
      userServices.getUserInfo(),
      userServices.getWorkingArea(),
      voiceServices.manualOnInit(),
      getServiceOrderList(),
      getWorking(),
      getEnsureIncomeRuleId(),
    ]);

    await Future.wait([
      getTotalUnreadFirebaseChat(),
      getGuaranteeIncomeProgressBarList(),
    ]);

    workStatus.value = vehicleStatistics.value.work ?? 2;

    if (userInfo.value.balance == 0 && workStatus.value == 1) {
      await userRepository.stopWork(language: 2);
      workStatus.value = 2;
    }

    await backgroundServices.refreshState();
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
      language: languageServices.languageCodeSystem.value,
      state: 3,
      pageNum: orderGrabbingHallPageNum.value,
    ));

    isOrderToBeServedListNotEmpty.value = orderGrabbingHallList.isNotEmpty;
    if (orderGrabbingHallList.isEmpty) {
      isSeeMoreOrderGrabbingHall.value = false;
    }
  }

  Future<void> seeMoreOrderGrabbingHallList() async {
    if (isSeeMoreOrderGrabbingHall.value == true) {
      orderGrabbingHallPageNum.value += 1;

      var orderGrabbingHallList = (await orderRepository.getOrderList(
        size: 10,
        language: languageServices.languageCodeSystem.value,
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
      language: languageServices.languageCodeSystem.value,
      state: 1,
      pageNum: orderInServicePageNum.value,
    ));

    isOrderInServiceListNotEmpty.value = orderInServiceList.isNotEmpty;
    if (orderInServiceList.isEmpty) {
      isSeeMoreOrderInService.value = false;
    }
  }

  Future<void> seeMoreOrderInServiceList() async {
    if (isSeeMoreOrderInService.value == true) {
      orderInServicePageNum.value += 1;

      var orderInServiceList = (await orderRepository.getOrderList(
        size: 10,
        language: languageServices.languageCodeSystem.value,
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
      language: languageServices.languageCodeSystem.value,
    );
  }

  Future<void> getOrderToBeServedList() async {
    isSeeMoreOrderToBeServed.value = true;
    orderToBeServedPageNum.value = 1;

    orderToBeServedList.value = (await orderRepository.getOrderList(
      size: 10,
      language: languageServices.languageCodeSystem.value,
      state: 2,
      pageNum: orderInServicePageNum.value,
    ));

    orderToBeServedList.refresh();

    if (orderToBeServedList.isEmpty) {
      isSeeMoreOrderToBeServed.value = false;
    }
  }

  Future<void> seeMoreOrderToBeServedList() async {
    if (isSeeMoreOrderToBeServed.value == true) {
      orderToBeServedPageNum.value += 1;

      var orderToBeServedList = (await orderRepository.getOrderList(
        size: 10,
        language: languageServices.languageCodeSystem.value,
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
    userInfo.refresh();
  }

  Future<void> setupAutoOfflineTimer() async {
    if (workStatus.value != 2) {
      onlineAt.value = DateTime.now();
      setInitialLatitudeLongitude();
    }

    autoOfflineTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      if (vehicleStatistics.value.work != 2) {
        if (working.value.id == null) {
          // Auto Offline Outside Working Area
          if (locationServices.currentLatitude.value != null) {
            var point = mapsToolkit.LatLng(
              locationServices.currentLatitude.value!,
              locationServices.currentLongitude.value!,
            );

            if (userServices.workingAreaList.isNotEmpty) {
              var isInside = false;

              for (var workingArea in userServices.workingAreaList) {
                var polygonList = <mapsToolkit.LatLng>[];

                if (workingArea.center?.isNotEmpty ?? false) {
                  for (var pointPolygon in workingArea.center ?? <String>[]) {
                    var pointPolygonList = pointPolygon.split(",");
                    polygonList.add(
                      mapsToolkit.LatLng(
                        double.parse(pointPolygonList[0]),
                        double.parse(pointPolygonList[1]),
                      ),
                    );
                  }

                  var isInsideLoop = mapsToolkit.PolygonUtil.containsLocation(
                    point,
                    polygonList,
                    false,
                  );

                  if (isInsideLoop == true) {
                    isInside = true;
                    break;
                  }
                }
              }

              if (isInside == false) {
                await userRepository.stopWork(language: 2);
                workStatus.value = 2;
                SnackbarHelper.showSnackbarError(
                  text:
                      "Saat ini anda berada diluar dari Working Area. Status Anda akan offline.",
                );
                await getVehicleStatistics();
                return;
              }
            }
          }

          // Auto Offline 200 m Initial Latitude Longitude
          // if (initialLatitude.value != null &&
          //     locationServices.currentLatitude.value != null) {
          //   var distanceInMeters = Geolocator.distanceBetween(
          //     initialLatitude.value!,
          //     initialLongitude.value!,
          //     locationServices.currentLatitude.value!,
          //     locationServices.currentLongitude.value!,
          //   );
          //   if (distanceInMeters >= 200) {
          //     await userRepository.stopWork(language: 2);
          //     workStatus.value = 2;
          //     SnackbarHelper.showSnackbarError(
          //       text:
          //           "Anda sudah menempuh 200 meter dan belum mendapatkan order, status Anda akan Offline.",
          //     );
          //     await getVehicleStatistics();
          //     return;
          //   }
          // }

          // Auto Offline 1 min After Online
          // if (onlineAt.value != null) {
          //   if (DateTime.now().difference(onlineAt.value!).inMinutes >= 1) {
          //     var distanceInMeters = Geolocator.distanceBetween(
          //       initialLatitude.value!,
          //       initialLongitude.value!,
          //       locationServices.currentLatitude.value!,
          //       locationServices.currentLongitude.value!,
          //     );

          //     if (distanceInMeters >= 10) {
          //       await userRepository.stopWork(language: 2);
          //       workStatus.value = 2;
          //       SnackbarHelper.showSnackbarError(
          //         text:
          //             "Tidak ada aktivitas dalam 1 menit sejak Anda Online. Status Anda akan Offline.",
          //       );
          //       await getVehicleStatistics();
          //     } else {
          //       onlineAt.value = DateTime.now();
          //     }

          //     return;
          //   }
          // }
        }
      }
    });
  }

  // Future<void> setupBackgroundServices() async {
  //   await backgroundServices.service.startService();
  // }

  Future<void> setupGuaranteeIncomeProgressBarTimer() async {
    guaranteeIncomeProgressBarTimer = Timer.periodic(Duration(minutes: 1), (
      timer,
    ) async {
      await getEnsureIncomeRuleId();
      await getGuaranteeIncomeProgressBarList();
    });
  }

  Future<void> setupGuaranteeIncomeVisibilityTimer() async {
    guaranteeIncomeVisibilityTimer?.cancel();
    guaranteeIncomeVisibilityTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (activeGuaranteeIncomeProgressBar.value?.id != null) {
          updateGuaranteeIncomeProgressBarVisibility();
        }
      },
    );
  }

  void setInitialLatitudeLongitude() {
    initialLatitude.value = locationServices.currentLatitude.value;
    initialLongitude.value = locationServices.currentLongitude.value;
  }

  Future<void> onSwitchStatusWork() async {
    try {
      if (vehicleStatistics.value.work == 2) {
        await userRepository.startWork(
          language: languageServices.languageCodeSystem.value,
          type: 1,
        );
        workStatus.value = 1;
        onlineAt.value = DateTime.now();
        setInitialLatitudeLongitude();
      } else {
        await userRepository.stopWork(language: 2);
        workStatus.value = 2;
      }

      await userServices.getWorkingArea();
      await getVehicleStatistics();
    } catch (e) {
      errorInfoBottomSheet.value = e.toString();
      SnackbarHelper.showSnackbarError(text: errorInfoBottomSheet.value);
    }
  }

  Future<void> onTapGrabDialog({required Order order}) async {
    try {
      await orderRepository.grabOrder(
        orderType: order.type!,
        orderId: order.id.toString(),
        language: languageServices.languageCodeSystem.value,
      );

      await Get.toNamed(
        Routes.ORDER_DETAIL,
        arguments: {"order_id": order.id, "order_type": order.type},
      );
      await refreshAll();
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
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

  Future<void> showDialogAdvancedBookingConfirmation({
    required SocketOrderStatusData socketOrderStatusData,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var isDialogShow =
        prefs.getBool(
          'dialog_advance_booking_confirmation_${socketOrderStatusData.orderId}',
        ) ??
        false;

    var isDialogShown =
        prefs.getBool(
          'dialog_advance_booking_confirmation_${socketOrderStatusData.orderId}_shown',
        ) ??
        false;

    if (isDialogShow == false && isDialogShown == false) {
      activeSocketAdvanceBookingStatusData.value = socketOrderStatusData;
      await prefs.setBool(
        'dialog_advance_booking_confirmation_${socketOrderStatusData.orderId}',
        true,
      );
      await prefs.setBool(
        'dialog_advance_booking_confirmation_${socketOrderStatusData.orderId}_shown',
        true,
      );

      var orderData = await orderRepository.getOrderDetail(
        orderType: socketOrderStatusData.orderType!,
        orderId: socketOrderStatusData.orderId.toString(),
        language: languageServices.languageCodeSystem.value,
      );
      var orderUserData = await orderRepository.getOrderUserDetail(
        orderType: socketOrderStatusData.orderType!,
        orderId: socketOrderStatusData.orderId.toString(),
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

      final advanceBookingTag = DialogTags.advanceBookingConfirmation(
        socketOrderStatusData.orderId.toString(),
      );

      final durationAccept = 0.obs;
      durationAccept.value = socketOrderStatusData.time ?? 0;

      late Timer timerDuration;
      timerDuration = Timer.periodic(Duration(seconds: 1), (timer) async {
        durationAccept.value -= 1;
        if (durationAccept.value == 0) {
          await prefs.setBool(
            'dialog_advance_booking_confirmation_${socketOrderStatusData.orderId}',
            false,
          );
          timerDuration.cancel();
          DialogHelper.dismissIfExists(advanceBookingTag);
        }
      });

      var result = await DialogHelper.show<bool>(
        tag: advanceBookingTag,
        widget: Column(
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
                                  "Pesanan Terjadwal",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                ),
                                Text(
                                  "${formatDouble(orderData.mileage!)} km · ${DateFormat('d MMMM yyyy · HH:mm').format(DateTime.parse(socketOrderStatusData.travelTime!))}",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                DialogHelper.dismiss<bool>(
                                  advanceBookingTag,
                                  result: true,
                                );
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
                                        maxLines: 2,
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
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (orderData.pickupNote != null) ...[
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0XFFF0F0F0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Catatan Tambahan",
                                      style: typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFFB3B3B3)),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      orderData.pickupNote ?? "-",
                                      style: typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFF272727)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(height: 8),
                            Divider(height: 0, color: Color(0XFFE7E7E7)),
                            SizedBox(height: 8),
                            OrderPaymentMethodRow(
                              payType:
                                  orderData.payType ??
                                  socketOrderStatusData.payType,
                              labelStyle: typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(),
                              valueStyle: typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: themeColorServices.textColor.value,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
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
                                  ).format(orderData.netIncome),
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
                                  zoomControlsEnabled: false,
                                  mapToolbarEnabled: false,
                                  myLocationButtonEnabled: false,
                                  compassEnabled: false,
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
                                  socketOrderStatusData: socketOrderStatusData,
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
                                          ? Color(0XFF0060C6)
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
                                              "Menerima orderan",
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
                            // SizedBox(height: 16),
                            // SizedBox(
                            //   height: 46,
                            //   width: MediaQuery.of(
                            //     navigatorKey.currentContext!,
                            //   ).size.width,
                            //   child: OutlinedButton(
                            //     style: OutlinedButton.styleFrom(
                            //       side: BorderSide(color: Color(0XFFE54C3F)),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(16),
                            //       ),
                            //     ),
                            //     onPressed: () async {
                            //       Get.close(1);
                            //     },
                            //     child: Text(
                            //       languageServices.language.value.cancel ?? "-",
                            //       style: typographyServices.bodyLargeBold.value
                            //           .copyWith(color: Color(0XFFE54C3F)),
                            //     ),
                            //   ),
                            // ),
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
        'dialog_advance_booking_confirmation_${socketOrderStatusData.orderId}',
        false,
      );

      try {
        timerDuration.cancel();
      } catch (e) {}

      activeSocketAdvanceBookingStatusData.value = SocketOrderStatusData();
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

    var isDialogShown =
        prefs.getBool(
          'dialog_order_confirmation_${socketOrderStatusData.orderId}_shown',
        ) ??
        false;

    if (isDialogShow == false && isDialogShown == false) {
      activeSocketOrderStatusData.value = socketOrderStatusData;

      await prefs.setBool(
        'dialog_order_confirmation_${socketOrderStatusData.orderId}',
        true,
      );

      await prefs.setBool(
        'dialog_order_confirmation_${socketOrderStatusData.orderId}_shown',
        true,
      );

      var orderData = await orderRepository.getOrderDetail(
        orderType: socketOrderStatusData.orderType!,
        orderId: socketOrderStatusData.orderId.toString(),
        language: languageServices.languageCodeSystem.value,
      );
      var orderUserData = await orderRepository.getOrderUserDetail(
        orderType: socketOrderStatusData.orderType!,
        orderId: socketOrderStatusData.orderId.toString(),
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

      final orderConfirmationTag = DialogTags.orderConfirmation(
        socketOrderStatusData.orderId.toString(),
      );

      final durationAccept = 0.obs;
      durationAccept.value = socketOrderStatusData.time ?? 0;
      var shouldRejectPushOrder = true;

      late Timer timerDuration;
      timerDuration = Timer.periodic(Duration(seconds: 1), (timer) async {
        durationAccept.value -= 1;
        if (durationAccept.value == 0) {
          await prefs.setBool(
            'dialog_order_confirmation_${socketOrderStatusData.orderId}',
            false,
          );
          timerDuration.cancel();
          DialogHelper.dismissIfExists(orderConfirmationTag);
        }
      });

      await DialogHelper.show(
        tag: orderConfirmationTag,
        widget: Column(
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
                                  "${formatDouble(orderData.mileage!)} km",
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
                                DialogHelper.dismiss<bool>(
                                  orderConfirmationTag,
                                  result: true,
                                );
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
                                        maxLines: 2,
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
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (orderData.pickupNote != null) ...[
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0XFFF0F0F0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Catatan Tambahan",
                                      style: typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFFB3B3B3)),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      orderData.pickupNote ?? "-",
                                      style: typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFF272727)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(height: 8),
                            Divider(height: 0, color: Color(0XFFE7E7E7)),
                            SizedBox(height: 8),
                            OrderPaymentMethodRow(
                              payType:
                                  orderData.payType ??
                                  socketOrderStatusData.payType,
                              labelStyle: typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(),
                              valueStyle: typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: themeColorServices.textColor.value,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
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
                                  ).format(orderData.netIncome),
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
                                  zoomControlsEnabled: false,
                                  mapToolbarEnabled: false,
                                  myLocationButtonEnabled: false,
                                  compassEnabled: false,
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
                                shouldRejectPushOrder = false;
                                await onSlideOrderConfirmation(
                                  actionController: actionController,
                                  socketOrderStatusData: socketOrderStatusData,
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
                                          ? Color(0XFF0060C6)
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

      if (shouldRejectPushOrder) {
        try {
          await orderRepository.orderPushReject(
            orderId: socketOrderStatusData.orderId.toString(),
          );
        } catch (_) {}
      }

      await prefs.setBool(
        'dialog_order_confirmation_${socketOrderStatusData.orderId}',
        false,
      );

      try {
        timerDuration.cancel();
      } catch (e) {}

      activeSocketOrderStatusData.value = SocketOrderStatusData();
    }
  }

  Future<void> ensureAdvanceBookingChatRoom({
    required SocketOrderStatusData socketOrderStatusData,
  }) async {
    var orderData = await orderRepository.getOrderDetail(
      orderType: socketOrderStatusData.orderType!,
      orderId: socketOrderStatusData.orderId.toString(),
      language: languageServices.languageCodeSystem.value,
    );

    await chatRoomServices.ensureChatRoomFromOrderDetail(
      orderDetail: orderData,
      driverName: userServices.userInfo.value.name ?? '',
      driverProfileUrl: userServices.userInfo.value.avatar,
    );
  }

  Future<void> onSlideAdvanceBookingConfirmation({
    required ActionSliderController actionController,
    required SocketOrderStatusData socketOrderStatusData,
  }) async {
    actionController.loading();
    try {
      // check apakah memiliki order
      // check apakah 30 menit sebelum jadwal
      await getWorking();
      var travelTime = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).parse(socketOrderStatusData.travelTime!);
      var isHaveActiveOrder = working.value.id != null;
      var is30minsBeforeSchedule =
          travelTime.difference(DateTime.now()).inMinutes <= 30;

      if (isHaveActiveOrder == false && is30minsBeforeSchedule == true) {
        await advanceBookingRepository.advanceBookingConfirm(
          orderId: socketOrderStatusData.orderId.toString(),
        );
        await advanceBookingRepository.advanceBookingSecondConfirm(
          orderId: socketOrderStatusData.orderId.toString(),
        );
        await ensureAdvanceBookingChatRoom(
          socketOrderStatusData: socketOrderStatusData,
        );

        actionController.success();
        actionController.reset();

        DialogHelper.dismiss<bool>(
          DialogTags.advanceBookingConfirmation(
            socketOrderStatusData.orderId.toString(),
          ),
          result: true,
        );
        Get.until((route) => route.settings.name == Routes.HOME);

        await Get.toNamed(
          Routes.ORDER_DETAIL,
          arguments: {
            "order_id": socketOrderStatusData.orderId,
            "order_type": socketOrderStatusData.orderType,
          },
        );
        await refreshAll();
      } else {
        await advanceBookingRepository.advanceBookingConfirm(
          orderId: socketOrderStatusData.orderId.toString(),
        );
        await ensureAdvanceBookingChatRoom(
          socketOrderStatusData: socketOrderStatusData,
        );

        actionController.success();
        actionController.reset();

        DialogHelper.dismiss<bool>(
          DialogTags.advanceBookingConfirmation(
            socketOrderStatusData.orderId.toString(),
          ),
          result: true,
        );
        Get.until((route) => route.settings.name == Routes.HOME);

        await Get.toNamed(
          Routes.MY_ORDER,
          arguments: {
            "order_id": socketOrderStatusData.orderId,
            "order_type": socketOrderStatusData.orderType,
          },
        );
        await refreshAll();
      }
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());

      actionController.success();
      actionController.reset();
      DialogHelper.dismiss<bool>(
        DialogTags.advanceBookingConfirmation(
          socketOrderStatusData.orderId.toString(),
        ),
        result: true,
      );
      Get.until((route) => route.settings.name == Routes.HOME);
      await refreshAll();
    }
  }

  Future<void> onSlideOrderConfirmation({
    required ActionSliderController actionController,
    required SocketOrderStatusData socketOrderStatusData,
  }) async {
    actionController.loading();
    try {
      var result = await orderRepository.orderPushConfirm(
        orderId: socketOrderStatusData.orderId.toString(),
        language: languageServices.languageCodeSystem.value,
      );

      if (result == false) {
        actionController.success();
        actionController.reset();
        DialogHelper.dismiss<bool>(
          DialogTags.orderConfirmation(
            socketOrderStatusData.orderId.toString(),
          ),
          result: true,
        );
        Get.until((route) => route.settings.name == Routes.HOME);
        return;
      }

      actionController.success();
      actionController.reset();

      DialogHelper.dismiss<bool>(
        DialogTags.orderConfirmation(socketOrderStatusData.orderId.toString()),
        result: true,
      );
      Get.until((route) => route.settings.name == Routes.HOME);

      await Get.toNamed(
        Routes.ORDER_DETAIL,
        arguments: {
          "order_id": socketOrderStatusData.orderId,
          "order_type": socketOrderStatusData.orderType,
        },
      );
      await refreshAll();
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());

      actionController.success();
      actionController.reset();
      DialogHelper.dismiss<bool>(
        DialogTags.orderConfirmation(socketOrderStatusData.orderId.toString()),
        result: true,
      );
      Get.until((route) => route.settings.name == Routes.HOME);
      await refreshAll();
    }
  }

  Future<void> onTapSaveServiceOrder() async {
    for (var serviceOrder in serviceOrderList) {
      if (serviceOrder.state != serviceOrder.updatedState) {
        try {
          await accountRepository.updateServiceOrderStatus(
            language: languageServices.languageCodeSystem.value,
            type: serviceOrder.type,
          );
        } catch (e) {
          Get.close(1);
          SnackbarHelper.showSnackbarError(text: e.toString());
          await getServiceOrderList();
          return;
        }
      }
    }

    Get.close(1);
    SnackbarHelper.showSnackbarSuccess(text: "Berhasil mengubah layanan");
    await getServiceOrderList();
  }

  Future<void> displayCoachmark() async {
    var prefs = await SharedPreferences.getInstance();
    var isCoachmarkDisplayed = prefs.getBool('is_coachmark_displayed') ?? false;

    if (isCoachmarkDisplayed == false) {
      await DialogHelper.show(
        tag: DialogTags.coachmark,
        barrierDismissible: false,
        backDismiss: false,
        widget: PopScope(
          canPop: false,
          child: Padding(
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
                              LoaderElevatedButton(
                                onPressed: () async {
                                  DialogHelper.dismiss(DialogTags.coachmark);

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
      );
    }
  }

  Future<void> checkSoftUpdate() async {
    var driverAppVersion = jsonDecode(
      firebaseRemoteConfigServices.remoteConfig.getString("driver_app_version"),
    );

    var packageInfo = await PackageInfo.fromPlatform();
    var currentVersion = Version.parse(packageInfo.version);
    var latestAppVersion = Version.parse(
      driverAppVersion['latest_app_version'],
    );

    if (latestAppVersion > currentVersion) {
      await showDialogSoftUpdate();
    }
  }

  Future<void> checkForceUpdate() async {
    var driverAppVersion = jsonDecode(
      firebaseRemoteConfigServices.remoteConfig.getString("driver_app_version"),
    );

    var packageInfo = await PackageInfo.fromPlatform();
    var currentVersion = Version.parse(packageInfo.version);
    var minAppVersion = Version.parse(driverAppVersion['min_app_version']);

    if (minAppVersion > currentVersion) {
      await showDialogForceUpdate();
    }
  }

  Future<void> showDialogSoftUpdate() async {
    await DialogHelper.show(
      tag: DialogTags.appSoftUpdate,
      widget: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.asset(
                            "assets/images/img_soft_update.png",
                            width: Get.width,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Versi Terbaru EVMoto Driver\nTelah Tersedia",
                        style: typographyServices.bodyLargeBold.value,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Perbarui aplikasi untuk pengalaman\nyang lebih lancar dan optimal.",
                        style: typographyServices.bodySmallRegular.value
                            .copyWith(color: Color(0XFFB3B3B3)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      LoaderElevatedButton(
                        onPressed: () async {
                          await onTapUpdateVersion();
                        },
                        child: Text(
                          "Update Sekarang",
                          style: typographyServices.bodyLargeBold.value
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16),
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

  Future<void> showDialogForceUpdate() async {
    await DialogHelper.show(
      tag: DialogTags.appForceUpdate,
      barrierDismissible: false,
      backDismiss: false,
      widget: PopScope(
        canPop: false,
        child: Material(
          color: themeColorServices.neutralsColorGrey0.value,
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.asset(
                        "assets/images/img_force_update.png",
                        width: Get.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Versi Terbaru Telah Tersedia",
                    style: typographyServices.bodyLargeBold.value,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Perbarui aplikasi untuk pengalaman yang lebih lancar dan optimal.",
                    style: typographyServices.bodySmallRegular.value.copyWith(
                      color: Color(0XFFB3B3B3),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  LoaderElevatedButton(
                    onPressed: () async {
                      await onTapUpdateVersion();
                    },
                    child: Text(
                      "Update Sekarang",
                      style: typographyServices.bodyLargeBold.value.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTapUpdateVersion() async {
    if (Platform.isAndroid) {
      var url = Uri.parse(
        firebaseRemoteConfigServices.remoteConfig.getString(
          "driver_playstore_link",
        ),
      );

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Unable launch url update app version';
      }
    } else if (Platform.isIOS) {
      var url = Uri.parse(
        firebaseRemoteConfigServices.remoteConfig.getString(
          "driver_appstore_link",
        ),
      );

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Unable launch url update app version';
      }
    }
  }

  // New
  Future<void> checkAppVersioning({
    required bool isShowVersionNewestConfirmationDialog,
  }) async {
    try {
      versioningServer.value = await versioningServerRepository
          .getVersioningServer(type: 2);

      if (versioningServer.value.version == null) {
        if (isShowVersionNewestConfirmationDialog == true) {
          DialogHelper.show(
            tag: DialogTags.appVersionNewest,
            widget: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Material(
                      color: themeColorServices.neutralsColorGrey0.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Color(0XFFDDFFE6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_checkmark_circle.svg",
                                    width: 26,
                                    height: 26,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Anda menggunakan versi terbaru",
                              style: typographyServices.bodyLargeBold.value,
                            ),
                            SizedBox(height: 16),
                            LoaderElevatedButton(
                              child: Text(
                                "Kembali",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(color: Colors.white),
                              ),
                              onPressed: () async {
                                DialogHelper.dismiss(
                                  DialogTags.appVersionNewest,
                                );
                              },
                            ),
                            SizedBox(height: 16),
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
        return;
      }

      if (versioningServer.value.version != null) {
        var packageInfo = await PackageInfo.fromPlatform();
        var currentVersion = Version.parse(packageInfo.version);
        var serverVersion = Version.parse(versioningServer.value.version!);

        if (currentVersion < serverVersion) {
          var prefs = await SharedPreferences.getInstance();
          var lastUpdateLaterClickAt = prefs.getString(
            "last_update_later_click_at",
          );

          var isShow = false;

          if (isShowVersionNewestConfirmationDialog == true) {
            isShow = true;
          } else {
            if (lastUpdateLaterClickAt != null) {
              var lastUpdateLaterClickAtDateTime =
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(lastUpdateLaterClickAt),
                  );

              if (isSameDay(lastUpdateLaterClickAtDateTime, DateTime.now())) {
                isShow = false;
              } else {
                isShow = true;
              }
            } else {
              isShow = true;
            }
          }

          if (isShow == true) {
            await DialogHelper.show(
              tag: DialogTags.appVersionUpdate,
              barrierDismissible: false,
              backDismiss: false,
              widget: PopScope(
                canPop: false,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Material(
                          color: themeColorServices.neutralsColorGrey0.value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Image.asset(
                                    "assets/images/img_soft_update.png",
                                    width: Get.width * 169.25 / 375,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Versi baru tersedia",
                                  style: typographyServices.bodyLargeBold.value,
                                  textAlign: TextAlign.center,
                                ),
                                if (versioningServer.value.content != null &&
                                    versioningServer.value.content != '') ...[
                                  SizedBox(height: 8),
                                  Text(
                                    versioningServer.value.content ?? "-",
                                    style: typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(color: Color(0XFFB3B3B3)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                SizedBox(height: 16),
                                LoaderElevatedButton(
                                  onPressed: () async {
                                    await onTapUpdateVersion();
                                  },
                                  child: Text(
                                    "Perbarui sekarang",
                                    style: typographyServices
                                        .bodyLargeBold
                                        .value
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                if (versioningServer.value.mandatory == 0) ...[
                                  SizedBox(height: 10),
                                  SizedBox(
                                    height: 46,
                                    width: Get.width,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Color(0XFFDBDBDB),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        DialogHelper.dismiss(
                                          DialogTags.appVersionUpdate,
                                        );

                                        var prefs =
                                            await SharedPreferences.getInstance();
                                        await prefs.setString(
                                          "last_update_later_click_at",
                                          DateTime.now().millisecondsSinceEpoch
                                              .toString(),
                                        );
                                      },
                                      child: Text(
                                        "Perbarui nanti",
                                        style: typographyServices
                                            .bodyLargeBold
                                            .value
                                            .copyWith(color: Color(0XFFAFAFAF)),
                                      ),
                                    ),
                                  ),
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
              ),
            );
          }
        } else {
          if (isShowVersionNewestConfirmationDialog == true) {
            DialogHelper.show(
              tag: DialogTags.appVersionNewest,
              widget: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Material(
                        color: themeColorServices.neutralsColorGrey0.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Color(0XFFDDFFE6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_checkmark_circle.svg",
                                      width: 26,
                                      height: 26,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Anda menggunakan versi terbaru",
                                style: typographyServices.bodyLargeBold.value,
                              ),
                              SizedBox(height: 16),
                              LoaderElevatedButton(
                                child: Text(
                                  "Kembali",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(color: Colors.white),
                                ),
                                onPressed: () async {
                                  DialogHelper.dismiss(
                                    DialogTags.appVersionNewest,
                                  );
                                },
                              ),
                              SizedBox(height: 16),
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
      }
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> getTotalUnreadFirebaseChat() async {
    if (isFetchTotalUnreadMessageCount.value == false) {
      isFetchTotalUnreadMessageCount.value = true;
      totalUnreadMessageCount.value = 0;
      var evmotoOrderChatParticipants = await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .where(
            'driverId',
            isEqualTo: userServices.userInfo.value.id.toString(),
          )
          .where('totalUnreadChatUser', isGreaterThan: 0)
          .orderBy('lastMessageAt', descending: true)
          .get();

      for (var doc in evmotoOrderChatParticipants.docs) {
        totalUnreadMessageCount.value +=
            int.tryParse(doc.data()['totalUnreadChatUser'].toString()) ?? 0;
      }
      isFetchTotalUnreadMessageCount.value = false;
    }
  }

  Future<void> setHomeControllerRegistered() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('home_controller_registered', true);
  }

  Future<void> getEnsureIncomeRuleId() async {
    ensureIncomeRuleId.value = await guaranteeIncomeRepository
        .getActiveEnsureIncomeRuleId();
  }

  bool isWithinGuaranteeIncomeTimeRange(String startTime, String endTime) {
    final now = DateTime.now();
    final start = parseToToday(now, startTime).toLocal();
    final end = parseToToday(now, endTime).toLocal();
    return now.isAfter(start) && now.isBefore(end);
  }

  void updateGuaranteeIncomeProgressBarVisibility() {
    final activeBar = activeGuaranteeIncomeProgressBar.value;
    final startTime = activeBar?.startTime;
    final endTime = activeBar?.endTime;

    if (startTime == null || endTime == null || activeBar?.id == null) {
      isGuaranteeIncomeProgressBarVisible.value = false;
      isActiveGuaranteeIncomeProgressBarOpen.value = false;
      return;
    }

    isGuaranteeIncomeProgressBarVisible.value =
        isWithinGuaranteeIncomeTimeRange(startTime, endTime);

    if (!isGuaranteeIncomeProgressBarVisible.value) {
      isActiveGuaranteeIncomeProgressBarOpen.value = false;
    }
  }

  Future<void> getGuaranteeIncomeProgressBarList() async {
    if (ensureIncomeRuleId.value != null) {
      guaranteeIncomeProgressBarList.value = await guaranteeIncomeRepository
          .getGuaranteeIncomeProgressBarList(
            ensureIncomeRuleId: ensureIncomeRuleId.value,
          );

      var isInRangeExist = false;
      for (var guaranteeIncomeProgressBar in guaranteeIncomeProgressBarList) {
        if (guaranteeIncomeProgressBar.startTime != null &&
            guaranteeIncomeProgressBar.endTime != null) {
          var isInRange = isWithinGuaranteeIncomeTimeRange(
            guaranteeIncomeProgressBar.startTime!,
            guaranteeIncomeProgressBar.endTime!,
          );

          if (isInRange == true) {
            activeGuaranteeIncomeProgressBar.value = guaranteeIncomeProgressBar;
            isInRangeExist = true;

            // Guarantee Income Progress
            if (guaranteeIncomeProgressBar.onlineDurationMinutes != null) {
              var start = parseTime(guaranteeIncomeProgressBar.startTime!);
              var end = parseTime(guaranteeIncomeProgressBar.endTime!);
              guaranteeIncomeProgress.value =
                  guaranteeIncomeProgressBar.onlineDurationMinutes! /
                  end.difference(start).inMinutes;
            } else {
              guaranteeIncomeProgress.value = 0.0;
            }

            // Start Time & End Time
            var startTimeLocal = convertToLocal(
              guaranteeIncomeProgressBar.startTime!,
            );
            var endTimeLocal = convertToLocal(
              guaranteeIncomeProgressBar.endTime!,
            );
            this.startTimeLocal.value = startTimeLocal;
            this.endTimeLocal.value = endTimeLocal;
            startTimeAdjustTz.value = formatTime(startTimeLocal);
            endTimeAdjustTz.value = formatTime(endTimeLocal);
            break;
          }
        }
      }

      if (isInRangeExist) {
        updateGuaranteeIncomeProgressBarVisibility();
      } else {
        activeGuaranteeIncomeProgressBar.value = GuaranteeIncomeProgressBar();
        guaranteeIncomeProgress.value = 0.0;
        startTimeLocal.value = null;
        endTimeLocal.value = null;
        startTimeAdjustTz.value = null;
        endTimeAdjustTz.value = null;
        isGuaranteeIncomeProgressBarVisible.value = false;
        isActiveGuaranteeIncomeProgressBarOpen.value = false;
      }
    } else {
      guaranteeIncomeProgressBarList.value = <GuaranteeIncomeProgressBar>[];
      activeGuaranteeIncomeProgressBar.value = GuaranteeIncomeProgressBar();
      guaranteeIncomeProgress.value = 0.0;
      startTimeLocal.value = null;
      endTimeLocal.value = null;
      startTimeAdjustTz.value = null;
      endTimeAdjustTz.value = null;
      isGuaranteeIncomeProgressBarVisible.value = false;
      isActiveGuaranteeIncomeProgressBarOpen.value = false;
    }
  }

  // Guarantee Income Area
  Future<void> showDialogAndSnackbarGuaranteeIncomeAreaIn() async {
    var prefs = await SharedPreferences.getInstance();
    var isGuaranteeIncomeAreaInDialogShown =
        prefs.getBool("is_guarantee_income_area_in_dialog_shown") ?? false;

    if (isGuaranteeIncomeAreaInDialogShown == false) {
      await DialogHelper.show(
        tag: DialogTags.guaranteeIncomeAreaIn,
        widget: GuaranteeIncomeAreaInDialog(),
      );
      await prefs.setBool("is_guarantee_income_area_in_dialog_shown", true);
    } else {
      // Snackbar
      final themeColorServices = Get.find<ThemeColorServices>();
      final typographyServices = Get.find<TypographyServices>();

      var snackBar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/icons/icon_guarantee_income_area_in.svg"),
            SizedBox(width: 8),
            Expanded(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: 'Anda telah memasuki wilayah ',
                  style: typographyServices.bodySmallRegular.value.copyWith(
                    color: Color(0XFF005216),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Gurantee Income.",
                      style: typographyServices.bodySmallBold.value.copyWith(
                        color: Color(0XFF005216),
                      ),
                    ),
                    TextSpan(
                      text:
                          " Selesaikan perjalanannya untuk mendapatkan manfaatnya.",
                      style: typographyServices.bodySmallRegular.value.copyWith(
                        color: Color(0XFF005216),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              },
              child: Icon(Icons.close, color: Color(0XFF005216), size: 20),
            ),
          ],
        ),
        closeIconColor: Color(0XFF005216),
        showCloseIcon: false,
        padding: EdgeInsets.only(left: 12, top: 10, bottom: 10, right: 12),
        margin: EdgeInsets.only(bottom: 14, left: 12, right: 12),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 3),
        backgroundColor: Color(0XFFE1FFE9),
        elevation: 0,
      );

      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }

  Future<void> showDialogAndSnackbarGuaranteeIncomeAreaOut() async {
    var prefs = await SharedPreferences.getInstance();
    var isGuaranteeIncomeAreaOutDialogShown =
        prefs.getBool("is_guarantee_income_area_out_dialog_shown") ?? false;

    if (isGuaranteeIncomeAreaOutDialogShown == false) {
      await DialogHelper.show(
        tag: DialogTags.guaranteeIncomeAreaOut,
        widget: GuaranteeIncomeAreaOutDialog(),
      );
      await prefs.setBool("is_guarantee_income_area_out_dialog_shown", true);
    } else {
      final themeColorServices = Get.find<ThemeColorServices>();
      final typographyServices = Get.find<TypographyServices>();

      var snackBar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/icons/icon_guarantee_income_area_out.svg"),
            SizedBox(width: 8),
            Expanded(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: 'Anda telah keluar wilayah ',
                  style: typographyServices.bodySmallRegular.value.copyWith(
                    color: Color(0XFFCD0000),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Gurantee Income.",
                      style: typographyServices.bodySmallBold.value.copyWith(
                        color: Color(0XFFCD0000),
                      ),
                    ),
                    TextSpan(
                      text:
                          " Manfaat Gurantee Income tidak berlaku didalam area ini.",
                      style: typographyServices.bodySmallRegular.value.copyWith(
                        color: Color(0XFFCD0000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              },
              child: Icon(Icons.close, color: Color(0XFFCD0000), size: 20),
            ),
          ],
        ),
        closeIconColor: Color(0XFFCD0000),
        showCloseIcon: false,
        padding: EdgeInsets.only(left: 12, top: 10, bottom: 10, right: 12),
        margin: EdgeInsets.only(bottom: 14, left: 12, right: 12),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 3),
        backgroundColor: Color(0XFFFFF0F0),
        elevation: 0,
      );

      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }
}
