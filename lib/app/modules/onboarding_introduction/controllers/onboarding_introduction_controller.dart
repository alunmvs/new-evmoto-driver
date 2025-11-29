import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/system_image_model.dart';
import 'package:new_evmoto_driver/app/repositories/system_image_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class OnboardingIntroductionController extends GetxController {
  final SystemImageRepository systemImageRepository;

  OnboardingIntroductionController({required this.systemImageRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final systemImageList = <SystemImage>[].obs;
  final indexBanner = 0.0.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getIntroductionImageList();
    isFetch.value = false;
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
}
