import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';

class PushNotificationServices extends GetxService {
  final JPushFlutterInterface jpush = JPush.newJPush();

  @override
  Future<void> onInit() async {
    super.onInit();

    jpush.applyPushAuthority(
      NotificationSettingsIOS(sound: true, alert: true, badge: true),
    );

    initListensers();
  }

  Future<void> initListensers() async {
    jpush.addEventHandler(
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("📩 Notifikasi diterima: $message");
      },
      onOpenNotification: (Map<String, dynamic> message) async {
        print("📲 Notifikasi dibuka: $message");
      },
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("💬 Pesan custom: $message");
      },
    );
  }

  Future<void> setAlias({required String alias}) async {
    var response = await jpush.setAlias(alias);
    print(response);
  }
}
