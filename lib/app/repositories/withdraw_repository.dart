import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/revenue_statistics_model.dart';
import 'package:new_evmoto_driver/app/data/models/withdrawal_history_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';

class WithdrawRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<void> requestWithdrawal({
    required String code,
    required double money,
    required String name,
    required String bankName,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/api/withdrawal/withdrawal";

      var formData = FormData.fromMap({
        "language": language,
        "code": code,
        "money": money,
        "name": name,
        "bankName": bankName,
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
      rethrow;
    }
  }

  Future<List<WithdrawalHistory>> getWithdrawalHistoryList({
    required int size,
    required int pageNum,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/api/withdrawal/withdrawal";

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

      var withdrawalHistoryList = <WithdrawalHistory>[];

      for (var withdrawalHistory in response.data['data']) {
        withdrawalHistoryList.add(
          WithdrawalHistory.fromJson(withdrawalHistory),
        );
      }

      return withdrawalHistoryList;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<RevenueStatistics> getRevenueStatistics({
    required int size,
    required int pageNum,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/payment/api/driver/queryTotalRevenue";

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

      return RevenueStatistics.fromJson(response.data);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<double> getAdminFeeByBankCode({required String bankCode}) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/payment/api/system-parameter/get/bank_fee_$bankCode";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.get(url, options: Options(headers: headers));

      return double.parse(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
