import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_evmoto_driver/app/data/user_info_model.dart';
import 'package:new_evmoto_driver/main.dart';

class UserRepository {
  Future<UserInfo> getUserInfoDetail({required int language}) async {
    try {
      var url = "$baseUrl/driver/api/driver/queryInfo";

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

      return UserInfo.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> startWork({required int language, required int type}) async {
    try {
      var url = "$baseUrl/driver/api/driver/work";

      var formData = FormData.fromMap({"language": language, "type": type});

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
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> stopWork({required int language}) async {
    try {
      var url = "$baseUrl/driver/api/driver/work";

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
    } on DioException catch (e) {
      rethrow;
    }
  }
}
