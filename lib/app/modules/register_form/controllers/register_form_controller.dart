import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_driver/app/data/models/open_city_model.dart';
import 'package:new_evmoto_driver/app/data/models/province_cities_model.dart';
import 'package:new_evmoto_driver/app/repositories/register_repository.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/common_helper.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RegisterFormController extends GetxController {
  final UploadImageRepository uploadImageRepository;
  final RegisterRepository registerRepository;

  RegisterFormController({
    required this.uploadImageRepository,
    required this.registerRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final formGroup = FormGroup({
    "full_name": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "gender_id": FormControl<int>(validators: <Validator>[Validators.required]),
    "domicile_province": FormControl<int>(
      validators: <Validator>[Validators.required],
    ),
    "domicile_city": FormControl<int>(
      validators: <Validator>[Validators.required],
    ),
    "identity_number": FormControl<String>(
      validators: <Validator>[
        Validators.required,
        Validators.minLength(16),
        Validators.maxLength(16),
      ],
    ),
    "driving_experience": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "service_type_motorcycle": FormControl<bool>(
      validators: <Validator>[],
      value: false,
    ),
    "service_type_city_express_delivery": FormControl<bool>(
      validators: <Validator>[],
      value: false,
    ),
    "place_of_employment_id": FormControl<int>(
      validators: <Validator>[Validators.required],
    ),
  });

  final provinceCitiesList = <ProvinceCities>[].obs;
  final citiesList = <Child>[].obs;
  final openCityList = <OpenCity>[].obs;

  final idPhotoUrl = "".obs;
  final drivingLicensePhotoUrl = "".obs;
  final avatarPhotoUrl = "".obs;

  final uid = "".obs;
  final mobilePhone = "".obs;

  final isFormValid = true.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    uid.value = Get.arguments['uid'] ?? "";
    mobilePhone.value = Get.arguments["mobile_phone"] ?? "";
    await Future.wait([getProvinceCitiesList(), getOpenCityList()]);
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

  Future<void> getProvinceCitiesList() async {
    provinceCitiesList.value = (await registerRepository
        .getAllProvinceCitiesList(
          language: languageServices.languageCodeSystem.value,
        ));
  }

  Future<void> getOpenCityList() async {
    openCityList.value = (await registerRepository.getAllOpenCityList(
      language: languageServices.languageCodeSystem.value,
    ));
  }

  void refreshCityList({required int provinceId}) {
    citiesList.value = [];
    formGroup.control("domicile_city").value = null;

    for (var province in provinceCitiesList) {
      if (province.id == provinceId) {
        citiesList.value = province.child ?? <Child>[];
      }
    }
  }

  Future<void> onTapUploadIdPhoto() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      showLoadingDialog();
      idPhotoUrl.value = await uploadImageRepository.uploadImage(file: image);
      Get.close(1);
    }
  }

  Future<void> onTapUploadDriverLicense() async {
    var imagePicker = ImagePicker();

    var image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      showLoadingDialog();
      drivingLicensePhotoUrl.value = await uploadImageRepository.uploadImage(
        file: image,
      );
      Get.close(1);
    }
  }

  Future<void> onTapUploadAvatar() async {
    var imagePicker = ImagePicker();

    var image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.front,
    );

    if (image != null) {
      showLoadingDialog();
      avatarPhotoUrl.value = await uploadImageRepository.uploadImage(
        file: image,
      );
      Get.close(1);
    }
  }

  String generateDriverContactAddress() {
    var driverContactAddress = [];

    for (var province in provinceCitiesList) {
      if (province.id == formGroup.control("domicile_province").value) {
        driverContactAddress.add(province.name);
      }
      for (var city in province.child ?? <Child>[]) {
        if (city.id == formGroup.control("domicile_city").value) {
          driverContactAddress.add(city.name);
        }
      }
    }

    return driverContactAddress.join();
  }

  String generateDriverContactAddress_() {
    var driverContactAddress = [];

    for (var province in provinceCitiesList) {
      if (province.id == formGroup.control("domicile_province").value) {
        driverContactAddress.add(province.name);
      }
      for (var city in province.child ?? <Child>[]) {
        if (city.id == formGroup.control("domicile_city").value) {
          driverContactAddress.add(city.name);
        }
      }
    }

    return driverContactAddress.join(",");
  }

  String generateType() {
    var typeList = [];

    if (formGroup.control("service_type_motorcycle").value == true) {
      typeList.add(1);
    }
    if (formGroup.control("service_type_city_express_delivery").value == true) {
      typeList.add(4);
    }

    return typeList.join(",");
  }

  Future<void> onTapSubmit() async {
    formGroup.markAllAsTouched();

    if (!formGroup.valid ||
        (formGroup.control("service_type_motorcycle").value == false &&
            formGroup.control("service_type_city_express_delivery").value ==
                false) ||
        idPhotoUrl.value == "" ||
        drivingLicensePhotoUrl.value == "" ||
        avatarPhotoUrl.value == "") {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          "Harap lengkapi data yang dibutuhkan",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      isFormValid.value = false;
      return;
    }

    try {
      await registerRepository.updateDriver(
        idCardImgUrl1: idPhotoUrl.value,
        idCardImgUrl2: "",
        driveCardImgUrl: drivingLicensePhotoUrl.value,
        headImgUrl: avatarPhotoUrl.value,
        idCard: formGroup.control("identity_number").value,
        name: formGroup.control("full_name").value,
        sex: formGroup.control("gender_id").value,
        password: md5.convert(utf8.encode("123456789")).toString(),
        phone: "62${mobilePhone.value}",
        uid: uid.value,
        placeOfEmployment: formGroup.control("place_of_employment_id").value,
        getDriverLicenseDate: formGroup.control("driving_experience").value,
        language: languageServices.languageCodeSystem.value,
        type: generateType(),
        driverContactAddress: generateDriverContactAddress(),
        driverContactAddress_: generateDriverContactAddress_(),
      );
      Get.offAllNamed(Routes.REGISTER_FORM_COMPLETED);
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
    }
  }
}
