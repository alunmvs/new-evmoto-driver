import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/service_order_model.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';

class AccountServiceController extends GetxController {
  final AccountRepository accountRepository;

  AccountServiceController({required this.accountRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final serviceOrderList = <ServiceOrder>[].obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getServiceOrderList();
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

  Future<void> getServiceOrderList() async {
    serviceOrderList.value = await accountRepository.getServiceOrderList(
      size: 999999,
      pageNum: 1,
      language: languageServices.languageCodeSystem.value,
    );
  }

  Future<void> onTapSave() async {
    for (var serviceOrder in serviceOrderList) {
      if (serviceOrder.state != serviceOrder.updatedState) {
        try {
          await accountRepository.updateServiceOrderStatus(
            language: languageServices.languageCodeSystem.value,
            type: serviceOrder.type,
          );
        } catch (e) {
          SnackbarHelper.showSnackbarError(text: e.toString());
          return;
        }
      }
    }

    Get.back();
    SnackbarHelper.showSnackbarSuccess(
      text: languageServices.language.value.successSaveChanges ?? "-",
    );
    return;
  }
}
