import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/account_update_mobile_phone_controller.dart';

class AccountUpdateMobilePhoneView
    extends GetView<AccountUpdateMobilePhoneController> {
  const AccountUpdateMobilePhoneView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Ubah Nomor Telepon",
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
                child: ReactiveForm(
                  formGroup: controller.formGroup,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            border: Border.all(color: Color(0XFFE8E8E8)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Masukan Nomor Telepon Lama",
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
                                readOnly: true,
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value,
                                cursorErrorColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                formControlName: 'old_mobile_phone',
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
                                  prefixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(width: 12),
                                      Text(
                                        "+62",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
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
                                  hintText: '812345678594',
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
                                "Masukan Nomor Telepon Baru",
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
                                cursorErrorColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                formControlName: 'new_mobile_phone',
                                maxLines: 1,
                                validationMessages: {
                                  ValidationMessage.required: (error) =>
                                      'Wajib diisi',
                                  ValidationMessage.minLength: (error) =>
                                      'Minimal nomor handphone 8 angka',
                                  ValidationMessage.maxLength: (error) =>
                                      'Maksimal nomor handphone 15 angka',
                                  ValidationMessage.pattern: (error) =>
                                      'Harus diawali dengan angka 8',
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  prefixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(width: 12),
                                      Text(
                                        "+62",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
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
                                  hintText: '812345678594',
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
                              SizedBox(
                                width: Get.width,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await controller.onTapSubmit();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: controller
                                        .themeColorServices
                                        .primaryBlue
                                        .value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    "Kirimkan Kode OTP",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                        ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: Text(
                                  "Kode OTP dikirimkan ke nomor baru",
                                  style: controller
                                      .typographyServices
                                      .captionLargeRegular
                                      .value
                                      .copyWith(color: Color(0XFFB3B3B3)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
