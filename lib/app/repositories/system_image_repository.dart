import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/system_image_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';

class SystemImageRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<List<SystemImage>> getSystemImageList({
    int? usePort,
    int? language,
    int? type,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/base/img/queryImg";

      var formData = FormData.fromMap({
        "usePort": usePort,
        "language": language,
        "type": type,
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      var result = <SystemImage>[];
      for (var data in response.data['data']) {
        result.add(SystemImage.fromJson(data));
      }

      return result;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
