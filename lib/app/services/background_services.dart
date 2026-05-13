import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/utils/socket_helper.dart';
import 'package:new_evmoto_driver/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundServices extends GetxService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final service = FlutterBackgroundService();

  @override
  Future<void> onInit() async {
    super.onInit();
    print("[DEBUG BACKGROUND] start");
    await initializeNotification();
    await initializeService();
    print("[DEBUG BACKGROUND] end");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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

  debugPrint("[DEBUG BACKGROUND] start-1");

  StreamSubscription? sub;

  var currentAltitude = 0.0;
  var currentLatitude = 0.0;
  var currentLongitude = 0.0;

  debugPrint("[DEBUG BACKGROUND] start-2");

  var prefs = await SharedPreferences.getInstance();
  var socket = await Socket.connect(socketUrl, 8888);

  debugPrint("[DEBUG BACKGROUND] start-3");

  var isPermissionLocationAllow = prefs.getBool("is_permission_location_allow");

  debugPrint("[DEBUG BACKGROUND] start-4");

  if (isPermissionLocationAllow == true) {
    debugPrint("[DEBUG BACKGROUND] start-5");
    sub =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 0,
          ),
        ).listen((position) {
          currentAltitude = position.accuracy;
          currentLatitude = position.latitude;
          currentLongitude = position.longitude;
        });

    debugPrint("[DEBUG BACKGROUND] start-6");
  }
  debugPrint("[DEBUG BACKGROUND] start-7");

  var schedulerDataSocketTimer = Timer.periodic(Duration(seconds: 5), (
    timer,
  ) async {
    debugPrint("[DEBUG BACKGROUND] Timer Start");
    var deviceId = prefs.getString("device_id");
    var token = prefs.getString("token");
    var userId = prefs.getInt("user_id");
    var appVersion = prefs.getString("app_version");

    var driverId = prefs.getInt("driver_id");

    var workStatus = prefs.getInt("work_status");

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
    print("[DEBUG BACKGROUND] $dataUser");
    socket.add(convertJsonToPacket(dataUser));

    if (workStatus == 1 && isPermissionLocationAllow == true) {
      var dataLocation = {
        "code": 200,
        "data": {
          "altitude": currentAltitude,
          "computeAzimuth": 0.0,
          "driverId": driverId,
          "lat": currentLatitude,
          "lon": currentLongitude,
          "orderId": "",
          "orderType": "",
        },
        "method": "LOCATION",
        "msg": "SUCCESS",
      };
      print("[DEBUG BACKGROUND] $dataLocation");
      socket.add(convertJsonToPacket(dataLocation));
    }

    await socket.flush();
    debugPrint("[DEBUG BACKGROUND] Timer End");
  });

  debugPrint("[DEBUG BACKGROUND] start-8");

  service.on("stop").listen((event) async {
    await socket.close();
    schedulerDataSocketTimer.cancel();
    sub?.cancel();
    service.stopSelf();

    print("[DEBUG BACKGROUND] background process is now stopped");
  });

  service.on("start").listen((event) {
    print("[DEBUG BACKGROUND] background process is now stopped");
  });
  debugPrint("[DEBUG BACKGROUND] start-9");
}
