import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/service_order_model.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';

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
      language: 2,
    );
  }

  Future<void> onTapSave() async {
    for (var serviceOrder in serviceOrderList) {
      if (serviceOrder.state != serviceOrder.updatedState) {
        try {
          await accountRepository.updateServiceOrderStatus(
            language: 2,
            type: serviceOrder.type,
          );
        } catch (e) {
          final SnackBar snackBar = SnackBar(
            behavior: SnackBarBehavior.fixed,
            backgroundColor: themeColorServices.sematicColorRed400.value,
            content: Text(
              e.toString(),
              style: typographyServices.bodySmallRegular.value.copyWith(
                color: themeColorServices.neutralsColorGrey0.value,
              ),
            ),
          );
          rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);

          return;
        }
      }
    }

    Get.back();
    final SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: themeColorServices.sematicColorGreen400.value,
      content: Text(
        languageServices.language.value.successSaveChanges ?? "-",
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
    );
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    return;
  }
}
