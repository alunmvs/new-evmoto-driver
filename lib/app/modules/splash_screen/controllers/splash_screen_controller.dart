import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final isFetch = false.obs;
  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(seconds: 3)).whenComplete(() async {
      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      if (token == null || token == "") {
        var prefs = await SharedPreferences.getInstance();
        var isOnboardingIntroductionShown = prefs.getBool(
          'is_onboarding_introduction_shown',
        );
        if (isOnboardingIntroductionShown == true) {
          Get.offAndToNamed(Routes.LOGIN);
        } else {
          Get.offAndToNamed(Routes.ONBOARDING_INTRODUCTION);
        }
      } else {
        Get.offAndToNamed(Routes.HOME);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
