import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';

class ForgetPasswordRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<void> resetPassword({
    String? phone,
    String? password,
    String? code,
    int? language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/account/base/driver/resetPassword";

      var formData = FormData.fromMap({
        "phone": phone,
        "password": password,
        "code": code,
        "language": language,
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }
}
