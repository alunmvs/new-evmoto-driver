import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/data/models/bank_model.dart';
import 'package:new_evmoto_driver/app/repositories/bank_account_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddEditWithdrawBankAccountController extends GetxController {
  final BankAccountRepository bankAccountRepository;

  AddEditWithdrawBankAccountController({required this.bankAccountRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final formGroup = FormGroup({
    "bank": FormControl<Bank>(validators: <Validator>[Validators.required]),
    "code": FormControl<String>(validators: <Validator>[Validators.required]),
    "name": FormControl<String>(validators: <Validator>[Validators.required]),
  });

  final bankAccount = BankAccount().obs;
  final bankList = <Bank>[].obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getBankList();
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

  Future<void> getBankList() async {
    bankList.value = await bankAccountRepository.getBankList(
      language: languageServices.languageCodeSystem.value,
    );
  }

  Future<void> onTapSubmit() async {
    formGroup.markAllAsTouched();

    if (formGroup.valid) {
      try {
        await bankAccountRepository.insertBankAccount(
          bank: formGroup.control("bank").value.name,
          bankCode: formGroup.control("bank").value.code,
          code: formGroup.control("code").value,
          language: languageServices.languageCodeSystem.value,
          name: formGroup.control("name").value,
        );

        Get.back();

        var snackBar = SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: themeColorServices.sematicColorGreen400.value,
          content: Text(
            "Berhasil menambah rekening penarikan",
            style: typographyServices.bodySmallRegular.value.copyWith(
              color: themeColorServices.neutralsColorGrey0.value,
            ),
          ),
        );
        rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      } catch (e) {
        var snackBar = SnackBar(
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
      }
    }
  }
}
