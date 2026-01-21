import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/bank_account_repository.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_driver/main.dart';

class WithdrawController extends GetxController {
  final BankAccountRepository bankAccountRepository;

  WithdrawController({required this.bankAccountRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  final homeController = Get.find<HomeController>();

  final isInfoExpanded = false.obs;

  final bankAccountList = <BankAccount>[].obs;
  final bankAccountPageNum = 1.obs;
  final bankAccountSize = 10.obs;
  final isSeeMoreBankAccount = true.obs;

  final isEditDeleteActive = false.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getBankAccountList();
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

  Future<void> getBankAccountList() async {
    bankAccountPageNum.value = 1;
    isSeeMoreBankAccount.value = true;

    bankAccountList.value = await bankAccountRepository.getBankAccountList(
      pageNum: bankAccountPageNum.value,
      language: languageServices.languageCodeSystem.value,
      size: bankAccountSize.value,
    );

    if (bankAccountList.isEmpty) {
      isSeeMoreBankAccount.value = false;
    }
  }

  Future<void> seeMoreBankAccountList() async {
    bankAccountPageNum.value += 1;

    var bankAccountList = await bankAccountRepository.getBankAccountList(
      pageNum: bankAccountPageNum.value,
      language: languageServices.languageCodeSystem.value,
      size: bankAccountSize.value,
    );

    if (bankAccountList.isEmpty) {
      isSeeMoreBankAccount.value = false;
    }

    this.bankAccountList.addAll(bankAccountList);
  }

  Future<void> onTapDeleteBankAccount({
    required BankAccount bankAccount,
  }) async {
    await Get.dialog(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Apakah Anda yakin ingin menghapus nomor rekening?",
                        style: typographyServices.bodyLargeBold.value,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              width: Get.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: themeColorServices
                                        .neutralsColorGrey300
                                        .value,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  Get.close(1);
                                },
                                child: Text(
                                  "Batal",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: LoaderElevatedButton(
                              onPressed: () async {
                                try {
                                  await bankAccountRepository
                                      .deleteBankAccountById(
                                        id: bankAccount.id,
                                        language: languageServices
                                            .languageCodeSystem
                                            .value,
                                      );
                                  Get.close(1);

                                  var snackBar = SnackBar(
                                    behavior: SnackBarBehavior.fixed,
                                    backgroundColor: themeColorServices
                                        .sematicColorGreen400
                                        .value,
                                    content: Text(
                                      "Berhasil menghapus nomor rekening",
                                      style: typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: themeColorServices
                                                .neutralsColorGrey0
                                                .value,
                                          ),
                                    ),
                                  );
                                  rootScaffoldMessengerKey.currentState
                                      ?.showSnackBar(snackBar);

                                  await getBankAccountList();
                                } catch (e) {
                                  var snackBar = SnackBar(
                                    behavior: SnackBarBehavior.fixed,
                                    backgroundColor: themeColorServices
                                        .sematicColorRed400
                                        .value,
                                    content: Text(
                                      e.toString(),
                                      style: typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: themeColorServices
                                                .neutralsColorGrey0
                                                .value,
                                          ),
                                    ),
                                  );
                                  rootScaffoldMessengerKey.currentState
                                      ?.showSnackBar(snackBar);
                                }
                              },
                              buttonColor:
                                  themeColorServices.sematicColorRed400.value,
                              child: Text(
                                "Hapus",
                                style: typographyServices.bodySmallBold.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
