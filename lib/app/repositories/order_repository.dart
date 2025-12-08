import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/order_detail_model.dart';
import 'package:new_evmoto_driver/app/data/order_model.dart';
import 'package:new_evmoto_driver/app/data/order_payment_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/main.dart';

class OrderRepository {
  final apiServices = Get.find<ApiServices>();

  Future<List<Order>> getOrderList({
    required int size,
    required int language,
    required int state,
    required int pageNum,
  }) async {
    try {
      var url = "$baseUrl/orderServer/api/order/queryOrderList";

      var formData = FormData.fromMap({
        "language": language,
        "size": size,
        "state": state,
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

      var orderList = <Order>[];

      for (var order in response.data['data']) {
        orderList.add(Order.fromJson(order));
      }

      return orderList;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> grabOrder({
    required int orderType,
    required String orderId,
    required int language,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/order/grabOrder";

      var formData = FormData.fromMap({
        "language": language,
        "orderType": orderType,
        "orderId": orderId,
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

  Future<OrderDetail> getOrderDetail({
    required int orderType,
    required String orderId,
    required int language,
  }) async {
    try {
      var url = "$baseUrl/orderServer/api/order/queryOrderInfo_driver";

      var formData = FormData.fromMap({
        "orderType": orderType,
        "orderId": orderId,
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

      return OrderDetail.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> setOrderState({
    required int orderType,
    required String orderId,
    required String lat,
    required String lon,
    required int language,
    required int state,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/order/process";

      var formData = FormData.fromMap({
        "orderType": orderType,
        "orderId": orderId,
        "lon": lon,
        "lat": lat,
        "state": state,
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

      print(token);

      print({
        "orderType": orderType,
        "orderId": orderId,
        "lon": lon,
        "lat": lat,
        "state": state,
        "language": language,
      });
      print(response.data);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<OrderPayment> getOrderPayment({
    required int orderType,
    required String orderId,
    required int language,
    required int payManner,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/order/queryMoneyInfo";

      var formData = FormData.fromMap({
        "orderType": orderType,
        "orderId": orderId,
        "payManner": payManner,
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

      return OrderPayment.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> confirmOrderPayment({
    required int orderType,
    required String orderId,
    required int language,
    required int payManner,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/order/confirmFees";

      var formData = FormData.fromMap({
        "orderType": orderType,
        "orderId": orderId,
        "payManner": payManner,
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
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> confirmCashReceived({
    required int orderType,
    required String orderId,
    required int language,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/order/completeOrder";

      var formData = FormData.fromMap({
        "orderType": orderType,
        "orderId": orderId,
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
    } on DioException catch (e) {
      rethrow;
    }
  }
}
