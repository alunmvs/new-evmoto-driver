import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class AccountUserGuideController extends GetxController {
  final AgreementRepository agreementRepository;

  AccountUserGuideController({required this.agreementRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final agreement = Agreement().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getUserGuideAgreement();
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

  Future<void> getUserGuideAgreement() async {
    agreement.value = await agreementRepository.getAgreementDetail(
      language: 2,
      userType: 2,
      type: 3,
    );
  }
}
