import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/environment.dart';

class LoginRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<String> loginByMobileNumber({
    String? phone,
    String? password,
    int? language,
  }) async {
    try {
      var url = "$baseUrl/account/base/driver/driverLogin";

      var formData = FormData.fromMap({
        "phone": phone,
        "password": password,
        "language": language,
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return response.data['data']['token'];
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<String> loginByMobileNumberOtp({
    String? phone,
    String? otp,
    int? language,
  }) async {
    try {
      var url = "$baseUrl/account/base/driver/driverLoginByOtp";

      var formData = FormData.fromMap({
        "phone": phone,
        "code": otp,
        "language": language,
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return response.data['data']['token'];
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<bool> checkPhoneRegistered({String? phone}) async {
    try {
      var url = "$baseUrl/driver/base/driver/checkPhone";

      var headers = {"Content-Type": "application/json"};

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: {"phone": phone},
        options: Options(headers: headers),
      );

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }

      return response.data['data'];
    } on DioException {
      rethrow;
    }
  }
}
