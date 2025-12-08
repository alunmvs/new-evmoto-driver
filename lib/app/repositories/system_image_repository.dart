import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/system_image_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/main.dart';

class SystemImageRepository {
  final apiServices = Get.find<ApiServices>();

  Future<List<SystemImage>> getSystemImageList({
    int? usePort,
    int? language,
    int? type,
  }) async {
    try {
      var url = "$baseUrl/driver/base/img/queryImg";

      var formData = FormData.fromMap({
        "usePort": usePort,
        "language": language,
        "type": type,
      });

      var dio = Dio();
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
