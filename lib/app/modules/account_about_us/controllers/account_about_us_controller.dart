import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';
import 'package:new_evmoto_driver/app/repositories/agreement_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class AccountAboutUsController extends GetxController {
  final AgreementRepository agreementRepository;

  AccountAboutUsController({required this.agreementRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final agreement = Agreement().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getAboutUsAgreement();
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

  Future<void> getAboutUsAgreement() async {
    agreement.value = await agreementRepository.getAgreementDetail(
      language: 2,
      userType: 2,
      type: 5,
    );
  }
}
