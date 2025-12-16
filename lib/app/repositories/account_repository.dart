import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/rating_and_review_model.dart';
import 'package:new_evmoto_driver/app/data/models/service_order_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';

class AccountRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<void> updateMobilePhone({
    String? password,
    String? phone,
    int? language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/api/driver/updatePhone";

      var formData = FormData.fromMap({
        "password": password,
        "language": language,
        "phone": phone,
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

  Future<List<ServiceOrder>> getServiceOrderList({
    required int size,
    required int pageNum,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/app/api/driver/querySetOrders";

      var formData = FormData.fromMap({
        "size": size,
        "language": language,
        "pageNum": pageNum,
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      var serviceOrderList = <ServiceOrder>[];

      for (var serviceOrder in response.data['data']) {
        serviceOrderList.add(ServiceOrder.fromJson(serviceOrder));
      }

      return serviceOrderList;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> updateServiceOrderStatus({int? language, int? type}) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/driver/api/driver/updateOrders";

      var formData = FormData.fromMap({"language": language, "type": type});

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> createFeedback({
    int? language,
    int? type,
    String? content,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/evaluation/api/feedback/feedback";

      var formData = FormData.fromMap({
        "language": language,
        "type": type,
        "content": content,
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

  Future<RatingAndReview> getRatingAndReviewDetail({
    required int size,
    required int pageNum,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/evaluation/api/orderEvaluate/queryEvaluate";

      var formData = FormData.fromMap({
        "size": size,
        "language": language,
        "pageNum": pageNum,
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return RatingAndReview.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
