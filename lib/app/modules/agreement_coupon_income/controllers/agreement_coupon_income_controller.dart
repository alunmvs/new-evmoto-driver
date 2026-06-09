import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class AgreementCouponIncomeController extends GetxController {
  final AgreementRepository agreementRepository;

  AgreementCouponIncomeController({required this.agreementRepository});

  final agreement = Agreement().obs;

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getCouponIncomeAgreement();
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

  Future<void> getCouponIncomeAgreement() async {
    agreement.value = await agreementRepository.getAgreementDetail(
      language: languageServices.languageCodeSystem.value,
      userType: 2,
      type: 18,
    );
  }
}
