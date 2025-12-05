import 'package:dio/dio.dart';
import 'package:new_evmoto_driver/app/data/vehicle_statistics_model.dart';
import 'package:new_evmoto_driver/main.dart';

class VehicleRepository {
  Future<VehicleStatistics> getVehicleStatisticsDetail({
    required int language,
  }) async {
    try {
      var url = "$baseUrl/driver/api/driver/queryHomeData";

      var formData = FormData.fromMap({"language": language});

      var dio = Dio();
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return VehicleStatistics.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
