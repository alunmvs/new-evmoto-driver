import 'package:dio/dio.dart';
import 'package:new_evmoto_driver/main.dart';

class OtpRepository {
  Future<void> requestOTP({String? phone, int? language, int? type}) async {
    try {
      var url = "$baseUrl/account/base/driver/queryCaptcha";

      var formData = FormData.fromMap({
        "phone": phone,
        "language": language,
        "type": type,
      });

      var dio = Dio();
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

      var dio = Dio();
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }
}
