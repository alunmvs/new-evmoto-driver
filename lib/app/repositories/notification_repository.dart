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
