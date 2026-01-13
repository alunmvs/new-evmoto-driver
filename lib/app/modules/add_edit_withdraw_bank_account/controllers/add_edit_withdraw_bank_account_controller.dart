import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/data/models/bank_model.dart';
import 'package:new_evmoto_driver/app/modules/withdraw/controllers/withdraw_controller.dart';
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

  final isEdit = false.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getBankList();
    isEdit.value = Get.arguments?['is_edit'] ?? false;
    if (isEdit.value == true) {
      bankAccount.value = Get.arguments['bank_account'];
      formGroup.control("code").value = bankAccount.value.code;
      formGroup.control("name").value = bankAccount.value.name;
      for (var bank in bankList) {
        if (bank.code == bankAccount.value.bankCode) {
          formGroup.control("bank").value = bank;
        }
      }
    }
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
        if (isEdit.value == false) {
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
        } else {
          await bankAccountRepository.updateBankAccount(
            id: bankAccount.value.id!,
            bank: formGroup.control("bank").value.name,
            bankCode: formGroup.control("bank").value.code,
            code: formGroup.control("code").value,
            language: languageServices.languageCodeSystem.value,
            name: formGroup.control("name").value,
          );

          Get.find<WithdrawController>().isEditDeleteActive.value = false;

          Get.back();

          var snackBar = SnackBar(
            behavior: SnackBarBehavior.fixed,
            backgroundColor: themeColorServices.sematicColorGreen400.value,
            content: Text(
              "Berhasil mengubah rekening penarikan",
              style: typographyServices.bodySmallRegular.value.copyWith(
                color: themeColorServices.neutralsColorGrey0.value,
              ),
            ),
          );
          rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
        }
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
