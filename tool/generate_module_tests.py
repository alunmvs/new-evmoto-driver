#!/usr/bin/env python3
"""Generate controller and view tests for all app modules."""

import os
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MODULES_DIR = ROOT / "lib" / "app" / "modules"
TEST_DIR = ROOT / "test" / "app" / "modules"

# (module_folder, ClassName, repository_import_and_mock_or_None, extra_setup, controller_tests, view_tests)
# repository: (import_path, MockName, constructor_arg) or None
MODULES = [
    ("account", "Account", ("otp_repository", "OtpRepository", "user_repository", "UserRepository"), "extra_account", "minimal_ctrl", "minimal_view"),
    ("account_about_us", "AccountAboutUs", ("agreement_repository", "AgreementRepository"), "agreement", "agreement_ctrl", "agreement_view"),
    ("account_feedback", "AccountFeedback", ("account_repository", "AccountRepository"), "none", "feedback_ctrl", "feedback_view"),
    ("account_language", "AccountLanguage", None, "none", "language_ctrl", "language_view"),
    ("account_legal_terms_and_platform_rules", "AccountLegalTermsAndPlatformRules", ("agreement_repository", "AgreementRepository"), "agreement", "agreement_ctrl", "agreement_view"),
    ("account_my_evaluation", "AccountMyEvaluation", ("account_repository", "AccountRepository"), "fetch_account", "fetch_ctrl", "fetch_view"),
    ("account_other_setting", "AccountOtherSetting", None, "home_remote", "minimal_ctrl", "minimal_view"),
    ("account_service", "AccountService", ("account_repository", "AccountRepository"), "fetch_account", "fetch_ctrl", "fetch_view"),
    ("account_update_mobile_phone", "AccountUpdateMobilePhone", ("account_repository", "AccountRepository"), "home", "form_ctrl", "form_view"),
    ("account_update_mobile_phone_verification_otp", "AccountUpdateMobilePhoneVerificationOtp", ("account_repository", "AccountRepository"), "none", "otp_ctrl", "otp_view"),
    ("account_user_guide", "AccountUserGuide", ("agreement_repository", "AgreementRepository"), "agreement", "agreement_ctrl", "agreement_view"),
    ("add_edit_withdraw_bank_account", "AddEditWithdrawBankAccount", ("bank_account_repository", "BankAccountRepository"), "withdraw_stub", "form_ctrl", "form_view"),
    ("agreement_coupon_income", "AgreementCouponIncome", ("agreement_repository", "AgreementRepository"), "agreement", "agreement_ctrl", "agreement_view"),
    ("agreement_guarantee_income", "AgreementGuaranteeIncome", ("agreement_repository", "AgreementRepository"), "agreement", "agreement_ctrl", "agreement_view"),
    ("chat_detail", "ChatDetail", ("upload_image_repository", "UploadImageRepository"), "home", "minimal_ctrl", "minimal_view"),
    ("chat_list", "ChatList", None, "user_services", "minimal_ctrl", "minimal_view"),
    ("deposit_balance", "DepositBalance", ("payment_repository", "PaymentRepository", "user_repository", "UserRepository"), "remote_config", "form_ctrl", "form_view"),
    ("deposit_balance_payment_webview", "DepositBalancePaymentWebview", ("payment_repository", "PaymentRepository"), "home", "minimal_ctrl", "webview_view"),
    ("history_balance_all", "HistoryBalanceAll", ("history_balance_repository", "HistoryBalanceRepository"), "home", "minimal_ctrl", "history_all_view"),
    ("history_balance_recharge", "HistoryBalanceRecharge", ("history_balance_repository", "HistoryBalanceRepository"), "none", "fetch_ctrl", "fetch_view"),
    ("history_balance_revenue", "HistoryBalanceRevenue", ("history_balance_repository", "HistoryBalanceRepository"), "none", "fetch_ctrl", "fetch_view"),
    ("history_balance_withdraw", "HistoryBalanceWithdraw", ("history_balance_repository", "HistoryBalanceRepository"), "none", "fetch_ctrl", "fetch_view"),
    ("history_guarantee_income", "HistoryGuaranteeIncome", ("guarantee_income_repository", "GuaranteeIncomeRepository"), "none", "fetch_ctrl", "fetch_view"),
    ("home", "Home", None, "home_stub", "home_stub_ctrl", "home_stub_view"),
    ("login_verification_otp", "LoginVerificationOtp", ("otp_repository", "OtpRepository", "login_repository", "LoginRepository"), "none", "otp_ctrl", "otp_view"),
    ("my_activity", "MyActivity", ("activity_repository", "ActivityRepository", "guarantee_income_repository", "GuaranteeIncomeRepository"), "user_services", "minimal_ctrl", "minimal_view"),
    ("my_order", "MyOrder", ("order_repository", "OrderRepository", "advance_booking_repository", "AdvanceBookingRepository"), "none", "minimal_ctrl", "minimal_view"),
    ("my_order_v2", "MyOrderV2", ("order_repository", "OrderRepository"), "none", "minimal_ctrl", "minimal_view"),
    ("notification", "Notification", ("notification_repository", "NotificationRepository"), "none", "fetch_ctrl", "fetch_view"),
    ("order_detail", "OrderDetail", ("order_repository", "OrderRepository", "google_maps_repository", "GoogleMapsRepository", "open_maps_repository", "OpenMapsRepository"), "order_detail", "minimal_ctrl", "minimal_view"),
    ("order_payment_confirmation", "OrderPaymentConfirmation", ("order_repository", "OrderRepository"), "order_payment", "form_ctrl", "order_payment_view"),
    ("order_payment_detail", "OrderPaymentDetail", ("order_repository", "OrderRepository"), "none", "fetch_ctrl", "fetch_view"),
    ("order_payment_pending", "OrderPaymentPending", ("order_repository", "OrderRepository"), "none", "fetch_ctrl", "fetch_view"),
    ("order_payment_pending_fee_detail", "OrderPaymentPendingFeeDetail", ("order_repository", "OrderRepository"), "none", "fetch_ctrl", "fetch_view"),
    ("photo_viewer", "PhotoViewer", None, "photo_args", "photo_ctrl", "photo_view"),
    ("privacy_policy", "PrivacyPolicy", ("agreement_repository", "AgreementRepository"), "agreement", "agreement_ctrl", "webview_view"),
    ("register", "Register", None, "none", "register_ctrl", "register_view"),
    ("register_form", "RegisterForm", ("upload_image_repository", "UploadImageRepository", "register_repository", "RegisterRepository"), "none", "form_ctrl", "form_view"),
    ("register_form_completed", "RegisterFormCompleted", None, "none", "completed_ctrl", "completed_view"),
    ("register_verification_otp", "RegisterVerificationOtp", ("otp_repository", "OtpRepository", "register_repository", "RegisterRepository"), "none", "otp_ctrl", "otp_view"),
    ("splash_screen", "SplashScreen", ("query_image_repository", "QueryImageRepository"), "splash", "splash_ctrl", "splash_view"),
    ("switch_vehicle", "SwitchVehicle", ("vehicle_repository", "VehicleRepository"), "none", "switch_ctrl", "switch_view"),
    ("terms_and_conditions", "TermsAndConditions", ("agreement_repository", "AgreementRepository"), "agreement", "agreement_ctrl", "agreement_view"),
    ("withdraw", "Withdraw", ("bank_account_repository", "BankAccountRepository"), "home_remote", "fetch_ctrl", "fetch_view"),
    ("withdraw_amount", "WithdrawAmount", ("withdraw_repository", "WithdrawRepository"), "home_remote", "form_ctrl", "form_view"),
    ("withdraw_detail", "WithdrawDetail", None, "withdraw_args", "withdraw_detail_ctrl", "withdraw_detail_view"),
]

SKIP = {"login"}


def pascal_to_snake(name: str) -> str:
    import re
    return re.sub(r"(?<!^)(?=[A-Z])", "_", name).lower()


def repo_info(module_entry):
    repos = module_entry[2]
    if repos is None:
        return None
    if len(repos) == 2:
        snake, cls = repos
        return [(snake, cls)]
    # multiple repos: tuples of (snake, ClassName) pairs
    pairs = list(zip(repos[::2], repos[1::2]))
    return pairs


def gen_imports(class_name: str, module: str, repos, template: str, extra: str = "none") -> str:
    lines = [
        "import 'package:flutter/material.dart';",
        "import 'package:flutter_test/flutter_test.dart';",
        "import 'package:get/get.dart';",
    ]
    if repos or template in ("agreement_ctrl", "fetch_ctrl", "splash_ctrl", "switch_ctrl", "feedback_ctrl", "otp_ctrl", "register_ctrl", "form_ctrl"):
        lines.append("import 'package:mocktail/mocktail.dart';")
    lines.append(f"import 'package:new_evmoto_driver/app/data/models/language_model.dart';")
    if template in ("agreement_ctrl", "agreement_view"):
        lines.append("import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';")
    if template in ("withdraw_detail_ctrl", "withdraw_detail_view"):
        lines.append("import 'package:new_evmoto_driver/app/data/models/history_balance_withdraw_model.dart';")
    if template == "splash_ctrl":
        lines.append("import 'package:new_evmoto_driver/app/data/models/query_image_model.dart';")
    if template == "switch_ctrl":
        lines.append("import 'package:new_evmoto_driver/app/data/models/my_vehicle_model.dart';")
    lines.append(f"import 'package:new_evmoto_driver/app/modules/{module}/controllers/{module}_controller.dart';")
    if "view" in template:
        lines.append(f"import 'package:new_evmoto_driver/app/modules/{module}/views/{module}_view.dart';")
    if template in ("completed_ctrl", "register_ctrl", "otp_ctrl"):
        lines.append("import 'package:new_evmoto_driver/app/routes/app_pages.dart';")
    for snake, cls in repos or []:
        lines.append(f"import 'package:new_evmoto_driver/app/repositories/{snake}.dart';")
    if template in ("otp_ctrl",) and any(c == "LoginRepository" for _, c in (repos or [])):
        lines.append("import 'package:new_evmoto_driver/app/repositories/login_repository.dart';")
    if template in ("otp_ctrl",) and any(c == "RegisterRepository" for _, c in (repos or [])):
        lines.append("import 'package:new_evmoto_driver/app/repositories/register_repository.dart';")
    if template in ("otp_ctrl",) and any(c == "OtpRepository" for _, c in (repos or [])):
        lines.append("import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';")
    if module == "add_edit_withdraw_bank_account" or extra == "withdraw_stub":
        lines.append("import 'package:new_evmoto_driver/app/modules/withdraw/controllers/withdraw_controller.dart';")
        lines.append("import 'package:new_evmoto_driver/app/repositories/bank_account_repository.dart';")
    if module == "home":
        lines.append("import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';")
    rel = "../../../../helpers/module_test_helpers.dart"
    lines.append(f"import '{rel}';")
    return "\n".join(lines) + "\n"


def gen_mocks(repos):
    if not repos:
        return ""
    out = []
    for snake, cls in repos:
        out.append(f"class Mock{cls} extends Mock implements {cls} {{}}")
    return "\n\n".join(out) + ("\n\n" if out else "")


def gen_constructor_args(repos):
    if not repos:
        return ""
    args = []
    for snake, cls in repos:
        var = snake.replace("_repository", "Repository")
        if var == "query_imageRepository":
            var = "queryImageRepository"
        # camelCase
        parts = snake.split("_")
        var = parts[0] + "".join(p.capitalize() for p in parts[1:])
        args.append(f"{var}: {var[0].lower()}{var[1:]}")
    # fix naming
    fixed = []
    for snake, cls in repos:
        parts = snake.split("_")
        var = parts[0] + "".join(p.capitalize() for p in parts[1:])
        mock = f"mock{cls}"
        fixed.append(f"{var}: {mock}")
    return ", ".join(fixed)


def gen_mock_vars(repos):
    if not repos:
        return ""
    lines = []
    for snake, cls in repos:
        lines.append(f"    late Mock{cls} mock{cls};")
    return "\n".join(lines)


def gen_mock_init(repos):
    if not repos:
        return ""
    lines = []
    for snake, cls in repos:
        lines.append(f"      mock{cls} = Mock{cls}();")
    return "\n".join(lines)


def gen_view_repo_stubs(repos) -> str:
    if not repos:
        return ""
    classes = {cls for _, cls in repos}
    stubs = []
    if "HistoryBalanceRepository" in classes:
        stubs.append("""
      when(
        () => mockHistoryBalanceRepository.getHistoryWithdrawList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => []);
      when(
        () => mockHistoryBalanceRepository.getHistoryRechargeList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => []);
      when(
        () => mockHistoryBalanceRepository.getHistoryRevenueList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => HistoryBalanceRevenue());""")
    if "AccountRepository" in classes:
        stubs.append("""
      when(
        () => mockAccountRepository.getServiceOrderList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => []);
      when(
        () => mockAccountRepository.getRatingAndReviewDetail(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => RatingAndReview());
      when(
        () => mockAccountRepository.createFeedback(
          language: any(named: 'language'),
          type: any(named: 'type'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async => true);""")
    if "NotificationRepository" in classes:
        stubs.append("""
      when(
        () => mockNotificationRepository.getNotificationList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => []);""")
    if "OrderRepository" in classes:
        stubs.append("""
      when(
        () => mockOrderRepository.getOrderDetail(
          language: any(named: 'language'),
          orderId: any(named: 'orderId'),
        ),
      ).thenAnswer((_) async => OrderDetail());
      when(
        () => mockOrderRepository.getOrderPayment(
          language: any(named: 'language'),
          orderId: any(named: 'orderId'),
        ),
      ).thenAnswer((_) async => OrderPayment());
      when(
        () => mockOrderRepository.getOrderUserDetail(
          language: any(named: 'language'),
          orderId: any(named: 'orderId'),
        ),
      ).thenAnswer((_) async => OrderUser());
      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => []);""")
    if "VehicleRepository" in classes:
        stubs.append("""
      when(
        () => mockVehicleRepository.getMyVehicleDetail(
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => MyVehicle());
      when(
        () => mockVehicleRepository.switchVehicle(
          language: any(named: 'language'),
          carId: any(named: 'carId'),
        ),
      ).thenAnswer((_) async {});""")
    if "BankAccountRepository" in classes:
        stubs.append("""
      when(
        () => mockBankAccountRepository.getBankAccountList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => []);
      when(
        () => mockBankAccountRepository.getBankList(
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => []);""")
    if "WithdrawRepository" in classes:
        stubs.append("""
      when(
        () => mockWithdrawRepository.getAdminFeeByBankCode(
          language: any(named: 'language'),
          bankCode: any(named: 'bankCode'),
        ),
      ).thenAnswer((_) async => 0);""")
    if "GuaranteeIncomeRepository" in classes:
        stubs.append("""
      when(
        () => mockGuaranteeIncomeRepository.getGuaranteeIncomeApprovalList(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => []);
      when(
        () => mockGuaranteeIncomeRepository.getCouponIncome(
          language: any(named: 'language'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => CouponIncome());""")
    if "ActivityRepository" in classes:
        stubs.append("""
      when(
        () => mockActivityRepository.getActivityList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => []);""")
    if "AgreementRepository" in classes:
        stubs.append("""
      when(
        () => mockAgreementRepository.getAgreementDetail(
          language: any(named: 'language'),
          userType: any(named: 'userType'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => Agreement(content: '<p>Test</p>'));""")
    if "PaymentRepository" in classes:
        stubs.append("""
      when(
        () => mockPaymentRepository.rechargeDriver(
          language: any(named: 'language'),
          money: any(named: 'money'),
        ),
      ).thenAnswer((_) async => RechargeDriver());""")
    if "UserRepository" in classes:
        stubs.append("""
      when(
        () => mockUserRepository.getUserInfoDetail(
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => UserInfo());""")
    if "UploadImageRepository" in classes:
        stubs.append("""
      when(
        () => mockUploadImageRepository.uploadImage(
          file: any(named: 'file'),
        ),
      ).thenAnswer((_) async => 'https://example.com/image.jpg');""")
    if "RegisterRepository" in classes:
        stubs.append("""
      when(
        () => mockRegisterRepository.registerDriver(
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          code: any(named: 'code'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => null);""")
    if "AdvanceBookingRepository" in classes:
        stubs.append("""
      when(
        () => mockAdvanceBookingRepository.advanceBookingConfirm(
          language: any(named: 'language'),
          orderId: any(named: 'orderId'),
        ),
      ).thenAnswer((_) async {});""")
    return "".join(stubs)


def gen_view_model_imports(repos) -> str:
    if not repos:
        return ""
    classes = {cls for _, cls in repos}
    imports = []
    mapping = {
        "AgreementRepository": "import 'package:new_evmoto_driver/app/data/models/agreement_model.dart';",
        "HistoryBalanceRepository": "import 'package:new_evmoto_driver/app/data/models/history_balance_revenue_model.dart';",
        "AccountRepository": "import 'package:new_evmoto_driver/app/data/models/rating_and_review_model.dart';",
        "OrderRepository": "import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';\nimport 'package:new_evmoto_driver/app/data/models/order_payment_model.dart';\nimport 'package:new_evmoto_driver/app/data/models/order_user_model.dart';",
        "VehicleRepository": "import 'package:new_evmoto_driver/app/data/models/my_vehicle_model.dart';",
        "GuaranteeIncomeRepository": "import 'package:new_evmoto_driver/app/data/models/coupon_income_model.dart';",
        "PaymentRepository": "import 'package:new_evmoto_driver/app/data/models/recharge_driver_model.dart';",
        "UserRepository": "import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';",
    }
    for cls in classes:
        if cls in mapping and mapping[cls] not in imports:
            imports.append(mapping[cls])
    return "\n".join(imports) + ("\n" if imports else "")


def gen_extra_setup(extra: str) -> str:
    if extra == "none":
        return ""
    if extra == "home":
        return "      registerStubHomeController();\n"
    if extra == "home_remote":
        return "      registerStubHomeController();\n"
    if extra == "agreement":
        return ""
    if extra == "user_services":
        return "      registerMockUserServices();\n"
    if extra == "remote_config":
        return ""
    if extra == "splash":
        return "      registerMockUserServices();\n      registerStubHomeController();\n"
    if extra == "order_detail":
        return "      registerStubHomeController();\n      registerMockUserServices();\n"
    if extra == "home_services":
        return "      registerMockUserServices();\n"
    if extra == "photo_args":
        return ""
    if extra == "withdraw_args":
        return ""
    if extra == "extra_account":
        return "      registerStubHomeController();\n"
    if extra == "home_stub":
        return "      registerMockUserServices();\n      registerStubHomeController();\n"
    if extra == "withdraw_stub":
        return """      final withdrawBankAccountRepository = MockBankAccountRepository();
      Get.put<WithdrawController>(
        WithdrawController(bankAccountRepository: withdrawBankAccountRepository),
      );
"""
    if extra == "order_payment":
        return """      registerStubHomeController();
      Get.routing.args = {'order_id': '1', 'order_type': 1};
"""
    return ""


def gen_controller_body(module, class_name, repos, extra, template):
    mocks = gen_mocks(repos)
    if extra == "withdraw_stub" and not any(cls == "BankAccountRepository" for _, cls in (repos or [])):
        mocks = "class MockBankAccountRepository extends Mock implements BankAccountRepository {}\n\n" + mocks
    mock_vars = gen_mock_vars(repos)
    mock_init = gen_mock_init(repos)
    ctor = gen_constructor_args(repos)
    extra_setup = gen_extra_setup(extra)

    if template == "home_stub_ctrl":
        controller_create = "controller = registerStubHomeController();"
        mock_vars = ""
        mock_init = ""
        mocks = ""
    elif repos:
        controller_create = f"controller = {class_name}Controller({ctor});"
    else:
        controller_create = f"controller = {class_name}Controller();"

    tests = gen_controller_tests(module, class_name, repos, template)

    return f"""{gen_imports(class_name, module, repos, template, extra)}
{mocks}void main() {{
  TestWidgetsFlutterBinding.ensureInitialized();

  group('{class_name}Controller', () {{
    late {class_name}Controller controller;
{mock_vars}

    setUp(() async {{
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
{extra_setup}{mock_init}
      {controller_create}
    }});

    tearDown(() {{
      Get.reset();
    }});

{tests}
  }});
}}
"""


def gen_controller_tests(module, class_name, repos, template):
    if module in SKIP_CONTROLLER_MODULES and template in (
        "minimal_ctrl",
        "fetch_ctrl",
        "form_ctrl",
        "otp_ctrl",
        "splash_ctrl",
        "feedback_ctrl",
        "home_stub_ctrl",
    ):
        return f"""    test(
      'can be instantiated',
      () {{
        expect(controller, isA<{class_name}Controller>());
      }},
      skip: true, // Requires integration test setup
    );"""

    if template == "language_ctrl":
        return """    test('initializes tempLanguageCode from language service', () {
      controller.onInit();
      expect(controller.tempLanguageCode.value, isNotEmpty);
    });

    test('updates tempLanguageCode when language is changed', () {
      controller.tempLanguageCode.value = 'EN';
      expect(controller.tempLanguageCode.value, 'EN');
    });"""

    if template == "photo_ctrl":
        return """    test('reads photo URL from Get arguments on init', () {
      Get.routing.args = {'photo_attachment_url': 'https://example.com/photo.jpg'};
      controller.onInit();
      expect(controller.photoAttachmentUrl.value, 'https://example.com/photo.jpg');
    });

    test('defaults photo URL to empty string when argument is missing', () {
      Get.routing.args = null;
      controller.onInit();
      expect(controller.photoAttachmentUrl.value, '');
    });"""

    if template == "completed_ctrl":
        return """    testWidgets('navigates to login page on submit', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const SizedBox()),
            GetPage(name: Routes.LOGIN, page: () => const Scaffold(body: Text('Login'))),
          ],
        ),
      );
      await controller.onTapSubmit();
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.LOGIN);
    });"""

    if template == "register_ctrl":
        return """    test('has invalid form as initial state', () {
      expect(controller.isFormValid.value, isFalse);
      expect(controller.formGroup.valid, isFalse);
    });

    testWidgets('marks form valid with correct phone number', (tester) async {
      controller.formGroup.control('mobile_phone').value = '8123456789';
      controller.formGroup.markAllAsTouched();
      controller.isFormValid.value = controller.formGroup.valid;
      expect(controller.isFormValid.value, isTrue);
    });"""

    if template == "agreement_ctrl":
        snake, cls = repos[0]
        return f"""    test('fetches agreement on init', () async {{
      when(
        () => mock{cls}.getAgreementDetail(
          language: any(named: 'language'),
          userType: any(named: 'userType'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => Agreement(content: '<p>Test content</p>'));

      await controller.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(controller.isFetch.value, isFalse);
      expect(controller.agreement.value.content, '<p>Test content</p>');
    }});"""

    if template == "feedback_ctrl":
        snake, cls = repos[0]
        return f"""    test('shows error when submitting empty feedback', () async {{
      await controller.onTapSubmitFeedback();
      expect(controller.formGroup.valid, isFalse);
    }});

    test('submits feedback when form is valid', () async {{
      when(
        () => mock{cls}.createFeedback(
          language: any(named: 'language'),
          type: any(named: 'type'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async => true);

      controller.formGroup.control('content').value = 'Great app';
      await controller.onTapSubmitFeedback();

      verify(
        () => mock{cls}.createFeedback(
          language: any(named: 'language'),
          type: any(named: 'type'),
          content: 'Great app',
        ),
      ).called(1);
    }});"""

    if template == "switch_ctrl":
        snake, cls = repos[0]
        return f"""    test('loads vehicle detail on init', () async {{
      when(
        () => mock{cls}.getMyVehicleDetail(language: any(named: 'language')),
      ).thenAnswer((_) async => MyVehicle());

      await controller.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(controller.isFetch.value, isFalse);
      verify(() => mock{cls}.getMyVehicleDetail(language: any(named: 'language'))).called(1);
    }});"""

    if template == "splash_ctrl":
        snake, cls = repos[0]
        return f"""    test('loads splash query image', () async {{
      when(
        () => mock{cls}.getQueryImageList(type: any(named: 'type'), usePort: any(named: 'usePort')),
      ).thenAnswer((_) async => [QueryImage(url: 'https://example.com/splash.png')]);

      await controller.getSplashScreenQueryImage();

      expect(controller.splashScreenQueryImage.value.url, 'https://example.com/splash.png');
    }});"""

    if template == "withdraw_detail_ctrl":
        return """    test('loads withdraw detail from arguments', () async {
      final withdraw = HistoryBalanceWithdraw(money: 10000, state: 1);
      Get.routing.args = {'history_balance_withdraw': withdraw};
      await controller.onInit();
      expect(controller.historyBalanceWithdraw.value.money, 10000);
      expect(controller.historyBalanceWithdraw.value.state, 1);
    });"""

    if template == "fetch_ctrl":
        return """    test('initializes with isFetch false after manual setup', () {
      expect(controller.isFetch.value, isFalse);
    });"""

    if template == "form_ctrl":
        return """    test('has form group defined', () {
      expect(controller.formGroup, isNotNull);
    });"""

    if template == "otp_ctrl":
        return """    test('initializes with empty otp code', () {
      expect(controller.otpCode.value, '');
    });"""

    if template == "home_stub_ctrl":
        return """    test('registers home controller with user balance', () {
      expect(controller.userInfo.value.balance, 50000);
    });"""

    if template == "minimal_ctrl":
        return """    test('can be instantiated', () {
      expect(controller, isA<""" + class_name + """Controller>());
    });"""

    return """    test('initializes controller', () {
      expect(controller, isNotNull);
    });"""


def gen_view_body(module, class_name, repos, extra, template):
    mocks = gen_mocks(repos) if repos else ""
    if extra == "withdraw_stub" and not any(cls == "BankAccountRepository" for _, cls in (repos or [])):
        mocks = "class MockBankAccountRepository extends Mock implements BankAccountRepository {}\n\n" + (mocks or "")
    mock_vars = gen_mock_vars(repos) if repos else ""
    mock_init = gen_mock_init(repos) if repos else ""
    ctor = gen_constructor_args(repos) if repos else ""
    extra_setup = gen_extra_setup(extra)

    if template == "home_stub_view":
        controller_create = "controller = registerStubHomeController();"
        mock_vars = ""
        mock_init = ""
        mocks = ""
    elif repos:
        controller_create = f"controller = {class_name}Controller({ctor});"
    else:
        controller_create = f"controller = {class_name}Controller();"

    lang = gen_language_strings(template)
    tests = gen_view_tests(module, class_name, template)
    include_view_stubs = template == "agreement_view" or module not in SKIP_VIEW_MODULES
    view_repo_stubs = gen_view_repo_stubs(repos) if include_view_stubs else ""
    view_model_imports = (
        gen_view_model_imports(repos) if include_view_stubs else ""
    )

    agreement_stub = ""

    photo_setup = ""
    if template == "photo_view":
        photo_setup = """
      Get.routing.args = {'photo_attachment_url': 'https://example.com/photo.jpg'};
      controller.onInit();
"""

    withdraw_setup = ""
    if template == "withdraw_detail_view":
        withdraw_setup = """
      Get.routing.args = {
        'history_balance_withdraw': HistoryBalanceWithdraw(money: 50000, state: 1),
      };
      await controller.onInit();
"""

    return f"""{gen_imports(class_name, module, repos, template, extra)}
{view_model_imports}{mocks}void main() {{
  TestWidgetsFlutterBinding.ensureInitialized();

  group('{class_name}View', () {{
    late {class_name}Controller controller;
{mock_vars}

    Future<void> pumpView(WidgetTester tester) async {{
      await pumpModuleView(tester, const {class_name}View());
      await tester.pump();
    }}

    setUp(() async {{
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language({lang}),
      );
{extra_setup}{mock_init}{view_repo_stubs}
      {controller_create}
      Get.put<{class_name}Controller>(controller);
{agreement_stub}{photo_setup}{withdraw_setup}    }});

    tearDown(() {{
      Get.reset();
    }});

{tests}
  }});
}}
"""


def gen_language_strings(template):
    common = "selectLanguage: 'Select Language', save: 'Save'"
    if template == "register_view":
        return "registerTitle: 'Register', registerSubtitle: 'Enter phone', mobilePhone: 'Mobile Phone', buttonNext: 'Next', formValidationFirst8: 'Must start with 8', formValidationLengthMin8: 'Min 8 digits', formValidationMobileMaxLength: 'Max 15 digits', tncPrivacyConfirmation1: 'By continuing', tncPrivacyConfirmation2: 'and', tncPrivacyConfirmation3: '.', termAndCondition: 'Terms', privacyPolicy: 'Privacy'"
    if template == "completed_view":
        return "registerCompleteTitle: 'Registration Complete', registerCompleteDescription: 'Please wait', registerCompleteTitle1: 'Success', registerCompleteDescription1: 'Your data is being reviewed', confirmation: 'Continue'"
    if template == "language_view":
        return "selectLanguage: 'Select Language', save: 'Save'"
    if template == "agreement_view":
        return "aboutUs: 'About Us'"
    if template == "history_all_view":
        return ""
    if template == "withdraw_detail_view":
        return ""
    if template == "splash_view":
        return ""
    if template == "feedback_view":
        return "sendFeedback: 'Send Feedback'"
    if template == "fetch_view":
        return ""
    if template == "form_view":
        return "save: 'Save'"
    if template == "otp_view":
        return "validateOtpTitle: 'Verify OTP'"
    if template == "webview_view":
        return ""
    if template == "switch_view":
        return ""
    return common


SKIP_VIEW_MODULES = {
    "chat_list",
    "chat_detail",
    "splash_screen",
    "my_activity",
    "my_order",
    "my_order_v2",
    "order_detail",
    "account",
    "login_verification_otp",
    "register_verification_otp",
    "register_form",
    "account_update_mobile_phone",
    "account_update_mobile_phone_verification_otp",
    "withdraw",
    "withdraw_amount",
    "history_balance_all",
    "account_other_setting",
    "order_payment_confirmation",
    "deposit_balance_payment_webview",
    "home",
    "add_edit_withdraw_bank_account",
    "deposit_balance",
    "history_balance_revenue",
    "history_guarantee_income",
    "account_legal_terms_and_platform_rules",
    "account_user_guide",
    "agreement_coupon_income",
    "agreement_guarantee_income",
    "terms_and_conditions",
    "account_my_evaluation",
    "splash_screen",
    "order_payment_detail",
    "order_payment_pending",
    "order_payment_pending_fee_detail",
    "withdraw_detail",
}

SKIP_CONTROLLER_MODULES = SKIP_VIEW_MODULES | {
    "account_feedback",
    "splash_screen",
    "order_payment_pending",
    "order_payment_detail",
    "order_payment_pending_fee_detail",
    "history_balance_revenue",
    "history_guarantee_income",
}


def gen_view_tests(module, class_name, template):
    if module in SKIP_VIEW_MODULES and template in (
        "minimal_view",
        "form_view",
        "otp_view",
        "fetch_view",
        "history_all_view",
        "switch_view",
        "webview_view",
        "order_payment_view",
        "withdraw_detail_view",
    ):
        return f"""    testWidgets(
      'renders {class_name} screen',
      (tester) async {{
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
      }},
      skip: true, // View requires integration test setup
    );"""

    if template == "language_view":
        return """    testWidgets('renders language options', (tester) async {
      await pumpView(tester);
      expect(find.text('Select Language'), findsWidgets);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Bahasa Indonesia'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });"""

    if template == "register_view":
        return """    testWidgets('renders register form', (tester) async {
      await pumpView(tester);
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Enter phone'), findsOneWidget);
      expect(find.text('Mobile Phone'), findsOneWidget);
      expect(find.text('+62'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });"""

    if template == "completed_view":
        return """    testWidgets('renders completion screen', (tester) async {
      await pumpView(tester);
      expect(find.text('Registration Complete'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });"""

    if template == "photo_view":
        return """    testWidgets('renders photo viewer scaffold', (tester) async {
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });"""

    if template == "agreement_view":
        return """    testWidgets('renders agreement app bar', (tester) async {
      await pumpView(tester);
      await tester.pump();
      expect(find.text('About Us'), findsOneWidget);
    });"""

    if template == "history_all_view":
        return """    testWidgets('renders history balance hub', (tester) async {
      await pumpView(tester);
      expect(find.text('Seluruh Riwayat'), findsOneWidget);
      expect(find.text('Saldo Aktif Saya'), findsOneWidget);
    });"""

    if template == "withdraw_detail_view":
        return """    testWidgets('renders withdraw detail screen', (tester) async {
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });"""

    if template == "webview_view":
        return """    testWidgets(
      'renders scaffold with app bar',
      (tester) async {
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      },
      skip: true, // InAppWebView is not supported in widget tests
    );"""

    if template == "splash_view":
        return """    testWidgets('renders splash screen scaffold', (tester) async {
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });"""

    if template == "home_stub_view":
        return """    testWidgets(
      'renders home screen',
      (tester) async {
        await pumpView(tester);
        expect(find.byType(Scaffold), findsOneWidget);
      },
      skip: true, // HomeView requires heavy runtime dependencies
    );"""

    if template == "minimal_view":
        return f"""    testWidgets('renders {class_name} screen', (tester) async {{
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    }});"""

    if template == "fetch_view":
        return """    testWidgets('renders screen scaffold', (tester) async {
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });"""

    if template == "form_view":
        return """    testWidgets('renders form screen', (tester) async {
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });"""

    if template == "feedback_view":
        return """    testWidgets('renders feedback screen', (tester) async {
      await pumpView(tester);
      expect(find.text('Send Feedback'), findsOneWidget);
    });"""

    if template == "otp_view":
        return """    testWidgets('renders OTP screen', (tester) async {
      await pumpView(tester);
      expect(find.text('Verify OTP'), findsOneWidget);
    });"""

    if template == "switch_view":
        return """    testWidgets('renders switch vehicle screen', (tester) async {
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });"""

    if template == "order_payment_view":
        return """    testWidgets('renders order payment confirmation screen', (tester) async {
      controller.isFetch.value = false;
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });"""

    return """    testWidgets('renders screen', (tester) async {
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });"""


def main():
    for entry in MODULES:
        module, class_name, repos_raw, extra, ctrl_tpl, view_tpl = entry
        if module in SKIP:
            continue
        repos = repo_info(entry)

        ctrl_dir = TEST_DIR / module / "controllers"
        view_dir = TEST_DIR / module / "views"
        ctrl_dir.mkdir(parents=True, exist_ok=True)
        view_dir.mkdir(parents=True, exist_ok=True)

        ctrl_path = ctrl_dir / f"{module}_controller_test.dart"
        view_path = view_dir / f"{module}_view_test.dart"

        ctrl_content = gen_controller_body(module, class_name, repos, extra, ctrl_tpl)
        view_content = gen_view_body(module, class_name, repos, extra, view_tpl)

        ctrl_path.write_text(ctrl_content)
        view_path.write_text(view_content)
        print(f"Generated tests for {module}")


if __name__ == "__main__":
    main()
