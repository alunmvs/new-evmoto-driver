import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/services/app_lifecycle_services.dart';
import 'package:new_evmoto_driver/app/services/location_services.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/utils/socket_helper.dart';
import 'package:new_evmoto_driver/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundServices extends GetxService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final service = FlutterBackgroundService();

  final isRestarting = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeNotification();
    await initializeService();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> clearAllState() async {
    var isRunning = await service.isRunning();

    if (isRunning == true) {
      service.invoke("clearAllState");
    }
  }

  Future<void> startService() async {
    await service.startService();
  }

  Future<void> stopService() async {
    await FlutterLocalNotificationsPlugin().cancel(9191);
    service.invoke("stopService");
  }

  Future<void> refreshState() async {
    var isRunning = await service.isRunning();

    if (isRunning == true) {
      final appLifecycleController = Get.find<AppLifecycleController>();
      final locationServices = Get.find<LocationServices>();
      final socketServices = Get.find<SocketServices>();

      var prefs = await SharedPreferences.getInstance();
      var storage = FlutterSecureStorage();

      var isHomeControllerRegistered = prefs.getBool(
        'home_controller_registered',
      );

      var payload = <String, dynamic>{};

      payload['isForeground'] = appLifecycleController.isForeground.value;

      payload['isPermissionLocationAllow'] =
          locationServices.isPermissionLocationAllow.value;

      payload['deviceId'] = await socketServices.getDeviceId();
      payload['appVersion'] = await socketServices.getVersion();

      if (isHomeControllerRegistered == true) {
        var homeController = Get.find<HomeController>();
        payload['driverId'] = homeController.userInfo.value.id;
        payload['userId'] = homeController.userInfo.value.id;
        payload['workStatus'] = homeController.workStatus.value;
      }

      payload['token'] = await storage.read(key: 'token');

      service.invoke("refreshState", payload);
    }
  }

  Future<void> initializeNotification() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'foreground',
      'EVMOTO DRIVER FOREGROUND SERVICE',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> initializeService() async {
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        foregroundServiceNotificationId: 9191,
        autoStart: false,
        onStart: onStart,
        isForegroundMode: true,
        autoStartOnBoot: false,
        foregroundServiceTypes: [
          AndroidForegroundType.location,
          AndroidForegroundType.dataSync,
        ],
        notificationChannelId: 'foreground',
        initialNotificationTitle: 'Latar Aktif',
        initialNotificationContent:
            'Aplikasi Anda berjalan dengan lancar di latar belakang.',
      ),
    );

    // await service.startService();
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  bool? isForeground;
  bool? isPermissionLocationAllow;
  String? deviceId;
  String? token;
  int? userId;
  String? appVersion;
  int? driverId;
  int? workStatus;

  var schedulerDataSocketTimer = Timer.periodic(Duration(seconds: 5), (
    timer,
  ) async {
    print("[DEBUG BACKGROUND] Start");
    if (isForeground == false && (token != null && token != '')) {
      print("[DEBUG BACKGROUND] Start-1");
      var socket = await Socket.connect(socketUrl, 8888);
      var dataUser = {
        "code": 200,
        "data": {
          "device": deviceId,
          "token": token,
          "type": 2,
          "userId": userId,
          "version": appVersion,
        },
        "method": "PING",
        "msg": "SUCCESS",
      };
      socket.add(convertJsonToPacket(dataUser));

      if (workStatus == 1 && isPermissionLocationAllow == true) {
        var locationSettings = LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
        );
        var location = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );

        var dataLocation = {
          "code": 200,
          "data": {
            "altitude": location.altitude,
            "computeAzimuth": 0.0,
            "driverId": driverId,
            "lat": location.latitude,
            "lon": location.longitude,
            "orderId": "",
            "orderType": "",
          },
          "method": "LOCATION",
          "msg": "SUCCESS",
        };
        socket.add(convertJsonToPacket(dataLocation));
      }

      await socket.flush();
      await socket.close();
      print("[DEBUG BACKGROUND] End-1");
    }
    print("[DEBUG BACKGROUND] End");
  });

  service.on("stopService").listen((event) {
    service.stopSelf();

    // try {
    //   schedulerDataSocketTimer.cancel();
    // } catch (e) {
    //   print("[DEBUG STOP SERVICE] ini error timer cancel $e");
    // }
    // try {
    //   await service.stopSelf();
    // } catch (e) {
    //   print("[DEBUG STOP SERVICE] ini stop self $e");
    // }
  });

  service.on("start").listen((event) {});

  service.on("refreshState").listen((event) {
    isForeground = event?['isForeground'];
    isPermissionLocationAllow = event?['isPermissionLocationAllow'];
    isForeground = event?['isForeground'];
    deviceId = event?['deviceId'];
    token = event?['token'];
    userId = event?['userId'];
    appVersion = event?['appVersion'];
    driverId = event?['driverId'];
    workStatus = event?['workStatus'];
  });

  service.on("clearAllState").listen((event) {
    isForeground = null;
    isPermissionLocationAllow = null;
    isForeground = null;
    deviceId = null;
    token = null;
    userId = null;
    appVersion = null;
    driverId = null;
    workStatus = null;
  });
}
