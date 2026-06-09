import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/activity_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/environment.dart';

class ActivityRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<List<Activity>> getActivityList({
    int? size,
    int? pageNum,
    int? language,
  }) async {
    try {
      var url = "$baseUrl/activity/api/driver/queryMyActivity";

      var formData = FormData.fromMap({
        "size": size,
        "pageNum": pageNum,
        "language": language,
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

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      var activityList = <Activity>[];

      for (var activity in response.data['data']) {
        activityList.add(Activity.fromJson(activity));
      }

      return activityList;
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }
}
