import 'dart:async';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RegisterController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final formGroup = FormGroup({
    "mobile_phone": FormControl<String>(
      validators: <Validator>[
        Validators.required,
        Validators.pattern(r'^8.*'),
        Validators.minLength(8),
        Validators.maxLength(15),
      ],
    ),
  });

  final mobilePhone = "".obs;
  final isFormValid = false.obs;

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
