import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/data/models/vehicle_statistics_model.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import 'package:new_evmoto_driver/app/repositories/vehicle_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeController extends GetxController {
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

  final userInfo = UserInfo().obs;
  final vehicleStatistics = VehicleStatistics().obs;

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
    await requestLocation();
    await initSocket();
    await refreshAll();
    await schedulerDataSocket();
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

  Future<void> schedulerDataSocket() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    var deviceId = await getDeviceId();
    var appVersion = await getVersion();

    schedulerDataSocketTimer = Timer.periodic(Duration(seconds: 5), (
      timer,
    ) async {
      var locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      var position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      var dataUser = {
        "code": 200,
        "data": {
          "device": deviceId,
          "token": token,
          "type": 2,
          "userId": userInfo.value,
          "version": appVersion,
        },
        "method": "PING",
        "msg": "SUCCESS",
      };
      var dataLocation = {
        "code": 200,
        "data": {
          "altitude": position.altitude,
          "computeAzimuth": 0.0,
          "driverId": userInfo.value.id,
          "lat": position.latitude,
          "lon": position.longitude,
          "orderId": "",
          "orderType": "",
        },
        "method": "LOCATION",
        "msg": "SUCCESS",
      };

      socket.write(jsonEncode(dataUser));
      socket.write(jsonEncode(dataLocation));
    });
  }

  Future<void> initSocket() async {
    socket = await Socket.connect("api-dev.evmotoapp.com", 8888);

    socket.listen((data) {
      print(data);
      print(utf8.decode(data));
      print('Received: ${String.fromCharCodes(data)}');
    });
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
    await orderRepository.grabOrder(
      orderType: order.type!,
      orderId: order.id.toString(),
      language: 2,
    );

    Get.toNamed(
      Routes.ORDER_DETAIL,
      arguments: {"order_id": order.id, "order_type": order.type},
    );
    orderGrabbingHallRefreshController.requestRefresh();
    orderToBeServedRefreshController.requestRefresh();
  }
}
