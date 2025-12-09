import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/utils/socket_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SocketServices extends GetxService {
  late Socket socket;
  late Timer schedulerDataSocketTimer;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> setupWebsocket() async {
    socket = await Socket.connect("api-dev.evmotoapp.com", 8888);

    socket.listen(
      (data) {
        var dataJson = convertBytesToJson(bytes: data);
        print(dataJson);
      },
      onError: (error) {
        print('Error: $error');
        socket.destroy();
      },
      onDone: () {
        print('Server closed connection');
        socket.destroy();
      },
    );

    await schedulerDataSocket();
  }

  Future<void> closeWebsocket() async {
    await socket.close();
  }

  Future<void> schedulerDataSocket() async {
    await sendHeartBeat();

    schedulerDataSocketTimer = Timer.periodic(Duration(seconds: 5), (
      timer,
    ) async {
      await sendHeartBeat();
    });
  }

  Future<void> sendHeartBeat() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    var deviceId = await getDeviceId();
    var appVersion = await getVersion();

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
        "userId": Get.find<HomeController>().userInfo.value.id,
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
        "driverId": Get.find<HomeController>().userInfo.value.id,
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
