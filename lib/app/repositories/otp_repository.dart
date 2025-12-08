import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/main.dart';

class OtpRepository {
  final apiServices = Get.find<ApiServices>();

  Future<void> requestOTP({String? phone, int? language, int? type}) async {
    try {
      var url = "$baseUrl/account/base/driver/queryCaptcha";

      var formData = FormData.fromMap({
        "phone": phone,
        "language": language,
        "type": type,
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

  Future<void> checkOTP({String? phone, int? language, String? code}) async {
    try {
      var url = "$baseUrl/account/base/driver/checkCaptcha";

      var formData = FormData.fromMap({
        "phone": phone,
        "language": language,
        "code": code,
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
