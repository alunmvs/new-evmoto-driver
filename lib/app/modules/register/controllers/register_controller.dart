import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_driver/app/data/open_city_model.dart';
import 'package:new_evmoto_driver/app/data/province_cities_model.dart';
import 'package:new_evmoto_driver/app/data/registered_driver_model.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/repositories/register_repository.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RegisterController extends GetxController {
  final RegisterRepository registerRepository;
  final OtpRepository otpRepository;
  final UploadImageRepository uploadImageRepository;

  RegisterController({
    required this.registerRepository,
    required this.otpRepository,
    required this.uploadImageRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final status = "fill_register_account".obs;

  final registerAccountFormGroup = FormGroup({
    "mobile_number": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "verification_code": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "password": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
  });

  final personalInformationFormGroup = FormGroup({
    "id_card": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "name": FormControl<String>(validators: <Validator>[Validators.required]),
    "gender_id": FormControl<int>(validators: <Validator>[Validators.required]),
    "residence_province_id": FormControl<int>(
      validators: <Validator>[Validators.required],
    ),
    "residence_city_id": FormControl<int>(
      validators: <Validator>[Validators.required],
    ),
    "driving_experience": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "service_mode_motorcycle": FormControl<bool>(validators: <Validator>[]),
    "service_mode_city_express_delivery": FormControl<bool>(
      validators: <Validator>[],
    ),
    "place_of_employment": FormControl<int>(
      validators: <Validator>[Validators.required],
    ),
  });

  final idCardImgUrl1 = "".obs;
  final idCardImgUrl2 = "".obs;
  final headImgUrl = "".obs;
  final driveCardImgUrl = "".obs;

  final isPasswordHide = true.obs;
  final registeredDriver = RegisteredDriver().obs;

  final provinceCitiesList = <ProvinceCities>[].obs;
  final citiesList = <Child>[].obs;
  final openCityList = <OpenCity>[].obs;

  final otpProtectionTimerSeconds = 0.obs;
  late Timer? otpProtectionTimer;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
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

  void refreshCityList({required int provinceId}) {
    citiesList.value = [];
    personalInformationFormGroup.control("residence_city_id").value = null;

    for (var province in provinceCitiesList) {
      if (province.id == provinceId) {
        citiesList.value = province.child ?? <Child>[];
      }
    }
  }

  Future<void> getProvinceCitiesList() async {
    provinceCitiesList.value = (await registerRepository
        .getAllProvinceCitiesList(language: 2));
  }

  Future<void> getOpenCityList() async {
    openCityList.value = (await registerRepository.getAllOpenCityList(
      language: 2,
    ));
  }

  Future<void> onTapSendOTP() async {
    registerAccountFormGroup.control("mobile_number").markAsTouched();

    if (registerAccountFormGroup.control("mobile_number").valid) {
      await otpRepository.requestOTP(
        phone: registerAccountFormGroup.control("mobile_number").value,
        language: 2,
        type: 3,
      );

      otpProtectionTimerSeconds.value = 60;
      otpProtectionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (otpProtectionTimerSeconds.value == 0) {
          otpProtectionTimer?.cancel();
        } else {
          otpProtectionTimerSeconds.value -= 1;
        }
      });

      Get.showSnackbar(
        GetSnackBar(
          message: "OTP telah terkirim".toString(),
          duration: Duration(seconds: 2),
        ),
      );
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
      idCardImgUrl1.value = await uploadImageRepository.uploadImage(
        file: image,
      );
      idCardImgUrl2.value = "";
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
      driveCardImgUrl.value = idCardImgUrl1.value = await uploadImageRepository
          .uploadImage(file: image);
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
      headImgUrl.value = await uploadImageRepository.uploadImage(file: image);
    }
  }

  Future<void> onTapNext() async {
    switch (status.value) {
      case "fill_register_account":
        registerAccountFormGroup.markAllAsTouched();
        if (registerAccountFormGroup.valid) {
          try {
            await otpRepository.checkOTP(
              phone: registerAccountFormGroup.control("mobile_number").value,
              code: registerAccountFormGroup.control("verification_code").value,
              language: 2,
            );
            registeredDriver.value = (await registerRepository.registerDriver(
              phone: registerAccountFormGroup.control("mobile_number").value,
              code: registerAccountFormGroup.control("verification_code").value,
              password: registerAccountFormGroup.control("password").value,
              language: 2,
            ))!;
            status.value = "fill_personal_information";
          } catch (e) {
            Get.showSnackbar(
              GetSnackBar(
                message: e.toString(),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
        break;
      case "fill_personal_information":
        personalInformationFormGroup.markAllAsTouched();

        var isServiceModeSelected =
            personalInformationFormGroup
                    .control("service_mode_motorcycle")
                    .value ==
                true ||
            personalInformationFormGroup
                    .control("service_mode_city_express_delivery")
                    .value ==
                true;

        if (personalInformationFormGroup.valid &&
            isServiceModeSelected &&
            idCardImgUrl1.value != "" &&
            driveCardImgUrl.value != "" &&
            headImgUrl.value != "") {
          try {
            await registerRepository.updateDriver(
              driveCardImgUrl: driveCardImgUrl.value,
              getDriverLicenseDate: personalInformationFormGroup
                  .control("driving_experience")
                  .value,
              headImgUrl: headImgUrl.value,
              idCard: personalInformationFormGroup.control("id_card").value,
              idCardImgUrl1: idCardImgUrl1.value,
              idCardImgUrl2: idCardImgUrl2.value,
              sex: personalInformationFormGroup.control("gender_id").value,
              language: 2,
              name: personalInformationFormGroup.control("name").value,
              password: md5
                  .convert(
                    utf8.encode(
                      registerAccountFormGroup.control("password").value,
                    ),
                  )
                  .toString(),
              placeOfEmployment: personalInformationFormGroup
                  .control("place_of_employment")
                  .value,
              phone: registerAccountFormGroup.control("mobile_number").value,
              uid: registeredDriver.value.id.toString(),
              type: generateTypeFromServiceMode(),
              driverContactAddress: generateDriverContactAddress(),
              driverContactAddress_: generateDriverContactAddress_(),
            );
            status.value = "summary";
          } catch (e) {
            Get.showSnackbar(
              GetSnackBar(
                message: e.toString(),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
        break;
      case "summary":
        break;
      default:
        break;
    }
  }

  String generateDriverContactAddress() {
    var driverContactAddress = [];

    for (var province in provinceCitiesList) {
      if (province.id ==
          personalInformationFormGroup.control("residence_province_id").value) {
        driverContactAddress.add(province.name);
      }
      for (var city in province.child ?? <Child>[]) {
        if (city.id ==
            personalInformationFormGroup.control("residence_city_id").value) {
          driverContactAddress.add(city.name);
        }
      }
    }

    return driverContactAddress.join();
  }

  String generateDriverContactAddress_() {
    var driverContactAddress = [];

    for (var province in provinceCitiesList) {
      if (province.id ==
          personalInformationFormGroup.control("residence_province_id").value) {
        driverContactAddress.add(province.name);
      }
      for (var city in province.child ?? <Child>[]) {
        if (city.id ==
            personalInformationFormGroup.control("residence_city_id").value) {
          driverContactAddress.add(city.name);
        }
      }
    }

    return driverContactAddress.join(",");
  }

  String generateTypeFromServiceMode() {
    var typeList = [];
    if (personalInformationFormGroup.control("service_mode_motorcycle").value ==
        true) {
      typeList.add(1);
    }
    if (personalInformationFormGroup.control("service_mode_motorcycle").value ==
        true) {
      typeList.add(4);
    }
    return typeList.join(",");
  }

  Future<void> onTapPrevious() async {
    switch (status.value) {
      case "fill_register_account":
        break;
      case "fill_personal_information":
        status.value = "fill_register_account";
        break;
      case "summary":
        status.value = "fill_personal_information";
        break;
      default:
        break;
    }
  }
}
