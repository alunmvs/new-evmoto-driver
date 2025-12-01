import 'package:dio/dio.dart';
import 'package:new_evmoto_driver/app/data/province_cities_model.dart';
import 'package:new_evmoto_driver/main.dart';

class RegisterRepository {
  Future<List<ProvinceCities>> getAllProvinceCitiesList({int? language}) async {
    try {
      var url = "$baseUrl/app/base/driver/queryAllCity";

      var formData = FormData.fromMap({"language": language});

      var dio = Dio();
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      var results = <ProvinceCities>[];

      for (var data in response.data['data']) {
        results.add(ProvinceCities.fromJson(data));
      }

      return results;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> registerDriver({
    String? phone,
    String? password,
    String? code,
    int? language,
  }) async {
    try {
      var url = "$baseUrl/account/base/driver/registeredDriver_";

      var formData = FormData.fromMap({
        "phone": phone,
        "password": password,
        "code": code,
        "language": language,
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

  Future<void> updateDriver({
    String? idCardImgUrl1,
    String? idCardImgUrl2,
    String? getDriverLicenseDate,
    String? idCard,
    int? sex,
    int? language,
    String? driverContactAddress,
    int? type,
    String? uid,
    String? password,
    String? headImgUrl,
    String? phone,
    String? placeOfEmployment,
    String? driverContactAddress_,
    String? driveCardImgUrl,
    String? name,
  }) async {
    try {
      var url = "$baseUrl/driver/base/driver/updateDriver";

      var formData = FormData.fromMap({
        "idCardImgUrl1": idCardImgUrl1,
        "idCardImgUrl2": idCardImgUrl2,
        "getDriverLicenseDate": getDriverLicenseDate,
        "idCard": idCard,
        "sex": sex,
        "language": language,
        "driverContactAddress": driverContactAddress,
        "type": type,
        "uid": uid,
        "password": password,
        "headImgUrl": headImgUrl,
        "phone": phone,
        "placeOfEmployment": placeOfEmployment,
        "driverContactAddress_": driverContactAddress_,
        "driveCardImgUrl": driveCardImgUrl,
        "name": name,
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
