import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_driver/app/data/models/open_city_model.dart';
import 'package:new_evmoto_driver/app/data/models/province_cities_model.dart';
import 'package:new_evmoto_driver/app/data/models/registered_driver_model.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/repositories/register_repository.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RegisterController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final formGroup = FormGroup({
    "mobile_phone": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
  });

  final mobilePhone = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onTapSubmit() async {
    formGroup.markAllAsTouched();

    if (formGroup.valid) {
      Get.toNamed(
        Routes.REGISTER_VERIFICATION_OTP,
        arguments: {"mobile_phone": formGroup.control("mobile_phone").value},
      );
    }
  }
}
