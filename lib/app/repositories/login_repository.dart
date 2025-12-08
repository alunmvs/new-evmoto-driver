import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/main.dart';

class LoginRepository {
  final apiServices = Get.find<ApiServices>();

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
      rethrow;
    }
  }
}
