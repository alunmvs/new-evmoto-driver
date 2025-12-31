import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AccountUpdateMobilePhoneController extends GetxController {
  final AccountRepository accountRepository;

  AccountUpdateMobilePhoneController({required this.accountRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final homeController = Get.find<HomeController>();

  final formGroup = FormGroup({
    "old_mobile_phone": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "new_mobile_phone": FormControl<String>(
      validators: <Validator>[
        Validators.required,
        Validators.pattern(r'^8.*'),
        Validators.minLength(8),
        Validators.maxLength(15),
      ],
    ),
  });

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await homeController.getUserInfoDetail();
    formGroup.control("old_mobile_phone").value = homeController
        .userInfo
        .value
        .phone!
        .substring(2);
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

  Future<void> onTapSubmit() async {
    formGroup.markAllAsTouched();
    if (formGroup.valid) {
      Get.toNamed(
        Routes.ACCOUNT_UPDATE_MOBILE_PHONE_VERIFICATION_OTP,
        arguments: {
          "old_mobile_phone": formGroup.control("old_mobile_phone").value,
          "new_mobile_phone": formGroup.control("new_mobile_phone").value,
        },
      );
    }
  }
}
