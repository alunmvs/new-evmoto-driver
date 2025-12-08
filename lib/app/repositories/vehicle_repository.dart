import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/vehicle_statistics_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/main.dart';

class VehicleRepository {
  final apiServices = Get.find<ApiServices>();

  Future<VehicleStatistics> getVehicleStatisticsDetail({
    required int language,
  }) async {
    try {
      var url = "$baseUrl/driver/api/driver/queryHomeData";

      var formData = FormData.fromMap({"language": language});

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = Dio();
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return VehicleStatistics.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
