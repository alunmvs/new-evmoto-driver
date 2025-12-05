import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_evmoto_driver/app/data/order_model.dart';
import 'package:new_evmoto_driver/main.dart';

class OrderRepository {
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

      var dio = Dio();
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
