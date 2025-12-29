import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/history_balance_recharge_model.dart';
import 'package:new_evmoto_driver/app/data/models/history_balance_revenue_model.dart';
import 'package:new_evmoto_driver/app/data/models/history_balance_withdraw_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';

class HistoryBalanceRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<List<HistoryBalanceWithdraw>> getHistoryWithdrawList({
    required int size,
    required int pageNum,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/payment/api/pubWithdrawal/queryDriverPubWithdrawal";

      var formData = FormData.fromMap({
        "size": size,
        "pageNum": pageNum,
        "language": language,
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

      var historyBalanceWithdrawList = <HistoryBalanceWithdraw>[];

      for (var historyBalanceWithdraw in response.data['data']) {
        historyBalanceWithdrawList.add(
          HistoryBalanceWithdraw.fromJson(historyBalanceWithdraw),
        );
      }

      return historyBalanceWithdrawList;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<HistoryBalanceRevenue> getHistoryRevenueList({
    required int size,
    required int pageNum,
    required int language,
    String? startTime,
    String? endTime,
    int? type,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/payment/api/driver/queryTotalRevenue";

      var formData = FormData.fromMap({
        "size": size,
        "pageNum": pageNum,
        "language": language,
        "startTime": startTime,
        "endTime": endTime,
        "type": type,
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

      return HistoryBalanceRevenue.fromJson(response.data);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<HistoryBalanceRecharge>> getHistoryRechargeList({
    required int size,
    required int pageNum,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/payment/api/rechargeRecord/queryDriverRechargeRecord";

      var formData = FormData.fromMap({
        "size": size,
        "pageNum": pageNum,
        "language": language,
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

      var historyBalanceRechargeList = <HistoryBalanceRecharge>[];

      for (var historyBalanceRecharge in response.data['data']) {
        historyBalanceRechargeList.add(
          HistoryBalanceRecharge.fromJson(historyBalanceRecharge),
        );
      }

      return historyBalanceRechargeList;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
