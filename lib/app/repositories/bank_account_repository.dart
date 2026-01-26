import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/data/models/bank_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';

class BankAccountRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<List<Bank>> getBankList({int? language}) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/base/withdrawal/getBankList";

      var formData = FormData.fromMap({"language": language});

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
      var bankList = <Bank>[];

      for (var bank in response.data['data']) {
        bankList.add(Bank.fromJson(bank));
      }

      return bankList;
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<List<BankAccount>> getBankAccountList({
    int? language,
    int? size,
    int? pageNum,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/api/bankCard/queryBankCard";

      var formData = FormData.fromMap({
        "language": language,
        "size": size,
        "pageNum": pageNum,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
      var bankAccountList = <BankAccount>[];

      for (var bankAccount in response.data['data']) {
        bankAccountList.add(BankAccount.fromJson(bankAccount));
      }

      return bankAccountList;
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> insertBankAccount({
    String? bankCode,
    String? bank,
    String? code,
    String? name,
    int? language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/api/bankCard/saveBankCard";

      var formData = FormData.fromMap({
        "language": language,
        "bankCode": bankCode,
        "bank": bank,
        "code": code,
        "name": name,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> updateBankAccount({
    required int id,
    String? bankCode,
    String? bank,
    String? code,
    String? name,
    int? language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/api/bankCard/updateBankCard";

      var formData = FormData.fromMap({
        "id": id,
        "language": language,
        "bankCode": bankCode,
        "bank": bank,
        "code": code,
        "name": name,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> deleteBankAccountById({int? id, int? language}) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/api/bankCard/delBankCard";

      var formData = FormData.fromMap({"language": language, "id": id});

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }
}
