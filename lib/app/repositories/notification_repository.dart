import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/notification_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/environment.dart';

class NotificationRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<void> unsubscribeNotification({
    required String? fcmToken,
    required String? apnsToken,
  }) async {
    try {
      var url = "$baseUrl/notification/unsubscribe";

      var formData = FormData.fromMap({
        "fcmToken": fcmToken,
        "apnsToken": apnsToken,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );
    } on DioException {
      rethrow;
    }
  }

  Future<void> subscribeNotification({
    required String? fcmToken,
    required String? apnsToken,
    required String deviceType,
    required String? deviceId,
    required String? appVersion,
    required String? osVersion,
  }) async {
    try {
      var url = "$baseUrl/notification/subscribe";

      var formData = FormData.fromMap({
        "fcmToken": fcmToken,
        "apnsToken": apnsToken,
        "deviceType": deviceType,
        "deviceId": deviceId,
        "appVersion": appVersion,
        "osVersion": osVersion,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }
    } on DioException {
      rethrow;
    }
  }

  Future<List<Notification>> getNotificationList({
    required int type,
    required int pageNum,
    required int size,
    required int language,
  }) async {
    try {
      var url = "$baseUrl/driver/api/systemNotice/queryNotices";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {'Authorization': "Bearer $token"};

      var formData = FormData.fromMap({
        "type": type,
        "pageNum": pageNum,
        "size": size,
        "language": language,
      });

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        options: Options(headers: headers),
        data: formData,
      );

      var notificationList = <Notification>[];

      for (var notification in response.data['data']) {
        notificationList.add(Notification.fromJson(notification));
      }

      return notificationList;
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }
}
