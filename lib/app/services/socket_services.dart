import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/socket_driver_position_data_model.dart';
import 'package:new_evmoto_driver/app/data/models/socket_order_status_data_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/modules/order_detail/controllers/order_detail_controller.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_confirmation/controllers/order_payment_confirmation_controller.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/app_lifecycle_services.dart';
import 'package:new_evmoto_driver/app/services/background_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/location_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_driver/app/utils/socket_helper.dart';
import 'package:new_evmoto_driver/environment.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocketServices extends GetxService {
  late Socket? socket;
  late Timer? schedulerDataSocketTimer;

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final locationServices = Get.find<LocationServices>();
  final languageServices = Get.find<LanguageServices>();
  final backgroundServices = Get.find<BackgroundServices>();
  final appLifecycleController = Get.find<AppLifecycleController>();

  final isSocketClose = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    Timer.periodic(Duration(seconds: 3), (value) async {
      if (isSocketClose.value == true) {
        var storage = FlutterSecureStorage();
        var token = await storage.read(key: 'token');
        var isUserLogin = token != null && token != "";

        if (isUserLogin) {
          await setupWebsocket();
        }
      }
    });
  }

  Future<void> setupWebsocket() async {
    if (isSocketClose.value == true) {
      socket = await Socket.connect(socketUrl, 8888);
      isSocketClose.value = false;

      socket?.listen(
        (data) async {
          var dataJson = convertBytesToJson(bytes: data);

          if (dataJson != null) {
            if (["PONG", "OK"].contains(dataJson['method']) == false) {
              print("[DEBUG SOCKET] ${dataJson['method']}");
              print("[DEBUG SOCKET] $dataJson");
            }

            var method = dataJson['method'] ?? "";

            switch (method) {
              case 'OK':
                break;
              case 'DRIVER_POSITION':
                if (Get.currentRoute == Routes.ORDER_DETAIL) {
                  var socketDriverPositionDataModel =
                      SocketDriverPositionData.fromJson(dataJson['data']);

                  var orderDetailController = Get.find<OrderDetailController>();
                  await orderDetailController.handleSocketDriverPositionUser(
                    socketDriverPositionData: socketDriverPositionDataModel,
                  );
                }
                break;
              case 'ORDER_STATUS':
                var socketOrderStatusData = SocketOrderStatusData.fromJson(
                  dataJson['data'],
                );
                var homeController = Get.find<HomeController>();

                print("[DEBUG SOCKET] oke-1");

                if (socketOrderStatusData.state == 1) {
                  if (Get.currentRoute == Routes.ORDER_DETAIL) {
                    var orderDetailController =
                        Get.find<OrderDetailController>();

                    if (orderDetailController.orderId.value !=
                        socketOrderStatusData.orderId.toString()) {
                      if (socketOrderStatusData.travelTime == null) {
                        print("[DEBUG SOCKET] oke-2");
                        await Future.wait([
                          homeController.refreshAll(),
                          homeController.showDialogOrderConfirmation(
                            socketOrderStatusData: socketOrderStatusData,
                          ),
                        ]);
                      }

                      if (socketOrderStatusData.travelTime != null) {
                        print("[DEBUG SOCKET] oke-3");
                        await Future.wait([
                          homeController.refreshAll(),
                          homeController.showDialogAdvancedBookingConfirmation(
                            socketOrderStatusData: socketOrderStatusData,
                          ),
                        ]);
                      }
                    }
                  } else {
                    if (socketOrderStatusData.travelTime == null) {
                      print("[DEBUG SOCKET] oke-4");
                      await Future.wait([
                        homeController.refreshAll(),
                        homeController.showDialogOrderConfirmation(
                          socketOrderStatusData: socketOrderStatusData,
                        ),
                      ]);
                    }

                    if (socketOrderStatusData.travelTime != null) {
                      print("[DEBUG SOCKET] oke-5");
                      await Future.wait([
                        homeController.refreshAll(),
                        homeController.showDialogAdvancedBookingConfirmation(
                          socketOrderStatusData: socketOrderStatusData,
                        ),
                      ]);
                    }
                  }
                }

                if (socketOrderStatusData.state == 8 &&
                    Get.currentRoute == Routes.ORDER_PAYMENT_CONFIRMATION) {
                  var orderPaymentConfirmationController =
                      Get.find<OrderPaymentConfirmationController>();

                  if (orderPaymentConfirmationController.orderId.value ==
                      socketOrderStatusData.orderId.toString()) {
                    await orderPaymentConfirmationController.refreshAll();
                  }
                }
                if (socketOrderStatusData.state == 10 &&
                    (Get.currentRoute == Routes.ORDER_DETAIL ||
                        Get.routing.previous == Routes.ORDER_DETAIL)) {
                  var orderDetailController = Get.find<OrderDetailController>();

                  if (orderDetailController.orderId.value ==
                      socketOrderStatusData.orderId.toString()) {
                    Get.back();
                    await Get.find<HomeController>().refreshAll();

                    SnackbarHelper.showSnackbarError(
                      text: "Pelanggan membatalkan pesanan",
                    );
                  }
                }
                if (socketOrderStatusData.state == 10 &&
                    Get.currentRoute != Routes.ORDER_DETAIL) {
                  await Get.find<HomeController>().refreshAll();
                }
                break;
              case 'DRIVER_WORK_STATUS':
                var homeController = Get.find<HomeController>();
                await homeController.refreshAll();
                break;
              case 'DRIVER_BALANCE_OK':
                var homeController = Get.find<HomeController>();

                if (homeController.vehicleStatistics.value.work != 1) {
                  await homeController.userRepository.startWork(
                    language: languageServices.languageCodeSystem.value,
                    type: 1,
                  );
                  homeController.workStatus.value = 1;

                  await homeController.getVehicleStatistics();

                  SnackbarHelper.showSnackbarSuccess(
                    text: dataJson["data"]["message"],
                  );
                }
                break;
              case 'DRIVER_BALANCE_LOW':
                var homeController = Get.find<HomeController>();

                if (homeController.vehicleStatistics.value.work != 2) {
                  await homeController.userRepository.stopWork(language: 2);
                  homeController.workStatus.value = 2;

                  await homeController.getVehicleStatistics();

                  SnackbarHelper.showSnackbarError(
                    text: dataJson["data"]["message"],
                  );
                }
                break;
              case 'OFFLINE':
                final backgroundServices = Get.find<BackgroundServices>();
                final userServices = Get.find<UserServices>();
                final firebasePushNotificationServices =
                    Get.find<FirebasePushNotificationServices>();
                final locationServices = Get.find<LocationServices>();
                var prefs = await SharedPreferences.getInstance();
                var storage = FlutterSecureStorage();
                final socketServices = Get.find<SocketServices>();

                await backgroundServices.clearAllState();
                await locationServices.positionStream?.cancel();
                await firebasePushNotificationServices.onUnsubscribe();

                await Future.wait([
                  backgroundServices.stopService(),
                  storage.deleteAll(),
                  socketServices.closeWebsocket(),
                  prefs.clear(),
                ]);

                userServices.clearUserInfo();

                Get.offAllNamed(Routes.LOGIN);

                SnackbarHelper.showSnackbarError(
                  text: "Anda sedang Login di perangkat lain",
                );
                break;
              case 'USER_CANCEL_ORDER':
                var prefs = await SharedPreferences.getInstance();
                if (prefs.getBool('home_controller_registered') == true) {
                  var orderId = dataJson['data']['orderId'];
                  var isDialogShow =
                      (prefs.getBool('dialog_order_confirmation_$orderId') ??
                          false) ||
                      (prefs.getBool(
                            'dialog_advance_booking_confirmation_$orderId',
                          ) ??
                          false);

                  if (isDialogShow == true) {
                    Get.close(1);
                  }
                }
              default:
                break;
            }
          }
        },
        onError: (error) {
          isSocketClose.value = true;
          socket?.destroy();
        },
        onDone: () {
          isSocketClose.value = true;
          socket?.destroy();
        },
      );

      // isLocationReadyStatus.value = await isLocationReady();

      await schedulerDataSocket();
    }
  }

  Future<void> closeWebsocket() async {
    try {
      await socket?.close();
    } catch (e) {}
    isSocketClose.value = true;
  }

  Future<void> schedulerDataSocket() async {
    await sendHeartBeat();

    schedulerDataSocketTimer = Timer.periodic(Duration(seconds: 5), (
      timer,
    ) async {
      // print("[DEBUG SOCKET] Send Socket Heart Beat");
      await sendHeartBeat();
    });
  }

  Future<void> sendHeartBeat() async {
    var prefs = await SharedPreferences.getInstance();

    // print("[DEBUG SOCKET] Start Heart Beat 1");
    if (isSocketClose.value == false &&
        prefs.getBool('home_controller_registered') == true &&
        appLifecycleController.isForeground.value == true) {
      // print("[DEBUG SOCKET] Start Heart Beat 2");
      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var deviceId = await getDeviceId();
      var appVersion = await getVersion();

      // background service
      await Future.wait([
        prefs.setString('device_id', deviceId),
        prefs.setString('app_version', appVersion),
        prefs.setInt('user_id', Get.find<HomeController>().userInfo.value.id!),
        prefs.setInt(
          'driver_id',
          Get.find<HomeController>().userInfo.value.id!,
        ),
        prefs.setInt(
          'work_status',
          Get.find<HomeController>().workStatus.value,
        ),
      ]);

      var dataUser = {
        "code": 200,
        "data": {
          "device": deviceId,
          "token": token,
          "type": 2,
          "userId": Get.find<HomeController>().userInfo.value.id,
          "version": appVersion,
        },
        "method": "PING",
        "msg": "SUCCESS",
      };
      socket?.add(convertJsonToPacket(dataUser));

      if (Get.find<HomeController>().workStatus.value == 1 &&
          locationServices.isPermissionLocationAllow.value == true) {
        var dataLocation = {
          "code": 200,
          "data": {
            "altitude": locationServices.currentAltitude.value,
            "computeAzimuth": 0.0,
            "driverId": Get.find<HomeController>().userInfo.value.id,
            "lat": locationServices.currentLatitude.value,
            "lon": locationServices.currentLongitude.value,
            "heading": locationServices.currentHeading.value,
            "speed": locationServices.currentSpeed.value,
            "orderId": "",
            "orderType": "",
          },
          "method": "LOCATION",
          "msg": "SUCCESS",
        };
        socket?.add(convertJsonToPacket(dataLocation));
      }

      if (isSocketClose.value == false) {
        await socket?.flush();
      }
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
}
