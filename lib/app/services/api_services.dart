import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';

class ApiServices extends GetxService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 15),
    ),
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //       client.findProxy = (uri) {
    //         return "PROXY 192.168.18.158:8888";
    //       };

    //       client.badCertificateCallback =
    //           (X509Certificate cert, String host, int port) => true;

    //       return client;
    //     };

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.data != null) {
            if (response.data is Map<String, dynamic>) {
              if (response.data['code'] == 600) {
                if (Get.currentRoute != Routes.LOGIN) {
                  var storage = FlutterSecureStorage();
                  await storage.deleteAll();
                  await Get.find<SocketServices>().closeWebsocket();
                  Get.offAllNamed(Routes.LOGIN);
                }
              }
            }
          }

          return handler.next(response);
        },
      ),
    );

    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: 3,
        retryDelays: [
          Duration(seconds: 2),
          Duration(seconds: 4),
          Duration(seconds: 8),
        ],
        retryEvaluator: (error, attempt) {
          return true;
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          String message;

          if (e.type == DioExceptionType.connectionError ||
              e.error is SocketException) {
            message = 'Tidak ada koneksi internet. Periksa jaringan Anda.';
          } else if (e.type == DioExceptionType.receiveTimeout) {
            message = 'Koneksi timeout. Coba lagi.';
          } else {
            message = 'Terjadi kesalahan. Silakan coba lagi.';
          }

          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              message: message,
              type: e.type,
            ),
          );
        },
      ),
    );
  }
}
