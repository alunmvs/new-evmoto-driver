import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/consts/order_state_const.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/data/models/vehicle_statistics_model.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import 'package:new_evmoto_driver/app/repositories/vehicle_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/push_notification_services.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final VehicleRepository vehicleRepository;
  final OrderRepository orderRepository;
  final UserRepository userRepository;

  HomeController({
    required this.vehicleRepository,
    required this.orderRepository,
    required this.userRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final pushNotificationServices = Get.find<PushNotificationServices>();
  final socketServices = Get.find<SocketServices>();

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

  final workStatus = 2.obs;

  late Socket socket;
  late Timer schedulerDataSocketTimer;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController = TabController(length: 3, vsync: this);
    await requestLocation();
    await refreshAll();
    await socketServices.setupWebsocket();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    await socket.close();
    schedulerDataSocketTimer.cancel();
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
        pageNum: orderInServicePageNum.value,
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
      Get.showSnackbar(
        GetSnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: themeColorServices.sematicColorRed400.value,
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.GROUNDED,
          messageText: Text(
            e.toString(),
            style: typographyServices.bodySmallRegular.value.copyWith(
              color: themeColorServices.neutralsColorGrey0.value,
            ),
          ),
        ),
      );
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
      Get.showSnackbar(
        GetSnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: themeColorServices.sematicColorRed400.value,
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.GROUNDED,
          messageText: Text(
            e.toString(),
            style: typographyServices.bodySmallRegular.value.copyWith(
              color: themeColorServices.neutralsColorGrey0.value,
            ),
          ),
        ),
      );
    }
    await orderGrabbingHallRefreshController.requestRefresh();
    await orderToBeServedRefreshController.requestRefresh();
  }

  String getStringOrderState({required int state}) {
    switch (state) {
      case OrderState.WAITING_LIST:
        return 'Daftar Tunggu';
      case OrderState.TO_BE_STARTED:
        return 'Dimulai';
      case OrderState.SCHEDULED_ARRIVAL_PLACE:
        return 'Tempat Kedatangan';
      case OrderState.WAIT_FOR_PASSENGERS_TO_BOARD:
        return 'Tunggu Penumpang untuk Naik';
      case OrderState.SERVING:
        return 'Sedang Berlangsung';
      case OrderState.COMPLETION_SERVICE:
        return 'Layanan Penyelesaian';
      case OrderState.TO_BE_PAID:
        return 'Akan Dibayarkan';
      case OrderState.TO_BE_EVALUATED:
        return 'Akan Dievaluasi';
      case OrderState.COMPLETED:
        return 'Selesai';
      case OrderState.CANCELLED:
        return 'Dibatalkan';
      case OrderState.BEING_REASSIGNED:
        return 'Dialihkan';
      case OrderState.CANCEL_PENDING_PAYMENT:
        return 'Batalkan Pembayaran yang Pending';
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
}
