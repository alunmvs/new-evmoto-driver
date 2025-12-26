import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/system_image_repository.dart';

import '../controllers/onboarding_introduction_controller.dart';

class OnboardingIntroductionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingIntroductionController>(
      () => OnboardingIntroductionController(
        systemImageRepository: SystemImageRepository(),
      ),
    );
  }
}
