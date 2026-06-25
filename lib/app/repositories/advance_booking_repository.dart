import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/active_advance_booking_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/environment.dart';

class AdvanceBookingRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<ActiveAdvanceBooking?> getActiveAdvanceBooking() async {
    try {
      var url = "$baseUrl/businessProcess/api/advanceBooking/driver/found";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.get(url, options: Options(headers: headers));

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return ActiveAdvanceBooking.fromJson(response.data['data'] ?? {});
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> advanceBookingConfirm({String? orderId}) async {
    try {
      var url = "$baseUrl/businessProcess/api/advanceBooking/driver/grab";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      await dio.post(
        url,
        data: {"orderId": orderId},
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> advanceBookingSecondConfirm({String? orderId}) async {
    try {
      var url =
          "$baseUrl/businessProcess/api/advanceBooking/driver/secondConfirm";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var formData = {"orderId": orderId};

      var dio = apiServices.dio;
      await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> advanceBookingCancel({String? orderId}) async {
    try {
      var url =
          "$baseUrl/businessProcess/api/advanceBooking/driver/cancelRunning";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var formData = {"orderId": orderId};

      var dio = apiServices.dio;
      await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }
}
