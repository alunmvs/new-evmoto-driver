import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/withdraw_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:reactive_forms/reactive_forms.dart';

class WithdrawAmountController extends GetxController {
  final WithdrawRepository withdrawRepository;

  WithdrawAmountController({required this.withdrawRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  final homeController = Get.find<HomeController>();

  final formGroup = FormGroup({
    "money": FormControl<String>(validators: <Validator>[Validators.required]),
  });

  final isInfoExpanded = false.obs;

  final selectedBankAccount = BankAccount().obs;
  final adminFee = 0.0.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    selectedBankAccount.value =
        Get.arguments?['selected_bank_account'] ?? BankAccount();
    await getAdminFee();
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

  Future<void> getAdminFee() async {
    adminFee.value = await withdrawRepository.getAdminFeeByBankCode(
      bankCode: selectedBankAccount.value.bankCode!,
    );
  }

  Future<void> onTapSubmit() async {
    if (formGroup.valid) {
      var withdrawAmount = double.parse(
        formGroup.control("money").value.toString().replaceAll(".", ""),
      );

      var withdrawAmountMin = firebaseRemoteConfigServices.remoteConfig.getInt(
        "driver_withdraw_min",
      );

      if (withdrawAmount < withdrawAmountMin) {
        final SnackBar snackBar = SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: themeColorServices.sematicColorRed400.value,
          content: Text(
            "Minimum penarikan dana ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(withdrawAmountMin)}",
            style: typographyServices.bodySmallRegular.value.copyWith(
              color: themeColorServices.neutralsColorGrey0.value,
            ),
          ),
        );
        rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
        return;
      }

      await Get.bottomSheet(
        isScrollControlled: true,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Konfirmasi Penarikan Dana",
                            style: typographyServices.bodyLargeBold.value,
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_close.svg",
                                  width: 12,
                                  height: 12,
                                  color: themeColorServices.textColor.value,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: themeColorServices.neutralsColorGrey200.value,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Penerima",
                            style: typographyServices.bodySmallRegular.value
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0XFFF8F8F8),
                              border: Border.all(color: Color(0XFFD4D4D4)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                // SizedBox(
                                //   height: 35,
                                //   width: 35,
                                //   child: Placeholder(),
                                // ),
                                // SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedBankAccount.value.name ?? "-",
                                      style: typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(color: Color(0XFF7D7D7D)),
                                    ),
                                    Text(
                                      selectedBankAccount.value.code!.length < 5
                                          ? "*****"
                                          : selectedBankAccount.value.code!
                                                .replaceRange(0, 5, "***** "),
                                      style: typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(color: Color(0XFF7D7D7D)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(
                            height: 0,
                            color:
                                themeColorServices.neutralsColorGrey200.value,
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Color(0XFFB3B3B3)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nominal Penarikan Dana",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color: Color(0XFFB3B3B3),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp',
                                    decimalDigits: 0,
                                  ).format(withdrawAmount),
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color:
                                            themeColorServices.textColor.value,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Biaya Admin Penarikan",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color: Color(0XFFB3B3B3),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      "* ",
                                      style: typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: themeColorServices
                                                .sematicColorRed400
                                                .value,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp',
                                        decimalDigits: 0,
                                      ).format(adminFee.value),
                                      style: typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: themeColorServices
                                                .textColor
                                                .value,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Divider(
                                  height: 0,
                                  color: themeColorServices
                                      .neutralsColorGrey200
                                      .value,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Total Penarikan Dana",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFFB3B3B3),
                                      ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp',
                                    decimalDigits: 0,
                                  ).format(withdrawAmount - adminFee.value),
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color:
                                            themeColorServices.textColor.value,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16 * 2),
                          SizedBox(
                            width: Get.width,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  await withdrawRepository.requestWithdrawal(
                                    bankName: selectedBankAccount.value.bank!,
                                    code: selectedBankAccount.value.code!,
                                    language: languageServices
                                        .languageCodeSystem
                                        .value,
                                    money: withdrawAmount,
                                    name: selectedBankAccount.value.name!,
                                  );

                                  Get.close(1);
                                  Get.back();
                                  Get.back();

                                  var snackBar = SnackBar(
                                    behavior: SnackBarBehavior.fixed,
                                    backgroundColor: themeColorServices
                                        .sematicColorGreen400
                                        .value,
                                    content: Text(
                                      "Berhasil pengajuan penarikan dana",
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

                                  Get.toNamed(Routes.HISTORY_BALANCE_WITHDRAW);
                                } catch (e) {
                                  Get.close(1);
                                  final SnackBar snackBar = SnackBar(
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    themeColorServices.primaryBlue.value,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                "Konfirmasi",
                                style: typographyServices.bodySmallBold.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
