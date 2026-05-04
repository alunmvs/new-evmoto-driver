import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/coupon_income_model.dart';
import 'package:new_evmoto_driver/app/data/models/guarantee_income_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/environment.dart';

class GuaranteeIncomeRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

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
}
