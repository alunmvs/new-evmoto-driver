import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/widgets/dashed_line.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('RegisterView'),
          centerTitle: true,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: controller.status.value == "fill_register_account"
                  ? 0
                  : controller.status.value == "fill_personal_information"
                  ? 0.5
                  : 1,
            ),
            if (controller.status.value == "fill_register_account") ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ReactiveForm(
                      formGroup: controller.registerAccountFormGroup,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text("Mobile Phone Number"),
                          ReactiveTextField(
                            formControlName: 'mobile_number',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(),
                          ),
                          SizedBox(height: 8),
                          Text("Verification Code"),
                          ReactiveTextField(
                            formControlName: 'verification_code',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  if (controller
                                          .otpProtectionTimerSeconds
                                          .value ==
                                      0) {
                                    await controller.onTapSendOTP();
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (controller
                                            .otpProtectionTimerSeconds
                                            .value ==
                                        0) ...[
                                      Text("Kirim Kode OTP"),
                                    ],
                                    if (controller
                                            .otpProtectionTimerSeconds
                                            .value !=
                                        0) ...[
                                      Text(
                                        controller
                                            .otpProtectionTimerSeconds
                                            .value
                                            .toString(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("Password"),
                          ReactiveTextField(
                            formControlName: 'password',
                            obscureText: controller.isPasswordHide.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            if (controller.status.value == "fill_personal_information") ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: ReactiveForm(
                      formGroup: controller.personalInformationFormGroup,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text("ID Photo"),
                          GestureDetector(
                            onTap: () async {
                              await controller.onTapUploadIdPhoto();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Column(
                                  children: [
                                    if (controller.idCardImgUrl1.value ==
                                        "") ...[
                                      Expanded(child: Placeholder()),
                                    ],
                                    if (controller.idCardImgUrl1.value !=
                                        "") ...[
                                      Expanded(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              controller.idCardImgUrl1.value,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text("ID Number"),
                          ReactiveTextField(
                            formControlName: 'id_card',
                            keyboardType: TextInputType.number,
                          ),
                          Text("Name"),
                          ReactiveTextField(formControlName: 'name'),
                          Text("Gender"),
                          ReactiveDropdownField<int>(
                            formControlName: 'gender_id',
                            items: [
                              DropdownMenuItem(
                                value: 2,
                                child: Text("Perempuan"),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text("Laki-laki"),
                              ),
                            ],
                          ),
                          Text("Residence Province"),
                          ReactiveDropdownField<int>(
                            formControlName: 'residence_province_id',
                            onChanged: (control) {
                              controller.refreshCityList(
                                provinceId: control.value!,
                              );
                            },
                            items: [
                              for (var province
                                  in controller.provinceCitiesList) ...[
                                DropdownMenuItem(
                                  value: province.id,
                                  child: Text(province.name ?? "-"),
                                ),
                              ],
                            ],
                          ),
                          Text("Residence City"),
                          ReactiveDropdownField<int>(
                            formControlName: 'residence_city_id',
                            items: [
                              for (var city in controller.citiesList) ...[
                                DropdownMenuItem(
                                  value: city.id,
                                  child: Text(city.name ?? "-"),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 16),
                          DashedLine(),
                          SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Driver's License"),
                                    GestureDetector(
                                      onTap: () async {
                                        await controller
                                            .onTapUploadDriverLicense();
                                      },
                                      child: Container(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        color: Colors.transparent,
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Column(
                                            children: [
                                              if (controller
                                                      .driveCardImgUrl
                                                      .value ==
                                                  "") ...[
                                                Expanded(child: Placeholder()),
                                              ],
                                              if (controller
                                                      .driveCardImgUrl
                                                      .value !=
                                                  "") ...[
                                                Expanded(
                                                  child: CachedNetworkImage(
                                                    imageUrl: controller
                                                        .driveCardImgUrl
                                                        .value,
                                                    fit: BoxFit.cover,
                                                    width: MediaQuery.of(
                                                      context,
                                                    ).size.width,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Avatar"),
                                    GestureDetector(
                                      onTap: () async {
                                        await controller.onTapUploadAvatar();
                                      },
                                      child: Container(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        color: Colors.transparent,
                                        child: AspectRatio(
                                          aspectRatio: 3 / 4,
                                          child: Column(
                                            children: [
                                              if (controller.headImgUrl.value ==
                                                  "") ...[
                                                Expanded(child: Placeholder()),
                                              ],
                                              if (controller.headImgUrl.value !=
                                                  "") ...[
                                                Expanded(
                                                  child: CachedNetworkImage(
                                                    imageUrl: controller
                                                        .headImgUrl
                                                        .value,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text("Driving Experience"),
                          ReactiveTextField(
                            readOnly: true,
                            formControlName: 'driving_experience',
                            onTap: (value) async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                controller.personalInformationFormGroup
                                    .control('driving_experience')
                                    .value = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(pickedDate);
                              }
                            },
                          ),
                          Text("Service Mode"),
                          ReactiveCheckboxListTile(
                            formControlName: 'service_mode_motorcycle',
                            title: Text("Motorcycle"),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.all(0),
                          ),
                          ReactiveCheckboxListTile(
                            formControlName:
                                'service_mode_city_express_delivery',
                            title: Text("City Express Delivery"),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.all(0),
                          ),
                          Text("Place of Employment"),
                          ReactiveDropdownField<int>(
                            formControlName: 'place_of_employment',
                            items: [
                              for (var openCity in controller.openCityList) ...[
                                DropdownMenuItem(
                                  value: openCity.id,
                                  child: Text(openCity.name ?? "-"),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            if (controller.status.value == "summary") ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          "Data Submitted Successfully",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Thankyou for choosing to join the EVMOTO family. The staff will contact you within 2 hours to confirm the relevant information. Please keep the phone open. Thanks for your support and understanding!",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Confirmation"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        bottomNavigationBar:
            controller.isFetch.value || controller.status.value == "summary"
            ? null
            : BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await controller.onTapPrevious();
                      },
                      child: Text("Back"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.onTapNext();
                      },
                      child: Text("Next"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
