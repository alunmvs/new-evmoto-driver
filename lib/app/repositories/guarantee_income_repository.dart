import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/coupon_income_model.dart';
import 'package:new_evmoto_driver/app/data/models/guarantee_income_approval_model.dart';
import 'package:new_evmoto_driver/app/data/models/guarantee_income_model.dart';
import 'package:new_evmoto_driver/app/data/models/guarantee_income_progress_bar_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/environment.dart';

class GuaranteeIncomeRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<List<GuaranteeIncomeApproval>> getGuaranteeIncomeApprovalList({
    required String startDate,
    required String endDate,
  }) async {
    try {
      var url = "$baseUrl/activity/base/driver/queryGIHistory";

      var queryParameters = {"startDate": startDate, "endDate": endDate};

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      var guaranteeIncomeApprovalList = <GuaranteeIncomeApproval>[];

      for (var guaranteeIncomeApproval in response.data?['data'] ?? []) {
        guaranteeIncomeApprovalList.add(
          GuaranteeIncomeApproval.fromJson(guaranteeIncomeApproval),
        );
      }

      return guaranteeIncomeApprovalList;
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<GuaranteeIncome> getGuaranteeIncome({
    int? driverId,
    int? ensureIncomeRuleId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      var url = "$baseUrl/app/driver/onlineDuration";

      var data = {
        "driverId": driverId,
        "ensureIncomeRuleId": ensureIncomeRuleId,
        "startDate": startDate,
        "endDate": endDate,
      };

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return GuaranteeIncome.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<List<GuaranteeIncomeProgressBar>> getGuaranteeIncomeProgressBarList({
    required int? ensureIncomeRuleId,
  }) async {
    try {
      var url = "$baseUrl/app/ensureIncomeFoundation/getListByEnsureIncomeId";

      print("[DEBUG SERVICE AREA] ${url}");

      var data = {"ensureIncomeRuleId": ensureIncomeRuleId};

      print("[DEBUG SERVICE AREA] ${data}");

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      var guaranteeIncomeProgressBarList = <GuaranteeIncomeProgressBar>[];

      for (var guaranteeIncomeProgressBar in response.data['data']) {
        guaranteeIncomeProgressBarList.add(
          GuaranteeIncomeProgressBar.fromJson(guaranteeIncomeProgressBar),
        );
      }

      return guaranteeIncomeProgressBarList;
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<CouponIncome> getCouponIncome({
    int? driverId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      var url = "$baseUrl/app/driver/couponIncome";

      var data = {
        "driverId": driverId,
        "startDate": startDate,
        "endDate": endDate,
      };

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return CouponIncome.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<bool> isWithinGuaranteeIncomeArea({
    required int serviceAreaId,
    required double lat,
    required double lng,
  }) async {
    try {
      var url =
          "$baseUrl/app/service-area/$serviceAreaId/guarantee-income/within";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.get(
        url,
        queryParameters: {"lat": lat, "lng": lng},
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return response.data['data']?['within'] == true;
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<int?> getActiveEnsureIncomeRuleId({
    required double? lat,
    required double? lon,
  }) async {
    try {
      var url = "$baseUrl/app/ensureIncomeRule/active";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: {"lon": lon, "lat": lat},
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      if (response.data['data'] != null) {
        if (response.data['data'].length > 0) {
          return response.data['data'][0];
        }
      }
      return null;
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }
}
