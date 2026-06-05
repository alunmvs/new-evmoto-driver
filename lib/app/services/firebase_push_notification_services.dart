import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/socket_order_status_data_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/modules/order_detail/controllers/order_detail_controller.dart';
import 'package:new_evmoto_driver/app/repositories/notification_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('ic_notification_small'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload == 'detail_page') {}
    },
  );

  flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.data['title'],
    message.data['body'],
    NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentBanner: true,
        presentSound: true,
        sound: message.data['notification_type'] == 'VOICE_BROADCAST'
            ? "${message.data['voice_type']}.caf"
            : null,
      ),
      android: AndroidNotificationDetails(
        message.data['channel_id'] ?? "default",
        message.data['channel_name'] ?? "Default",
        largeIcon: DrawableResourceAndroidBitmap('ic_notification_large'),
        icon: 'ic_notification_small',
        color: const Color(0XFF0060C6),
        sound: message.data['notification_type'] == 'VOICE_BROADCAST'
            ? RawResourceAndroidNotificationSound(message.data['voice_type'])
            : null,
      ),
    ),
  );
}

class FirebasePushNotificationServices extends GetxService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final notificationRepository = NotificationRepository();
  final fcmToken = Rx<String?>(null);
  final apnsToken = Rx<String?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: false,
            badge: false,
            sound: false,
          );
    }

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('ic_notification_small'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == 'detail_page') {}
      },
    );

    await initTokens();
    await initListeners();
  }

  Future<void> initTokens() async {
    var deviceId = await getDeviceId();
    var appVersion = await getVersion();
    var osVersion = await getOSVersion();

    var fcmToken = await FirebaseMessaging.instance.getToken();
    this.fcmToken.value = fcmToken;

    // print("[DEBUG NOTIFICATION] fcmToken ${this.fcmToken.value}");

    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      this.apnsToken.value = apnsToken;

      await notificationRepository.subscribeNotification(
        fcmToken: fcmToken,
        apnsToken: apnsToken,
        deviceType: "1",
        deviceId: deviceId,
        appVersion: appVersion,
        osVersion: osVersion,
      );
    }

    if (Platform.isAndroid) {
      await notificationRepository.subscribeNotification(
        fcmToken: fcmToken,
        apnsToken: null,
        deviceType: "1",
        deviceId: deviceId,
        appVersion: appVersion,
        osVersion: osVersion,
      );
    }
  }

  Future<void> initListeners() async {
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {})
        .onError((err) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // print("[DEBUG NOTIFICATION] ${message.data['title']}");
      // print("[DEBUG NOTIFICATION] ${message.data['body']}");
      // print(
      //   "[DEBUG NOTIFICATION] ${message.data['notification_type'] == 'VOICE_BROADCAST'}",
      // );
      // print("[DEBUG NOTIFICATION] ${"${message.data['voice_type']}.caf"}");

      if (message.data['notification_type'] == 'VOICE_BROADCAST') {
        if (['1'].contains(message.data['state'].toString())) {
          if (Get.currentRoute == Routes.ORDER_DETAIL) {
            var orderDetailController = Get.find<OrderDetailController>();

            if (orderDetailController.orderId.value ==
                SocketOrderStatusData.fromJson(
                  message.data,
                ).orderId.toString()) {
              return;
            }
          }

          var prefs = await SharedPreferences.getInstance();

          if (prefs.getBool('home_controller_registered') == true) {
            var homeController = Get.find<HomeController>();
            if (message.data['travel_time'] == null) {
              await Future.wait([
                homeController.refreshAll(),
                homeController.showDialogOrderConfirmation(
                  socketOrderStatusData: SocketOrderStatusData(
                    orderId: int.tryParse(message.data['order_id'].toString()),
                    orderType: int.tryParse(
                      message.data['order_type'].toString(),
                    ),
                    state: int.tryParse(message.data['state'].toString()),
                    time: int.tryParse(message.data['time'].toString()),
                    travelTime: message.data['travel_time'],
                  ),
                ),
              ]);
            }

            if (message.data['travel_time'] != null) {
              await Future.wait([
                homeController.refreshAll(),
                homeController.showDialogAdvancedBookingConfirmation(
                  socketOrderStatusData: SocketOrderStatusData(
                    orderId: int.tryParse(message.data['order_id'].toString()),
                    orderType: int.tryParse(
                      message.data['order_type'].toString(),
                    ),
                    state: int.tryParse(message.data['state'].toString()),
                    time: int.tryParse(message.data['time'].toString()),
                    travelTime: message.data['travel_time'],
                  ),
                ),
              ]);
            }
          }
        }
      }

      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentBanner: true,
            presentSound: true,
            sound: message.data['notification_type'] == 'VOICE_BROADCAST'
                ? "${message.data['voice_type']}.caf"
                : null,
            interruptionLevel: InterruptionLevel.active,
          ),
          android: AndroidNotificationDetails(
            message.data['channel_id'] ?? "default",
            message.data['channel_name'] ?? "Default",
            largeIcon: DrawableResourceAndroidBitmap('ic_notification_large'),
            icon: 'ic_notification_small',
            color: const Color(0XFF0060C6),
            playSound: true,
            sound: message.data['notification_type'] == 'VOICE_BROADCAST'
                ? RawResourceAndroidNotificationSound(
                    message.data['voice_type'],
                  )
                : null,
          ),
        ),
      );
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      if (message.data['notification_type'] == 'VOICE_BROADCAST') {
        if (['1'].contains(message.data['state'].toString())) {
          if (Get.currentRoute == Routes.ORDER_DETAIL) {
            var orderDetailController = Get.find<OrderDetailController>();

            if (orderDetailController.orderId.value ==
                SocketOrderStatusData.fromJson(
                  message.data,
                ).orderId.toString()) {
              return;
            }
          }

          var prefs = await SharedPreferences.getInstance();

          if (prefs.getBool('home_controller_registered') == true) {
            var homeController = Get.find<HomeController>();

            if (message.data['travel_time'] == null) {
              await Future.wait([
                homeController.refreshAll(),
                homeController.showDialogOrderConfirmation(
                  socketOrderStatusData: SocketOrderStatusData(
                    orderId: int.tryParse(message.data['order_id'].toString()),
                    orderType: int.tryParse(
                      message.data['order_type'].toString(),
                    ),
                    state: int.tryParse(message.data['state'].toString()),
                    time: int.tryParse(message.data['time'].toString()),
                    travelTime: message.data['travel_time'],
                  ),
                ),
              ]);
            }

            if (message.data['travel_time'] != null) {
              await Future.wait([
                homeController.refreshAll(),
                homeController.showDialogAdvancedBookingConfirmation(
                  socketOrderStatusData: SocketOrderStatusData(
                    orderId: int.tryParse(message.data['order_id'].toString()),
                    orderType: int.tryParse(
                      message.data['order_type'].toString(),
                    ),
                    state: int.tryParse(message.data['state'].toString()),
                    time: int.tryParse(message.data['time'].toString()),
                    travelTime: message.data['travel_time'],
                  ),
                ),
              ]);
            }
          }
        }
      }

      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentBanner: true,
            presentSound: true,
            sound: message.data['notification_type'] == 'VOICE_BROADCAST'
                ? "${message.data['voice_type']}.caf"
                : null,
          ),
          android: AndroidNotificationDetails(
            message.data['channel_id'] ?? "default",
            message.data['channel_name'] ?? "Default",
            largeIcon: DrawableResourceAndroidBitmap('ic_notification_large'),
            icon: 'ic_notification_small',
            color: const Color(0XFF0060C6),
            playSound: true,
            sound: message.data['notification_type'] == 'VOICE_BROADCAST'
                ? RawResourceAndroidNotificationSound(
                    message.data['voice_type'],
                  )
                : null,
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {},
    );
  }

  Future<void> onUnsubscribe() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {}
    await notificationRepository.unsubscribeNotification(
      fcmToken: fcmToken.value,
      apnsToken: apnsToken.value,
    );
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

  Future<String> getOSVersion() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else {
      return "Unknown OS";
    }
  }

  Future<String> getVersion() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
