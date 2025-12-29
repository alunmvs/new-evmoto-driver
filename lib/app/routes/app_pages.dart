import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/account_about_us/bindings/account_about_us_binding.dart';
import '../modules/account_about_us/views/account_about_us_view.dart';
import '../modules/account_feedback/bindings/account_feedback_binding.dart';
import '../modules/account_feedback/views/account_feedback_view.dart';
import '../modules/account_language/bindings/account_language_binding.dart';
import '../modules/account_language/views/account_language_view.dart';
import '../modules/account_legal_terms_and_platform_rules/bindings/account_legal_terms_and_platform_rules_binding.dart';
import '../modules/account_legal_terms_and_platform_rules/views/account_legal_terms_and_platform_rules_view.dart';
import '../modules/account_my_evaluation/bindings/account_my_evaluation_binding.dart';
import '../modules/account_my_evaluation/views/account_my_evaluation_view.dart';
import '../modules/account_other_setting/bindings/account_other_setting_binding.dart';
import '../modules/account_other_setting/views/account_other_setting_view.dart';
import '../modules/account_service/bindings/account_service_binding.dart';
import '../modules/account_service/views/account_service_view.dart';
import '../modules/account_update_mobile_phone/bindings/account_update_mobile_phone_binding.dart';
import '../modules/account_update_mobile_phone/views/account_update_mobile_phone_view.dart';
import '../modules/account_update_mobile_phone_verification_otp/bindings/account_update_mobile_phone_verification_otp_binding.dart';
import '../modules/account_update_mobile_phone_verification_otp/views/account_update_mobile_phone_verification_otp_view.dart';
import '../modules/account_user_guide/bindings/account_user_guide_binding.dart';
import '../modules/account_user_guide/views/account_user_guide_view.dart';
import '../modules/activity/bindings/activity_binding.dart';
import '../modules/activity/views/activity_view.dart';
import '../modules/add_edit_withdraw_bank_account/bindings/add_edit_withdraw_bank_account_binding.dart';
import '../modules/add_edit_withdraw_bank_account/views/add_edit_withdraw_bank_account_view.dart';
import '../modules/deposit_balance/bindings/deposit_balance_binding.dart';
import '../modules/deposit_balance/views/deposit_balance_view.dart';
import '../modules/deposit_balance_payment_webview/bindings/deposit_balance_payment_webview_binding.dart';
import '../modules/deposit_balance_payment_webview/views/deposit_balance_payment_webview_view.dart';
import '../modules/history_balance_all/bindings/history_balance_all_binding.dart';
import '../modules/history_balance_all/views/history_balance_all_view.dart';
import '../modules/history_balance_recharge/bindings/history_balance_recharge_binding.dart';
import '../modules/history_balance_recharge/views/history_balance_recharge_view.dart';
import '../modules/history_balance_revenue/bindings/history_balance_revenue_binding.dart';
import '../modules/history_balance_revenue/views/history_balance_revenue_view.dart';
import '../modules/history_balance_withdraw/bindings/history_balance_withdraw_binding.dart';
import '../modules/history_balance_withdraw/views/history_balance_withdraw_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login_verification_otp/bindings/login_verification_otp_binding.dart';
import '../modules/login_verification_otp/views/login_verification_otp_view.dart';
import '../modules/onboarding_introduction/bindings/onboarding_introduction_binding.dart';
import '../modules/onboarding_introduction/views/onboarding_introduction_view.dart';
import '../modules/order_chat/bindings/order_chat_binding.dart';
import '../modules/order_chat/views/order_chat_view.dart';
import '../modules/order_detail/bindings/order_detail_binding.dart';
import '../modules/order_detail/views/order_detail_view.dart';
import '../modules/order_detail_cancel/bindings/order_detail_cancel_binding.dart';
import '../modules/order_detail_cancel/views/order_detail_cancel_view.dart';
import '../modules/order_detail_done/bindings/order_detail_done_binding.dart';
import '../modules/order_detail_done/views/order_detail_done_view.dart';
import '../modules/order_payment_confirmation/bindings/order_payment_confirmation_binding.dart';
import '../modules/order_payment_confirmation/views/order_payment_confirmation_view.dart';
import '../modules/order_payment_detail/bindings/order_payment_detail_binding.dart';
import '../modules/order_payment_detail/views/order_payment_detail_view.dart';
import '../modules/photo_viewer/bindings/photo_viewer_binding.dart';
import '../modules/photo_viewer/views/photo_viewer_view.dart';
import '../modules/privacy_policy/bindings/privacy_policy_binding.dart';
import '../modules/privacy_policy/views/privacy_policy_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/register_form/bindings/register_form_binding.dart';
import '../modules/register_form/views/register_form_view.dart';
import '../modules/register_form_completed/bindings/register_form_completed_binding.dart';
import '../modules/register_form_completed/views/register_form_completed_view.dart';
import '../modules/register_verification_otp/bindings/register_verification_otp_binding.dart';
import '../modules/register_verification_otp/views/register_verification_otp_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/switch_vehicle/bindings/switch_vehicle_binding.dart';
import '../modules/switch_vehicle/views/switch_vehicle_view.dart';
import '../modules/terms_and_conditions/bindings/terms_and_conditions_binding.dart';
import '../modules/terms_and_conditions/views/terms_and_conditions_view.dart';
import '../modules/withdraw/bindings/withdraw_binding.dart';
import '../modules/withdraw/views/withdraw_view.dart';
import '../modules/withdraw_amount/bindings/withdraw_amount_binding.dart';
import '../modules/withdraw_amount/views/withdraw_amount_view.dart';
import '../modules/withdraw_detail/bindings/withdraw_detail_binding.dart';
import '../modules/withdraw_detail/views/withdraw_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      bindings: [HomeBinding(), AccountBinding()],
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_INTRODUCTION,
      page: () => const OnboardingIntroductionView(),
      binding: OnboardingIntroductionBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_CONDITIONS,
      page: () => const TermsAndConditionsView(),
      binding: TermsAndConditionsBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_VERIFICATION_OTP,
      page: () => const LoginVerificationOtpView(),
      binding: LoginVerificationOtpBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_VERIFICATION_OTP,
      page: () => const RegisterVerificationOtpView(),
      binding: RegisterVerificationOtpBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_FORM,
      page: () => const RegisterFormView(),
      binding: RegisterFormBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_FORM_COMPLETED,
      page: () => const RegisterFormCompletedView(),
      binding: RegisterFormCompletedBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL,
      page: () => const OrderDetailView(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_PAYMENT_CONFIRMATION,
      page: () => const OrderPaymentConfirmationView(),
      binding: OrderPaymentConfirmationBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_PAYMENT_DETAIL,
      page: () => const OrderPaymentDetailView(),
      binding: OrderPaymentDetailBinding(),
    ),
    GetPage(
      name: _Paths.DEPOSIT_BALANCE,
      page: () => const DepositBalanceView(),
      binding: DepositBalanceBinding(),
    ),
    GetPage(
      name: _Paths.DEPOSIT_BALANCE_PAYMENT_WEBVIEW,
      page: () => const DepositBalancePaymentWebviewView(),
      binding: DepositBalancePaymentWebviewBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_MY_EVALUATION,
      page: () => const AccountMyEvaluationView(),
      binding: AccountMyEvaluationBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_FEEDBACK,
      page: () => const AccountFeedbackView(),
      binding: AccountFeedbackBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_SERVICE,
      page: () => const AccountServiceView(),
      binding: AccountServiceBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_UPDATE_MOBILE_PHONE,
      page: () => const AccountUpdateMobilePhoneView(),
      binding: AccountUpdateMobilePhoneBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_UPDATE_MOBILE_PHONE_VERIFICATION_OTP,
      page: () => const AccountUpdateMobilePhoneVerificationOtpView(),
      binding: AccountUpdateMobilePhoneVerificationOtpBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_OTHER_SETTING,
      page: () => const AccountOtherSettingView(),
      binding: AccountOtherSettingBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_LANGUAGE,
      page: () => const AccountLanguageView(),
      binding: AccountLanguageBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_USER_GUIDE,
      page: () => const AccountUserGuideView(),
      binding: AccountUserGuideBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_LEGAL_TERMS_AND_PLATFORM_RULES,
      page: () => const AccountLegalTermsAndPlatformRulesView(),
      binding: AccountLegalTermsAndPlatformRulesBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_ABOUT_US,
      page: () => const AccountAboutUsView(),
      binding: AccountAboutUsBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY,
      page: () => const ActivityView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL_DONE,
      page: () => const OrderDetailDoneView(),
      binding: OrderDetailDoneBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL_CANCEL,
      page: () => const OrderDetailCancelView(),
      binding: OrderDetailCancelBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_CHAT,
      page: () => const OrderChatView(),
      binding: OrderChatBinding(),
    ),
    GetPage(
      name: _Paths.SWITCH_VEHICLE,
      page: () => const SwitchVehicleView(),
      binding: SwitchVehicleBinding(),
    ),
    GetPage(
      name: _Paths.WITHDRAW,
      page: () => const WithdrawView(),
      binding: WithdrawBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EDIT_WITHDRAW_BANK_ACCOUNT,
      page: () => const AddEditWithdrawBankAccountView(),
      binding: AddEditWithdrawBankAccountBinding(),
    ),
    GetPage(
      name: _Paths.WITHDRAW_AMOUNT,
      page: () => const WithdrawAmountView(),
      binding: WithdrawAmountBinding(),
    ),
    GetPage(
      name: _Paths.WITHDRAW_DETAIL,
      page: () => const WithdrawDetailView(),
      binding: WithdrawDetailBinding(),
    ),
    GetPage(
      name: _Paths.PHOTO_VIEWER,
      page: () => const PhotoViewerView(),
      binding: PhotoViewerBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_BALANCE_ALL,
      page: () => const HistoryBalanceAllView(),
      binding: HistoryBalanceAllBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_BALANCE_REVENUE,
      page: () => const HistoryBalanceRevenueView(),
      binding: HistoryBalanceRevenueBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_BALANCE_WITHDRAW,
      page: () => const HistoryBalanceWithdrawView(),
      binding: HistoryBalanceWithdrawBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_BALANCE_RECHARGE,
      page: () => const HistoryBalanceRechargeView(),
      binding: HistoryBalanceRechargeBinding(),
    ),
  ];
}
