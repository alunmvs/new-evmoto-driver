import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_curl_logger/dio_curl_logger.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/utils/error_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

class ApiServices extends GetxService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 15),
    ),
  );

  final deviceId = "".obs;
  final packageVersion = "".obs;
  final buildNumber = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await Future.wait([getPackageInfo(), getDeviceId()]);

    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //       client.findProxy = (uri) {
    //         return "PROXY 192.168.0.144:8888";
    //       };

    //       client.badCertificateCallback =
    //           (X509Certificate cert, String host, int port) => true;

    //       return client;
    //     };

    dio.interceptors.add(
      CurlLoggingInterceptor(showRequestLog: false, showResponseLog: false),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['version'] = packageVersion.value;
          options.headers['deviceid'] = deviceId.value;
          options.headers['timestamp'] = DateTime.now().millisecondsSinceEpoch
              .toString();
          options.headers['from'] = Platform.isAndroid
              ? "android"
              : Platform.isIOS
              ? "ios"
              : "others";
          options.headers['role'] = "driver";
          options.headers['nonce'] = generateMd5Timestamp();

          return handler.next(options);
        },

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
        retries: 999999999,
        retryEvaluator: (error, attempt) async {
          if (error.type == DioExceptionType.connectionError ||
              error.error is SocketException) {
            await showNoConnectivityInternetDialog(onRetry: () async {});
            return true;
          }

          return false;
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

  Future<void> getPackageInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    packageVersion.value = packageInfo.version;
    buildNumber.value = packageInfo.buildNumber;
  }

  Future<void> getDeviceId() async {
    var storage = FlutterSecureStorage();
    var deviceId = await storage.read(key: "device_id");

    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await storage.write(key: "device_id", value: deviceId);
    }

    this.deviceId.value = deviceId;
  }

  String generateMd5Timestamp() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = utf8.encode(timestamp);
    final digest = md5.convert(bytes);

    return digest.toString();
  }
}
