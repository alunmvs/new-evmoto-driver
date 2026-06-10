import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AccountFeedbackController extends GetxController {
  final AccountRepository accountRepository;

  AccountFeedbackController({required this.accountRepository});

  final formGroup = FormGroup({
    "content": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  @override
  void onInit() {
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

  Future<void> onTapSubmitFeedback() async {
    formGroup.markAllAsTouched();

    if (formGroup.valid == false) {
      SnackbarHelper.showSnackbarError(
        text: "Harap lengkapi data yang dibutuhkan",
      );
      return;
    }

    await accountRepository.createFeedback(
      language: languageServices.languageCodeSystem.value,
      type: 2,
      content: formGroup.control("content").value,
    );

    Get.back();
    SnackbarHelper.showSnackbarSuccess(text: "Masukan anda berhasil terkirim!");
    return;
  }
}
