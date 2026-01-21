import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/open_city_model.dart';
import 'package:new_evmoto_driver/app/data/models/province_cities_model.dart';
import 'package:new_evmoto_driver/app/data/models/registered_driver_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';

class RegisterRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<List<ProvinceCities>> getAllProvinceCitiesList({int? language}) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/app/base/driver/queryAllCity";

      var formData = FormData.fromMap({"language": language});

      var dio = apiServices.dio;
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

  Future<List<OpenCity>> getAllOpenCityList({int? language}) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/app/base/openCity/queryOpenCity";

      var formData = FormData.fromMap({"language": language});

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      var results = <OpenCity>[];

      for (var data in response.data['data']) {
        results.add(OpenCity.fromJson(data));
      }

      return results;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<RegisteredDriver?> registerDriver({
    String? phone,
    String? password,
    String? code,
    int? language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/account/base/driver/registeredDriver_";

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
      return RegisteredDriver.fromJson(response.data['data']);
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
    String? type,
    String? uid,
    String? password,
    String? headImgUrl,
    String? phone,
    int? placeOfEmployment,
    String? driverContactAddress_,
    String? driveCardImgUrl,
    String? name,
    required String? usedReferralCode,
    required String? stnkFrontImg,
    required String? stnkBackImg,
    required String? selfieWithIdCardImg,
    required String? skckImg,
    required String? licensePlate,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/base/driver/updateDriver";

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
        "usedReferralCode": usedReferralCode,
        "stnkFrontImg": stnkFrontImg,
        "stnkBackImg": stnkBackImg,
        "selfieWithIdCardImg": selfieWithIdCardImg,
        "skckImg": skckImg,
        "licensePlate": licensePlate,
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
