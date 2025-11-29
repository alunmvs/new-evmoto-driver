import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class SplashScreenController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final isFetch = false.obs;
  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(seconds: 3)).whenComplete(() {
      Get.offAndToNamed(Routes.ONBOARDING_INTRODUCTION);
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
