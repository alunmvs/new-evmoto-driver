import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/add_edit_withdraw_bank_account_controller.dart';

class AddEditWithdrawBankAccountView
    extends GetView<AddEditWithdrawBankAccountController> {
  const AddEditWithdrawBankAccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.isEdit.value
                ? "Ubah Rekening Penarikan"
                : "Tambah Rekening Penarikan",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.backgroundColor.value,
        body: controller.isFetch.value
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ReactiveForm(
                    formGroup: controller.formGroup,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          "Nama Pemilik Rekening",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .textColor
                                    .value,
                              ),
                        ),
                        SizedBox(height: 8),
                        ReactiveTextField(
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          cursorErrorColor:
                              controller.themeColorServices.primaryBlue.value,
                          formControlName: 'name',
                          maxLines: 1,
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'Wajib diisi',
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            hintText: 'Masukkan nama pemilik rekening',
                            hintStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                                ),
                            errorStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorRed500
                                      .value,
                                ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Pilih Bank",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .textColor
                                    .value,
                              ),
                        ),
                        SizedBox(height: 8),
                        ReactiveDropdownField(
                          isExpanded: true,
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .textColor
                                    .value,
                              ),
                          dropdownColor: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationRequired ??
                                "-",
                          },
                          items: [
                            for (var bank in controller.bankList) ...[
                              DropdownMenuItem(
                                value: bank,
                                child: Text(
                                  bank.name ?? "-",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ],
                          formControlName: 'bank',
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            suffix: SizedBox(width: 12),
                            prefix: SizedBox(width: 12),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 12),
                                Text(
                                  "Pilih bank",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                      ),
                                ),
                              ],
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            errorStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorRed500
                                      .value,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Nomor Rekening",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .textColor
                                    .value,
                              ),
                        ),
                        SizedBox(height: 8),
                        ReactiveTextField(
                          keyboardType: TextInputType.number,
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          cursorErrorColor:
                              controller.themeColorServices.primaryBlue.value,
                          formControlName: 'code',
                          maxLines: 1,
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'Wajib diisi',
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            hintText: 'Masukkan nomor rekening',
                            hintStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                                ),
                            errorStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorRed500
                                      .value,
                                ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          color: Color(0XFFF7F7F7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoaderElevatedButton(
                onPressed: () async {
                  await controller.onTapSubmit();
                },
                child: Text(
                  controller.isEdit.value ? "Simpan" : "Tambah",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
