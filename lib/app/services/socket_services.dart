import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/socket_order_status_data_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/modules/order_payment_confirmation/controllers/order_payment_confirmation_controller.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/location_helper.dart';
import 'package:new_evmoto_driver/app/utils/socket_helper.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SocketServices extends GetxService with WidgetsBindingObserver {
  late Socket? socket;
  late Timer? schedulerDataSocketTimer;

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final isLocationReadyStatus = false.obs;

  final isSocketClose = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setupWebsocket();
    } else if (state == AppLifecycleState.paused) {
      if (isSocketClose.value == false) {
        socket?.close();
        isSocketClose.value = true;
      }
    }
  }

  Future<void> setupWebsocket() async {
    if (isSocketClose.value == true) {
      socket = await Socket.connect("api-dev.evmotoapp.com", 8888);
      isSocketClose.value = false;

      socket?.listen(
        (data) async {
          // print(data);
          var dataJson = convertBytesToJson(bytes: data);
          // print(dataJson);

          if (dataJson != null) {
            var method = dataJson['method'] ?? "";

            switch (method) {
              case 'OK':
                break;
              case 'ORDER_STATUS':
                // print(dataJson);
                var socketOrderStatusData = SocketOrderStatusData.fromJson(
                  dataJson['data'],
                );
                var homeController = Get.find<HomeController>();
                if (Get.currentRoute == Routes.HOME &&
                    socketOrderStatusData.state == 2) {
                  await Future.wait([
                    homeController.refreshAll(),
                    homeController.showDialogOrderConfirmation(
                      socketOrderStatusData: socketOrderStatusData,
                    ),
                  ]);
                }

                if (socketOrderStatusData.state == 8 &&
                    Get.currentRoute == Routes.ORDER_PAYMENT_CONFIRMATION) {
                  await Get.find<OrderPaymentConfirmationController>()
                      .refreshAll();
                }
                if (socketOrderStatusData.state == 10 &&
                    Get.currentRoute == Routes.ORDER_DETAIL) {
                  Get.back();
                  await Get.find<HomeController>().refreshAll();
                  final SnackBar snackBar = SnackBar(
                    behavior: SnackBarBehavior.fixed,
                    backgroundColor:
                        themeColorServices.sematicColorRed400.value,
                    content: Text(
                      "Pelanggan membatalkan pesanan",
                      style: typographyServices.bodySmallRegular.value.copyWith(
                        color: themeColorServices.neutralsColorGrey0.value,
                      ),
                    ),
                  );
                  rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
                }
                if (socketOrderStatusData.state == 10 &&
                    Get.currentRoute != Routes.ORDER_DETAIL) {
                  await Get.find<HomeController>().refreshAll();
                }
                break;
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

      isLocationReadyStatus.value = await isLocationReady();

      await schedulerDataSocket();
    }
  }

  Future<void> closeWebsocket() async {
    WidgetsBinding.instance.removeObserver(this);
    await socket?.close();
    isSocketClose.value = true;
  }

  Future<void> schedulerDataSocket() async {
    await sendHeartBeat();

    schedulerDataSocketTimer = Timer.periodic(Duration(seconds: 3), (
      timer,
    ) async {
      await sendHeartBeat();
      await Future.delayed(Duration(seconds: 3));
    });
  }

  Future<void> sendHeartBeat() async {
    if (isLocationReadyStatus.value == false) {
      if (Get.isDialogOpen == false) {
        await Get.dialog(
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    color: themeColorServices.neutralsColorGrey0.value,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Persetujuan Akses Lokasi",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(
                                      color: themeColorServices.textColor.value,
                                    ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Get.close(1);
                                  isLocationReadyStatus.value =
                                      await isLocationReady();
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_close.svg",
                                        width: 12,
                                        height: 12,
                                        color:
                                            themeColorServices.textColor.value,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Lokasi digunakan untuk menampilkan fitur dan layanan berdasarkan posisi Anda saat ini.",
                            style: typographyServices.bodySmallRegular.value
                                .copyWith(
                                  color: themeColorServices.textColor.value,
                                ),
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 304.5 / 125,
                              child: Image.asset(
                                "assets/images/img_location_required_1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: Get.width,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () async {
                                await checkAndEnableLocation();
                                isLocationReadyStatus.value =
                                    await isLocationReady();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    themeColorServices.primaryBlue.value,
                                side: BorderSide(
                                  color: themeColorServices.primaryBlue.value,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                "Aktifkan Lokasi",
                                style: typographyServices.bodySmallBold.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
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
                                isLocationReadyStatus.value =
                                    await isLocationReady();
                              },
                              child: Text(
                                "Batalkan",
                                style: typographyServices.bodySmallBold.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey400
                                          .value,
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
            ],
          ),
          barrierDismissible: false,
        );
      }
    } else if (isSocketClose.value == false &&
        Get.isRegistered<HomeController>() &&
        isLocationReadyStatus.value == true) {
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

      // print(jsonEncode(dataUser));
      // print(jsonEncode(dataLocation));

      socket?.add(convertJsonToPacket(dataUser));
      socket?.add(convertJsonToPacket(dataLocation));

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
