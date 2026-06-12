import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/background_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_driver/app/services/location_services.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  Future<void> logout({
    String? successMessage,
    String? errorMessage,
  }) async {
    final apiServices = Get.find<ApiServices>();
    if (apiServices.isSessionEnding) return;

    final backgroundServices = Get.find<BackgroundServices>();
    final userServices = Get.find<UserServices>();
    final firebasePushNotificationServices =
        Get.find<FirebasePushNotificationServices>();
    final locationServices = Get.find<LocationServices>();
    final socketServices = Get.find<SocketServices>();
    var prefs = await SharedPreferences.getInstance();
    var storage = FlutterSecureStorage();

    await backgroundServices.clearAllState();
    await locationServices.positionStream?.cancel();
    await firebasePushNotificationServices.onUnsubscribe();

    apiServices.beginSessionEnd();

    await Future.wait([
      backgroundServices.stopService(),
      storage.deleteAll(),
      socketServices.closeWebsocket(),
      prefs.clear(),
    ]);

    userServices.clearUserInfo();

    if (Get.currentRoute != Routes.LOGIN) {
      Get.offAllNamed(Routes.LOGIN);
    }

    if (successMessage != null) {
      SnackbarHelper.showSnackbarSuccess(text: successMessage);
    } else if (errorMessage != null) {
      SnackbarHelper.showSnackbarError(text: errorMessage);
    }
  }
}
