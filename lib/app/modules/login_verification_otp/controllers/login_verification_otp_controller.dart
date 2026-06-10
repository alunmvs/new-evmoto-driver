import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/login_repository.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';

class LoginVerificationOtpController extends GetxController {
  final OtpRepository otpRepository;
  final LoginRepository loginRepository;

  LoginVerificationOtpController({
    required this.otpRepository,
    required this.loginRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final mobilePhone = "".obs;
  final otpCode = "".obs;

  final isButtonResendEnable = false.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    mobilePhone.value = Get.arguments['mobile_phone'] ?? "";
    await requestOtp();
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

  Future<void> requestOtp() async {
    try {
      await otpRepository.requestOTP(
        phone: mobilePhone.value,
        language: languageServices.languageCodeSystem.value,
        type: 3,
      );
      isButtonResendEnable.value = false;
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  Future<void> onTapSubmit() async {
    try {
      var token = await loginRepository.loginByMobileNumberOtp(
        phone: mobilePhone.value,
        otp: otpCode.value,
        language: languageServices.languageCodeSystem.value,
      );

      var storage = FlutterSecureStorage();
      await storage.write(key: "token", value: token);

      // Get.lazyPut<AccountController>(
      //   () => AccountController(
      //     otpRepository: OtpRepository(),
      //     userRepository: UserRepository(),
      //   ),
      // );

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }
}
