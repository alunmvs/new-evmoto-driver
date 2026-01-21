import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/register_form_controller.dart';

class RegisterFormView extends GetView<RegisterFormController> {
  const RegisterFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ReactiveForm(
                    formGroup: controller.formGroup,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Image.asset(
                          "assets/logos/logo_evmoto.png",
                          width: 95.46,
                          height: 29.56,
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .registerFormTitle ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .headingSmallBold
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .textColor
                                            .value,
                                      ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .registerFormDescription ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .secondaryTextColor
                                            .value,
                                      ),
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              "assets/images/img_progress_register_2_of_3.svg",
                              width: 72,
                              height: 72,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formTitleIdCardPhoto ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        if (controller.idPhotoUrl.value == "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: GestureDetector(
                              onTap: () async {
                                await controller.onTapUploadIdPhoto();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: controller.isFormValid.value
                                        ? controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value
                                        : controller
                                              .themeColorServices
                                              .sematicColorRed500
                                              .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_image_upload.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (controller.isFormValid.value == false) ...[
                            SizedBox(height: 4),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formValidationRequired ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                            ),
                          ],
                        ],
                        if (controller.idPhotoUrl.value != "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: controller.idPhotoUrl.value,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .imageUploadMenuBackgroundColor
                                            .value,
                                      ),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await controller
                                                    .onTapUploadIdPhoto();
                                              },
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .updatePhoto ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .textColor
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            VerticalDivider(
                                              width: 0,
                                              color: controller
                                                  .themeColorServices
                                                  .imageUploadVerticalDividerColor
                                                  .value,
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                controller.idPhotoUrl.value =
                                                    "";
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_delete.svg",
                                                    width: 16,
                                                    height: 16,
                                                    color: controller
                                                        .themeColorServices
                                                        .redColor
                                                        .value,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .delete ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodyLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .redColor
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formTitleFullName ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        ReactiveTextField(
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          cursorErrorColor:
                              controller.themeColorServices.primaryBlue.value,
                          formControlName: 'full_name',
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationRequired ??
                                "-",
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            prefix: SizedBox(width: 12),
                            suffix: SizedBox(width: 12),
                            hintText:
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formHintFullName ??
                                "-",
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
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formTitleGender ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
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
                            DropdownMenuItem(
                              value: 1,
                              child: Text(
                                controller
                                        .languageServices
                                        .language
                                        .value
                                        .male ??
                                    "-",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(
                                controller
                                        .languageServices
                                        .language
                                        .value
                                        .female ??
                                    "-",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value,
                              ),
                            ),
                          ],
                          formControlName: 'gender_id',
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
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .formHintGender ??
                                      "-",
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
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formTitleDomicile ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ReactiveDropdownField(
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
                                  onChanged: (control) {
                                    controller.refreshCityList(
                                      provinceId: control.value!,
                                    );
                                  },
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
                                    for (var province
                                        in controller.provinceCitiesList) ...[
                                      DropdownMenuItem(
                                        value: province.id,
                                        child: Text(
                                          province.name ?? "-",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ],
                                  formControlName: 'domicile_province',
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 12,
                                    ),
                                    prefix: SizedBox(width: 12),
                                    suffix: SizedBox(width: 12),

                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(width: 12),
                                        Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .formHintDomicileProvince ??
                                              "-",
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
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
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
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: ReactiveDropdownField(
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
                                    for (var city in controller.citiesList) ...[
                                      DropdownMenuItem(
                                        value: city.id,
                                        child: Text(
                                          city.name ?? "-",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ],
                                  formControlName: 'domicile_city',
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 12,
                                    ),
                                    prefix: SizedBox(width: 12),
                                    suffix: SizedBox(width: 12),

                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(width: 12),
                                        Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .formHintDomicileCity ??
                                              "-",
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
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formTitleIdCardNumber ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        ReactiveTextField(
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          cursorErrorColor:
                              controller.themeColorServices.primaryBlue.value,
                          formControlName: 'identity_number',
                          keyboardType: TextInputType.number,
                          maxLength: 16,
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationRequired ??
                                "-",
                            ValidationMessage.minLength: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationNikMinLength ??
                                "-",
                            ValidationMessage.maxLength: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationNikMaxLength ??
                                "-",
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            prefix: SizedBox(width: 12),
                            suffix: SizedBox(width: 12),
                            hintText:
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formHintIdCardNumber ??
                                "-",
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
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formTitleDrivingStartAt ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        ReactiveTextField(
                          readOnly: true,
                          formControlName: 'driving_experience',
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          cursorErrorColor:
                              controller.themeColorServices.primaryBlue.value,
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationRequired ??
                                "-",
                          },
                          onTap: (value) async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    datePickerTheme: DatePickerThemeData(
                                      headerForegroundColor: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                      headerBackgroundColor: controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                      headerHeadlineStyle: controller
                                          .typographyServices
                                          .headingMediumBold
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey0
                                                .value,
                                          ),
                                      weekdayStyle: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .thirdTextColor
                                                .value,
                                          ),
                                      dayStyle: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .textColor
                                                .value,
                                          ),
                                      yearStyle: controller
                                          .typographyServices
                                          .bodyLargeRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .textColor
                                                .value,
                                          ),
                                    ),
                                    colorScheme: ColorScheme.light(
                                      primary: controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                      onPrimary: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                      onSurface: controller
                                          .themeColorServices
                                          .textColor
                                          .value,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              controller.formGroup
                                  .control('driving_experience')
                                  .value = DateFormat(
                                'yyyy-MM-dd',
                              ).format(pickedDate);
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            prefix: SizedBox(width: 12),
                            suffix: SizedBox(width: 12),
                            hintText:
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formHintDrivingStartAt ??
                                "-",
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
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formTitleDriverLicensePhoto ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        if (controller.drivingLicensePhotoUrl.value == "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: GestureDetector(
                              onTap: () async {
                                await controller.onTapUploadDriverLicense();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: controller.isFormValid.value == true
                                        ? controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value
                                        : controller
                                              .themeColorServices
                                              .sematicColorRed500
                                              .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_image_upload.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (controller.isFormValid.value == false) ...[
                            SizedBox(height: 4),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formValidationRequired ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                            ),
                          ],
                        ],
                        if (controller.drivingLicensePhotoUrl.value != "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: controller
                                          .drivingLicensePhotoUrl
                                          .value,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .imageUploadMenuBackgroundColor
                                            .value,
                                      ),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await controller
                                                    .onTapUploadDriverLicense();
                                              },
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .updatePhoto ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .textColor
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            VerticalDivider(
                                              width: 0,
                                              color: controller
                                                  .themeColorServices
                                                  .imageUploadVerticalDividerColor
                                                  .value,
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                controller
                                                        .drivingLicensePhotoUrl
                                                        .value =
                                                    "";
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_delete.svg",
                                                    width: 16,
                                                    height: 16,
                                                    color: controller
                                                        .themeColorServices
                                                        .redColor
                                                        .value,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .delete ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodyLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .redColor
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "Foto STNK Depan",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        if (controller
                                .vehicleRegistrationCertificateFrontPhotoUrl
                                .value ==
                            "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: GestureDetector(
                              onTap: () async {
                                await controller
                                    .onTapUploadvehicleRegistrationCertificateFront();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: controller.isFormValid.value == true
                                        ? controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value
                                        : controller
                                              .themeColorServices
                                              .sematicColorRed500
                                              .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_image_upload.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (controller.isFormValid.value == false) ...[
                            SizedBox(height: 4),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formValidationRequired ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                            ),
                          ],
                        ],
                        if (controller
                                .vehicleRegistrationCertificateFrontPhotoUrl
                                .value !=
                            "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: controller
                                          .vehicleRegistrationCertificateFrontPhotoUrl
                                          .value,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .imageUploadMenuBackgroundColor
                                            .value,
                                      ),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await controller
                                                    .onTapUploadvehicleRegistrationCertificateFront();
                                              },
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .updatePhoto ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .textColor
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            VerticalDivider(
                                              width: 0,
                                              color: controller
                                                  .themeColorServices
                                                  .imageUploadVerticalDividerColor
                                                  .value,
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                controller
                                                        .vehicleRegistrationCertificateFrontPhotoUrl
                                                        .value =
                                                    "";
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_delete.svg",
                                                    width: 16,
                                                    height: 16,
                                                    color: controller
                                                        .themeColorServices
                                                        .redColor
                                                        .value,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .delete ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodyLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .redColor
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "Foto STNK Belakang",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        if (controller
                                .vehicleRegistrationCertificateBackPhotoUrl
                                .value ==
                            "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: GestureDetector(
                              onTap: () async {
                                await controller
                                    .onTapUploadVehicleRegistrationCertificateBack();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: controller.isFormValid.value == true
                                        ? controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value
                                        : controller
                                              .themeColorServices
                                              .sematicColorRed500
                                              .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_image_upload.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (controller.isFormValid.value == false) ...[
                            SizedBox(height: 4),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formValidationRequired ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                            ),
                          ],
                        ],
                        if (controller
                                .vehicleRegistrationCertificateBackPhotoUrl
                                .value !=
                            "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: controller
                                          .vehicleRegistrationCertificateBackPhotoUrl
                                          .value,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .imageUploadMenuBackgroundColor
                                            .value,
                                      ),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await controller
                                                    .onTapUploadVehicleRegistrationCertificateBack();
                                              },
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .updatePhoto ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .textColor
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            VerticalDivider(
                                              width: 0,
                                              color: controller
                                                  .themeColorServices
                                                  .imageUploadVerticalDividerColor
                                                  .value,
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                controller
                                                        .vehicleRegistrationCertificateBackPhotoUrl
                                                        .value =
                                                    "";
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_delete.svg",
                                                    width: 16,
                                                    height: 16,
                                                    color: controller
                                                        .themeColorServices
                                                        .redColor
                                                        .value,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .delete ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodyLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .redColor
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "Foto Selfie dengan KTP",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        if (controller.driverSelfieWithIdCardPhotoUrl.value ==
                            "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: GestureDetector(
                              onTap: () async {
                                await controller
                                    .onTapUploadDriverSelfieWithIdCard();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: controller.isFormValid.value == true
                                        ? controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value
                                        : controller
                                              .themeColorServices
                                              .sematicColorRed500
                                              .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_image_upload.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (controller.isFormValid.value == false) ...[
                            SizedBox(height: 4),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formValidationRequired ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                            ),
                          ],
                        ],
                        if (controller.driverSelfieWithIdCardPhotoUrl.value !=
                            "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: controller
                                          .driverSelfieWithIdCardPhotoUrl
                                          .value,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .imageUploadMenuBackgroundColor
                                            .value,
                                      ),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await controller
                                                    .onTapUploadDriverSelfieWithIdCard();
                                              },
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .updatePhoto ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .textColor
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            VerticalDivider(
                                              width: 0,
                                              color: controller
                                                  .themeColorServices
                                                  .imageUploadVerticalDividerColor
                                                  .value,
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                controller
                                                        .driverSelfieWithIdCardPhotoUrl
                                                        .value =
                                                    "";
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_delete.svg",
                                                    width: 16,
                                                    height: 16,
                                                    color: controller
                                                        .themeColorServices
                                                        .redColor
                                                        .value,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .delete ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodyLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .redColor
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "Lampiran SKCK",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        if (controller
                                .policeClearanceCertificatePhotoUrl
                                .value ==
                            "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: GestureDetector(
                              onTap: () async {
                                await controller
                                    .onTapUploadPoliceClearanceCertificate();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: controller.isFormValid.value == true
                                        ? controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value
                                        : controller
                                              .themeColorServices
                                              .sematicColorRed500
                                              .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_image_upload.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (controller.isFormValid.value == false) ...[
                            SizedBox(height: 4),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formValidationRequired ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                            ),
                          ],
                        ],
                        if (controller
                                .policeClearanceCertificatePhotoUrl
                                .value !=
                            "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 215,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: controller
                                          .policeClearanceCertificatePhotoUrl
                                          .value,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .imageUploadMenuBackgroundColor
                                            .value,
                                      ),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await controller
                                                    .onTapUploadPoliceClearanceCertificate();
                                              },
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .updatePhoto ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .textColor
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            VerticalDivider(
                                              width: 0,
                                              color: controller
                                                  .themeColorServices
                                                  .imageUploadVerticalDividerColor
                                                  .value,
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                controller
                                                        .policeClearanceCertificatePhotoUrl
                                                        .value =
                                                    "";
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_delete.svg",
                                                    width: 16,
                                                    height: 16,
                                                    color: controller
                                                        .themeColorServices
                                                        .redColor
                                                        .value,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .delete ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodyLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .redColor
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "Nomor Plat Kendaraan",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        ReactiveTextField(
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          cursorErrorColor:
                              controller.themeColorServices.primaryBlue.value,
                          formControlName: 'license_plate',
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationRequired ??
                                "-",
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            prefix: SizedBox(width: 12),
                            suffix: SizedBox(width: 12),
                            hintText: "Misalnya B1234ABC",
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
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formTitleService ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        ReactiveCheckboxListTile(
                          formControlName: 'service_type_motorcycle',
                          title: Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .motorcycle ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.all(0),
                          checkColor: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          side: BorderSide(
                            color: controller.isFormValid.value == true
                                ? controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value
                                : controller
                                      .themeColorServices
                                      .sematicColorRed500
                                      .value,
                          ),
                          activeColor:
                              controller.themeColorServices.primaryBlue.value,
                        ),
                        if (controller.isFormValid.value == false) ...[
                          SizedBox(height: 4),
                          Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .formValidationRequired ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorRed500
                                      .value,
                                ),
                          ),
                        ],
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formTitleLocationService ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
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
                            for (var openCity in controller.openCityList) ...[
                              DropdownMenuItem(
                                value: openCity.id,
                                child: Text(
                                  openCity.name ?? "-",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value,
                                ),
                              ),
                            ],
                          ],
                          formControlName: 'place_of_employment_id',
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            prefix: SizedBox(width: 12),
                            suffix: SizedBox(width: 12),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 12),
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .formHintLocationService ??
                                      "-",
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
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formTitleAvatarPhoto ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .thirdTextColor
                                        .value,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "*",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        if (controller.avatarPhotoUrl.value == "") ...[
                          AspectRatio(
                            aspectRatio: 342 / 88,
                            child: GestureDetector(
                              onTap: () async {
                                await controller.onTapUploadAvatar();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: controller.isFormValid.value == true
                                        ? controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value
                                        : controller
                                              .themeColorServices
                                              .sematicColorRed500
                                              .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_image_upload.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (controller.isFormValid.value == false) ...[
                            SizedBox(height: 4),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .formValidationRequired ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                            ),
                          ],
                        ],
                        if (controller.avatarPhotoUrl.value != "") ...[
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AspectRatio(
                                    aspectRatio: 86 / 108,
                                    child: CachedNetworkImage(
                                      imageUrl: controller.avatarPhotoUrl.value,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                flex: 9,
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await controller.onTapUploadAvatar();
                                        },
                                        child: Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .updatePhoto ??
                                              "-",
                                          style: controller
                                              .typographyServices
                                              .bodyLargeRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .textColor
                                                    .value,
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      VerticalDivider(
                                        width: 0,
                                        color: controller
                                            .themeColorServices
                                            .imageUploadVerticalDividerColor
                                            .value,
                                      ),
                                      SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          controller.avatarPhotoUrl.value = "";
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_delete.svg",
                                              width: 16,
                                              height: 16,
                                              color: controller
                                                  .themeColorServices
                                                  .redColor
                                                  .value,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              controller
                                                      .languageServices
                                                      .language
                                                      .value
                                                      .delete ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .redColor
                                                        .value,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 16),
                        Divider(
                          height: 0,
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Kode Referral",
                          style: controller
                              .typographyServices
                              .bodyLargeRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .thirdTextColor
                                    .value,
                              ),
                        ),

                        SizedBox(height: 4),
                        ReactiveTextField(
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          cursorErrorColor:
                              controller.themeColorServices.primaryBlue.value,
                          formControlName: 'referral_code',
                          keyboardType: TextInputType.text,
                          maxLength: 8,
                          validationMessages: {
                            ValidationMessage.minLength: (error) =>
                                "Kode referral harus terdiri dari 8 huruf",
                            ValidationMessage.maxLength: (error) =>
                                "Kode referral harus terdiri dari 8 huruf",
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            prefix: SizedBox(width: 12),
                            hintText: "Masukkan kode referral",
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
                            suffixIcon: GestureDetector(
                              onTap: () async {
                                var result = await Get.toNamed(
                                  Routes.REGISTER_FORM_SCAN_QR,
                                );

                                if (result != null) {
                                  controller.formGroup
                                          .control("referral_code")
                                          .value =
                                      result;
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_scan_qr.svg",
                                      width: 13.5,
                                      height: 13.5,
                                    ),
                                  ],
                                ),
                              ),
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
                      ],
                    ),
                  ),
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          shadowColor: controller.themeColorServices.overlayDark100.value
              .withValues(alpha: 0.1),
          color: controller.themeColorServices.neutralsColorGrey0.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoaderElevatedButton(
                onPressed: () async {
                  await controller.onTapSubmit();
                },
                child: Text(
                  controller.languageServices.language.value.buttonNext ?? "-",
                  style: controller.typographyServices.bodySmallBold.value
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
