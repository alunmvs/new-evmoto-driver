import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/system_image_model.dart';
import 'package:new_evmoto_driver/app/repositories/system_image_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingIntroductionController extends GetxController {
  final SystemImageRepository systemImageRepository;

  OnboardingIntroductionController({required this.systemImageRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final carouselSliderController = CarouselSliderController();

  final systemImageList = <SystemImage>[].obs;
  final indexBanner = 0.0.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // isFetch.value = true;
    // await getIntroductionImageList();
    // isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getIntroductionImageList() async {
    systemImageList.value = await systemImageRepository.getSystemImageList(
      usePort: 2,
      language: 2,
      type: 2,
    );
  }

  Future<void> onTapNext() async {
    switch (indexBanner.value) {
      case 0.0:
        indexBanner.value = 1.0;
        carouselSliderController.animateToPage(1);
      case 1.0:
        indexBanner.value = 2.0;
        carouselSliderController.animateToPage(2);
      case 2.0:
        var prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_onboarding_introduction_shown', true);
        Get.offAndToNamed(Routes.LOGIN);
      default:
        return;
    }
  }

  Future<void> onTapSkip() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_onboarding_introduction_shown', true);
    Get.offAndToNamed(Routes.LOGIN);
  }
}
