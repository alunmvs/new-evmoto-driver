# Project Overview — new_evmoto_driver (Evmoto Driver)

> Generated from reverse-engineering the existing Flutter/GetX codebase.  
> Assumptions are marked explicitly where implementation evidence is incomplete.

---

## 1. Project Summary

**Evmoto Driver** (`new_evmoto_driver`) is the official mobile application for **electric motorcycle ride-hailing drivers** in Indonesia. It supports daily driver operations: authentication, receiving and fulfilling ride orders, real-time location tracking, in-app chat with passengers, earnings programs (guarantee income, coupon income), deposit balance management, fund withdrawal, notifications, and account settings.

| Aspect | Evidence |
|---|---|
| **What it does** | Driver-side ride-hailing ops: order hall, in-service orders, maps/navigation, payments, wallet, chat, earnings |
| **Business purpose** | Enable Evmoto drivers to go online, accept orders, complete trips, and manage income/deposits |
| **Target users** | Registered Evmoto electric-motorcycle drivers (`role: "driver"` in API headers) |
| **App identity** | `pubspec.yaml` description; Android `applicationId`: `com.evmoto.driver.app`; iOS display name: `Evmoto Driver` |
| **Current version** | `1.9.4+50` (`pubspec.yaml`) |

**Assumption:** The primary market is Indonesia (default language `ID`, phone prefix `62`, Indonesian copy in controllers). Multi-language support (EN, ZH_CN) suggests expansion or driver demographics beyond Indonesia.

---

## 2. Business Features

### Authentication & Onboarding

| Item | Detail |
|---|---|
| **Purpose** | Driver login via mobile OTP; new driver registration with document upload |
| **Screens** | `SplashScreenView`, `LoginView`, `LoginVerificationOtpView`, `RegisterView`, `RegisterVerificationOtpView`, `RegisterFormView`, `RegisterFormCompletedView`, `TermsAndConditionsView`, `PrivacyPolicyView` |
| **Modules** | `splash_screen`, `login`, `login_verification_otp`, `register`, `register_verification_otp`, `register_form`, `register_form_completed`, `terms_and_conditions`, `privacy_policy` |

### Home Dashboard & Order Operations

| Item | Detail |
|---|---|
| **Purpose** | Main driver workspace: online/offline toggle, order grabbing hall, in-service orders, statistics, guarantee income progress |
| **Screens** | `HomeView` (shell with bottom tabs), sub-views: `home_balance_sub_view`, `home_statistics_card_sub_view`, `order_card_home_sub_view`, guarantee income cards |
| **Modules** | `home`, `order_detail`, `order_payment_confirmation`, `order_payment_detail`, `order_payment_pending`, `order_payment_pending_fee_detail`, `switch_vehicle` |

### Order History

| Item | Detail |
|---|---|
| **Purpose** | View past orders by status (all, pending payment, cancelled) |
| **Screens** | `MyOrderView`, `MyOrderV2View` (parallel implementations) |
| **Modules** | `my_order`, `my_order_v2` |

### Chat & Notifications

| Item | Detail |
|---|---|
| **Purpose** | Order-linked chat with passengers; push and in-app notifications |
| **Screens** | `ChatListView`, `ChatDetailView`, `NotificationView` |
| **Modules** | `chat_list`, `chat_detail`, `notification` |

### Wallet, Deposit & Withdrawal

| Item | Detail |
|---|---|
| **Purpose** | Manage driver deposit balance, top-up via payment gateway WebView, withdraw earnings to bank accounts |
| **Screens** | `DepositBalanceView`, `DepositBalancePaymentWebviewView`, `WithdrawView`, `WithdrawAmountView`, `WithdrawDetailView`, `AddEditWithdrawBankAccountView` |
| **Modules** | `deposit_balance`, `deposit_balance_payment_webview`, `withdraw`, `withdraw_amount`, `withdraw_detail`, `add_edit_withdraw_bank_account` |

### Balance & Earnings History

| Item | Detail |
|---|---|
| **Purpose** | Transaction history: all, revenue, recharge, withdrawal; guarantee income and coupon income activity |
| **Screens** | `HistoryBalanceAllView`, `HistoryBalanceRevenueView`, `HistoryBalanceRechargeView`, `HistoryBalanceWithdrawView`, `HistoryGuaranteeIncomeView`, `MyActivityView` |
| **Modules** | `history_balance_all`, `history_balance_revenue`, `history_balance_recharge`, `history_balance_withdraw`, `history_guarantee_income`, `my_activity` |

### Driver Earnings Programs

| Item | Detail |
|---|---|
| **Purpose** | Guarantee income and coupon income programs with agreements and progress tracking |
| **Screens** | `AgreementGuaranteeIncomeView`, `AgreementCouponIncomeView`, guarantee income widgets on home |
| **Modules** | `agreement_guarantee_income`, `agreement_coupon_income` |

### Account & Settings

| Item | Detail |
|---|---|
| **Purpose** | Profile, language, feedback, customer service, legal docs, app version, logout, account deletion |
| **Screens** | `AccountView` (embedded in home tab + standalone route), `AccountLanguageView`, `AccountFeedbackView`, `AccountServiceView`, `AccountMyEvaluationView`, `AccountUserGuideView`, `AccountAboutUsView`, `AccountOtherSettingView`, `AccountLegalTermsAndPlatformRulesView`, `AccountUpdateMobilePhoneView`, `AccountUpdateMobilePhoneVerificationOtpView` |
| **Modules** | `account`, `account_language`, `account_feedback`, `account_service`, `account_my_evaluation`, `account_user_guide`, `account_about_us`, `account_other_setting`, `account_legal_terms_and_platform_rules`, `account_update_mobile_phone`, `account_update_mobile_phone_verification_otp` |

### Utility

| Item | Detail |
|---|---|
| **Purpose** | Full-screen image viewing |
| **Screens** | `PhotoViewerView` |
| **Modules** | `photo_viewer` |

---

## 3. Technical Stack

| Category | Technology | Version (from `pubspec.yaml`) |
|---|---|---|
| Framework | Flutter | SDK (Dart `^3.9.2`) |
| Language | Dart | `^3.9.2` |
| State management / DI / Routing | GetX (`get`) | `^4.7.2` |
| HTTP client | Dio | `^5.9.0` |
| Secure storage | `flutter_secure_storage` | `^10.0.0` |
| Preferences | `shared_preferences` | `^2.5.3` |
| Environment vars | `flutter_dotenv` | `^6.0.0` |
| Forms | `reactive_forms` | `^18.2.0` |
| Maps | `google_maps_flutter`, `geolocator`, `flutter_polyline_points`, `maps_toolkit`, `turf` | Various |
| Firebase | Core, Crashlytics, Remote Config, Messaging, Firestore, Storage | `^4.2.1` – `^16.1.0` |
| Background service | `flutter_background_service` | `^5.1.0` |
| Local notifications | `flutter_local_notifications` | `^19.5.0` |
| WebView | `flutter_inappwebview` | `^6.1.5` |
| UI utilities | `google_fonts`, `flutter_svg`, `cached_network_image`, `carousel_slider`, `showcaseview`, `pull_to_refresh_flutter3`, `pinput`, `action_slider` | Various |
| Media | `image_picker`, `photo_view`, `ffmpeg_kit_flutter_new`, `gallery_saver_plus` | Various |
| CLI / tooling | `get_cli`, `flutter_launcher_icons`, `flutter_lints` | Dev deps |
| i18n | `intl`, `flutter_localizations` | `^0.20.2` |

**Not used (confirmed absent from dependencies):** Hive, GetStorage, BLoC, Provider, Riverpod, Firebase Analytics.

---

## 4. Architecture Overview

The project follows a **Feature-First GetX Modular Architecture** with a **Repository Pattern** for data access. It is **not** full Clean Architecture — there is no separate `domain/` or `usecase/` layer.

```
View (GetView + Obx)
    ↓
Controller (GetxController)
    ↓
Repository (concrete class)
    ↓
ApiServices (Dio) / FlutterSecureStorage / Firebase / Socket

Global cross-cutting logic → GetxService (registered in main.dart)
```

### Layer Responsibilities

| Layer | Location | Responsibility | Example |
|---|---|---|---|
| **Binding** | `modules/<feature>/bindings/` | Registers controller + injects repositories | `HomeBinding` → `Get.lazyPut<HomeController>(...)` |
| **Controller** | `modules/<feature>/controllers/` | UI state (`.obs`), business logic, navigation | `HomeController` — order hall, socket handlers, maps |
| **View** | `modules/<feature>/views/` | Widget tree, `Obx` rebuilds, user interaction | `HomeView extends GetView<HomeController>` |
| **Repository** | `app/repositories/` | API calls, token headers, model parsing | `OrderRepository`, `LoginRepository` |
| **Service** | `app/services/` | App-wide singletons (auth session, socket, location) | `UserServices`, `SocketServices` |
| **Model** | `app/data/models/` | DTOs with `fromJson`/`toJson` | `OrderModel`, `UserInfo` |

**Home shell pattern:** `HomeView` uses `selectedIndex` (0 = dashboard, 1 = account) as an in-view bottom navigation — not nested `GetPage` routes.

---

## 5. Application Flow

```mermaid
graph TD
    A[main.dart] --> B[WidgetsFlutterBinding + Firebase init]
    B --> C[dotenv.load .env]
    C --> D[Register 12 GetxService permanent]
    D --> E[GetMaterialApp initialRoute: /splash-screen]
    E --> F[SplashScreenController.onInit]
    F --> G{token in Secure Storage?}
    G -->|No| H[/login]
    G -->|Yes| I[UserServices.manualOnInit + LocationServices]
    I --> J[/home]
    H --> K[Login → OTP → store token → /home]
    J --> L[HomeController: socket, background service, orders]
```

### Startup sequence (`lib/main.dart`)

1. Initialize bindings, timezone, date formatting (`id_ID`).
2. Load `.env` via `flutter_dotenv`.
3. Initialize Firebase; attach Crashlytics global error handlers.
4. Register permanent services: `ThemeColorServices`, `TypographyServices`, `LanguageServices`, `ApiServices`, `FirebaseRemoteConfigServices`, `FirebasePushNotificationServices`, `UserServices`, `VoiceServices`, `BackgroundServices`, `AppLifecycleController`, `LocationServices`, `SocketServices`.
5. Launch `GetMaterialApp` with `initialRoute: AppPages.INITIAL` (`/splash-screen`).
6. `routingCallback`: when navigating to `/home`, refresh `HomeController` if registered.

### Auth gate (`SplashScreenController`)

- Reads `token` from `FlutterSecureStorage`.
- No token → delay 2s → `Get.offAndToNamed(Routes.LOGIN)`.
- Has token → load user info, request location → `Get.offAndToNamed(Routes.HOME)`.

---

## 6. Folder Structure

```
lib/
├── main.dart                 # App entry, global service registration, GetMaterialApp
├── environment.dart          # baseUrl, socketUrl, Sendbird prefixes, env label
└── app/
    ├── data/
    │   ├── consts/           # Domain constants (OrderState)
    │   └── models/           # 49 API/DTO models
    ├── modules/              # 47 feature modules (bindings/controllers/views)
    ├── repositories/         # 25 data-access classes
    ├── routes/
    │   ├── app_pages.dart    # GetPage definitions
    │   └── app_routes.dart   # Route path constants (get_cli generated)
    ├── services/             # 12 global GetxService classes
    ├── utils/                # 10 helper utilities
    └── widgets/              # Shared reusable widgets & dialogs

assets/
├── icons/                    # ~90 SVG/PNG icons
├── images/                   # Backgrounds, empty states, onboarding art
├── jsons/                    # i18n JSON (id, en, zh_cn)
└── logos/                    # App logo

android/                      # Gradle, Firebase, signing, Maps API key
ios/                          # Xcode project, Firebase, background modes
```

| Folder | Purpose |
|---|---|
| `lib/app/modules/` | Isolated feature UI + logic per business domain |
| `lib/app/repositories/` | REST API abstraction; reads token from secure storage per request |
| `lib/app/services/` | Long-lived global state and infrastructure |
| `lib/app/widgets/` | Cross-module UI components (loaders, dialogs) |
| `lib/app/utils/` | Pure helpers (snackbar, maps, socket, upload) |
| `assets/jsons/` | Runtime-loaded translation strings |

---

## 7. Module Overview

47 modules under `lib/app/modules/`. Each follows `bindings/`, `controllers/`, `views/` (with optional sub-views).

### Core & Auth

| Module | Purpose | Main Screen | Controller |
|---|---|---|---|
| `splash_screen` | Boot, token check, splash image | `SplashScreenView` | `SplashScreenController` |
| `login` | Phone number entry | `LoginView` | `LoginController` |
| `login_verification_otp` | OTP login, token storage | `LoginVerificationOtpView` | `LoginVerificationOtpController` |
| `register` | Registration phone entry | `RegisterView` | `RegisterController` |
| `register_verification_otp` | Registration OTP | `RegisterVerificationOtpView` | `RegisterVerificationOtpController` |
| `register_form` | Driver document/form submission | `RegisterFormView` | `RegisterFormController` |
| `register_form_completed` | Registration success | `RegisterFormCompletedView` | `RegisterFormCompletedController` |
| `terms_and_conditions` | Legal T&C display | `TermsAndConditionsView` | `TermsAndConditionsController` |
| `privacy_policy` | Privacy policy display | `PrivacyPolicyView` | `PrivacyPolicyController` |

### Operations

| Module | Purpose | Main Screen | Controller |
|---|---|---|---|
| `home` | Dashboard shell, orders, maps, online status | `HomeView` | `HomeController` |
| `order_detail` | Active order: map, chat, state transitions | `OrderDetailView` | `OrderDetailController` |
| `order_payment_confirmation` | Payment confirmation step | `OrderPaymentConfirmationView` | `OrderPaymentConfirmationController` |
| `order_payment_detail` | Payment breakdown | `OrderPaymentDetailView` | `OrderPaymentDetailController` |
| `order_payment_pending` | Pending payment orders | `OrderPaymentPendingView` | `OrderPaymentPendingController` |
| `order_payment_pending_fee_detail` | Pending fee detail | `OrderPaymentPendingFeeDetailView` | `OrderPaymentPendingFeeDetailController` |
| `my_order` | Order history (tabs: all/pending/cancelled) | `MyOrderView` | `MyOrderController` |
| `my_order_v2` | Alternate order history UI | `MyOrderV2View` | `MyOrderV2Controller` |
| `switch_vehicle` | Switch active vehicle | `SwitchVehicleView` | `SwitchVehicleController` |
| `chat_list` | Order chat inbox | `ChatListView` | `ChatListController` |
| `chat_detail` | Order chat thread | `ChatDetailView` | `ChatDetailController` |
| `notification` | In-app notifications | `NotificationView` | `NotificationController` |

### Finance

| Module | Purpose | Main Screen | Controller |
|---|---|---|---|
| `deposit_balance` | Deposit balance & top-up | `DepositBalanceView` | `DepositBalanceController` |
| `deposit_balance_payment_webview` | Payment gateway WebView | `DepositBalancePaymentWebviewView` | `DepositBalancePaymentWebviewController` |
| `withdraw` | Withdrawal hub | `WithdrawView` | `WithdrawController` |
| `withdraw_amount` | Enter withdrawal amount | `WithdrawAmountView` | `WithdrawAmountController` |
| `withdraw_detail` | Withdrawal detail | `WithdrawDetailView` | `WithdrawDetailController` |
| `add_edit_withdraw_bank_account` | Bank account CRUD | `AddEditWithdrawBankAccountView` | `AddEditWithdrawBankAccountController` |
| `history_balance_all` | All balance transactions | `HistoryBalanceAllView` | `HistoryBalanceAllController` |
| `history_balance_revenue` | Revenue history | `HistoryBalanceRevenueView` | `HistoryBalanceRevenueController` |
| `history_balance_recharge` | Recharge history | `HistoryBalanceRechargeView` | `HistoryBalanceRechargeController` |
| `history_balance_withdraw` | Withdrawal history | `HistoryBalanceWithdrawView` | `HistoryBalanceWithdrawController` |

### Earnings & Activity

| Module | Purpose | Main Screen | Controller |
|---|---|---|---|
| `my_activity` | Driver activity, guarantee/coupon income tabs | `MyActivityView` | `MyActivityController` |
| `history_guarantee_income` | Guarantee income history | `HistoryGuaranteeIncomeView` | `HistoryGuaranteeIncomeController` |
| `agreement_guarantee_income` | Guarantee income agreement | `AgreementGuaranteeIncomeView` | `AgreementGuaranteeIncomeController` |
| `agreement_coupon_income` | Coupon income agreement | `AgreementCouponIncomeView` | `AgreementCouponIncomeController` |

### Account

| Module | Purpose | Main Screen | Controller |
|---|---|---|---|
| `account` | Profile, settings menu, logout | `AccountView` | `AccountController` |
| `account_language` | Language switcher | `AccountLanguageView` | `AccountLanguageController` |
| `account_feedback` | Submit feedback | `AccountFeedbackView` | `AccountFeedbackController` |
| `account_service` | Customer service | `AccountServiceView` | `AccountServiceController` |
| `account_my_evaluation` | Driver ratings/reviews | `AccountMyEvaluationView` | `AccountMyEvaluationController` |
| `account_user_guide` | User guide | `AccountUserGuideView` | `AccountUserGuideController` |
| `account_about_us` | About app | `AccountAboutUsView` | `AccountAboutUsController` |
| `account_other_setting` | Misc settings | `AccountOtherSettingView` | `AccountOtherSettingController` |
| `account_legal_terms_and_platform_rules` | Legal & platform rules | `AccountLegalTermsAndPlatformRulesView` | `AccountLegalTermsAndPlatformRulesController` |
| `account_update_mobile_phone` | Change phone number | `AccountUpdateMobilePhoneView` | `AccountUpdateMobilePhoneController` |
| `account_update_mobile_phone_verification_otp` | Phone change OTP | `AccountUpdateMobilePhoneVerificationOtpView` | `AccountUpdateMobilePhoneVerificationOtpController` |

### Utility

| Module | Purpose | Main Screen | Controller |
|---|---|---|---|
| `photo_viewer` | Full-screen image viewer | `PhotoViewerView` | `PhotoViewerController` |

---

## 8. Routing Overview

### Strategy

- **GetX named routes** via `GetMaterialApp.getPages` and `AppPages.routes`.
- Route constants in `app_routes.dart` (generated by `get_cli` — file header says "DO NOT EDIT").
- Navigation: `Get.toNamed()`, `Get.offNamed()`, `Get.offAllNamed()`.
- Arguments passed via `Get.arguments` (e.g. OTP screens receive `mobile_phone`).

### Registration

- **Initial route:** `/splash-screen` (`AppPages.INITIAL`).
- **47 `GetPage` entries** in `lib/app/routes/app_pages.dart`.
- **Special case:** `/home` registers **two bindings**: `HomeBinding()` + `AccountBinding()` because account tab is embedded in home shell.

### Example

```dart
GetPage(
  name: _Paths.HOME,
  page: () => const HomeView(),
  bindings: [HomeBinding(), AccountBinding()],
),
GetPage(
  name: _Paths.LOGIN_VERIFICATION_OTP,
  page: () => const LoginVerificationOtpView(),
  binding: LoginVerificationOtpBinding(),
),
```

### Navigation from home

| Destination | Route constant | Trigger |
|---|---|---|
| Order history | `Routes.MY_ORDER` | Home statistics card (`home_controller.dart`) |
| Chat list | `Routes.CHAT_LIST` | Home statistics card |
| Notifications | `Routes.NOTIFICATION` | Home statistics card |
| My activity | `Routes.MY_ACTIVITY` | Guarantee income card |
| Order detail | `Routes.ORDER_DETAIL` | Order card tap, socket events |

**Note:** `Routes.MY_ORDER_V2` is registered but active navigation from home uses `MY_ORDER`.

---

## 9. State Management Overview

### Pattern: GetX Reactive (`.obs` + `Obx`)

| Mechanism | Usage in project |
|---|---|
| **Reactive variables** | `final foo = "".obs`, `Rx<T>`, `RxList<T>` in all controllers and services |
| **Obx** | Primary UI rebuild mechanism (~60+ usages across views) |
| **GetView** | Most views extend `GetView<XController>` for typed `controller` access |
| **GetBuilder** | **Not used** anywhere in `lib/` |
| **setState** | **Not used** anywhere in `lib/` |
| **Workers** | `ever()` in `OrderDetailController` for location/state side effects |

### Project-wide conventions

- Controllers expose `isFetch.obs` for loading states.
- Theme and typography accessed reactively via `Get.find<ThemeColorServices>()` / `TypographyServices`.
- `UserServices.userInfo` is a global reactive user profile shared across modules.
- `HomeController` uses `GetSingleTickerProviderStateMixin` for `TabController`.

---

## 10. Dependency Injection Overview

### Global services (`main.dart`)

All registered with `Get.put(..., permanent: true)` at startup:

`ThemeColorServices`, `TypographyServices`, `LanguageServices`, `ApiServices`, `FirebaseRemoteConfigServices`, `FirebasePushNotificationServices`, `UserServices`, `VoiceServices`, `BackgroundServices`, `AppLifecycleController`, `LocationServices`, `SocketServices`.

### Per-route bindings

Controllers registered via `Get.lazyPut` in feature bindings:

```dart
// lib/app/modules/login/bindings/login_binding.dart
Get.lazyPut<LoginController>(
  () => LoginController(loginRepository: LoginRepository()),
);
```

Repositories are **instantiated inline** in bindings (not registered in GetX DI container).

### Direct `Get.find()` usage

Controllers and services resolve dependencies at runtime: `Get.find<UserServices>()`, `Get.find<HomeController>()` from `SocketServices`, `AccountController`, etc.

### `SharedPreferences` flag

`home_controller_registered` boolean tracks whether `HomeController` is alive for refresh on route callback.

---

## 11. Data Layer Overview

### Remote data sources

| Source | Access layer | Purpose |
|---|---|---|
| REST API (`baseUrl` from `environment.dart`) | 25 repositories via `ApiServices.dio` | Orders, auth, payments, user, vehicles, withdrawals |
| TCP Socket (port 8888) | `SocketServices` | Real-time order status, driver position |
| Cloud Firestore | Direct in controllers | Order chat messages/participants |
| Firebase Storage | `UploadImageRepository` | Image uploads |
| Google Maps APIs | `GoogleMapsRepository` + `dotenv GOOGLE_KEY` | Directions, geocoding, place search |
| Firebase Remote Config | `FirebaseRemoteConfigServices` | CS WhatsApp, store links, defaults |

### Local data sources

| Storage | Usage |
|---|---|
| `FlutterSecureStorage` | `token`, `device_id` |
| `SharedPreferences` | `first_run`, `language_code`, `home_controller_registered`, cleared on logout |
| Asset JSON | Translation files loaded by `LanguageServices` |

### Storage strategy

- **Sensitive:** token and device ID in secure storage.
- **Non-sensitive flags:** SharedPreferences.
- **No offline database** (no Hive/SQLite caching of API responses).

### Models

49 model files in `lib/app/data/models/` with `fromJson`/`toJson`. Domain constants in `lib/app/data/consts/order_state_const.dart` (`OrderState` with 12 states).

---

## 12. API Integration Overview

### API client

`ApiServices` (`lib/app/services/api_services.dart`) wraps a singleton `Dio` instance.

**Base URL:** `lib/environment.dart` — currently **Development v2**:

```dart
const String baseUrl = 'http://8.215.203.97:8500';
const String socketUrl = '8.215.203.97';
const String env = "dev";
```

Production and dev v1 URLs exist as commented alternatives in the same file.

### Request headers (interceptor)

Every request adds:

| Header | Value |
|---|---|
| `version` | App package version |
| `deviceid` | UUID from secure storage |
| `timestamp` | Current epoch ms |
| `from` | `android` / `ios` |
| `role` | `driver` |
| `nonce` | MD5 of timestamp |

Authenticated endpoints add `Authorization: Bearer <token>` per repository.

### Authentication strategy

- Login endpoints (`LoginRepository`) return a token; stored as `token` in secure storage.
- Repositories read token per request; no centralized auth interceptor attaching Bearer token globally.

### Interceptors

1. `CurlLoggingInterceptor` (request/response logs disabled in config).
2. Custom `InterceptorsWrapper`:
   - **Response code `600`:** forced logout — clears storage, stops background service, closes socket, navigates to login ("Login di perangkat lain").
3. Commented-out: `RetryInterceptor`, global error message interceptor.

### Error handling

- Repositories throw `response.data['msg']` or `DioException.message`.
- Controllers catch and show `SnackbarHelper.showSnackbarError(...)`.
- No unified `ErrorHelper` pipeline across all modules (utility exists but usage is inconsistent).

### API path examples

| Domain | Example path |
|---|---|
| Login | `/account/base/driver/driverLoginByOtp` |
| User info | `/driver/api/driver/queryInfo` |
| Working area | `/driver/api/driver/workingArea` |

---

## 13. Local Storage Overview

| Technology | Used | Keys / Data |
|---|---|---|
| **FlutterSecureStorage** | Yes | `token`, `device_id`; `deleteAll()` on logout and first run |
| **SharedPreferences** | Yes | `first_run`, `language_code`, `home_controller_registered`; `prefs.clear()` on logout |
| **Hive** | No | — |
| **GetStorage** | No | — |

### First-run behavior

`SplashScreenController.checkIfAppFirstRun()` clears secure storage on first launch and sets `first_run = false`.

---

## 14. Authentication Overview

### Login flow

1. `LoginView` — driver enters mobile number (prefix `62` added).
2. `LoginRepository.checkPhoneRegistered()` — rejects unregistered numbers.
3. Navigate to `LoginVerificationOtpView` with phone argument.
4. `OtpRepository.requestOTP()` (type `3`).
5. `LoginRepository.loginByMobileNumberOtp()` — returns token.
6. Token written to secure storage → `Get.offAllNamed(Routes.HOME)`.

**Note:** `loginByMobileNumber` (password) exists in repository but the UI flow uses OTP only.

### Token storage

```dart
await storage.write(key: "token", value: token);
```

### Session management

- Token checked on splash screen.
- `UserServices.manualOnInit()` loads profile after auth.
- API response code `600` triggers forced session termination.
- `SocketServices` reconnects when token exists (3-second periodic check).

### Logout flow (`AccountController.onTapLogout`)

1. Stop background service, cancel location stream, unsubscribe FCM.
2. `storage.deleteAll()`, `prefs.clear()`, close websocket.
3. `userServices.clearUserInfo()`.
4. `Get.offAllNamed(Routes.LOGIN)`.

Account deletion follows a similar cleanup path (OTP-verified).

---

## 15. Theme & UI Overview

### Theme strategy

- **Not** standard Material `ThemeData`/`ColorScheme` for colors and typography.
- `ThemeColorServices` — reactive `Color` tokens (primary blue `#0060C6`, semantic greens/reds, neutrals).
- `TypographyServices` — reactive `TextStyle` via **Google Fonts Nunito Sans** (heading/body/label scales).
- `main.dart` only customizes `textSelectionTheme` from `ThemeColorServices`.

### Design system

- Documented separately in `docs/ui-guidelines.md` (referenced in IDE, not analyzed here).
- Icons: SVG assets in `assets/icons/` referenced by path string.
- Shared loaders: `LoaderElevatedButton`, `LoaderOutlinedButton`, `LoadingDialog`.

### Shared widgets (`lib/app/widgets/`)

| Widget | Purpose |
|---|---|
| `loader_elevated_button_widget.dart` | Button with loading state |
| `loader_outlined_button_widget.dart` | Outlined button with loading |
| `loading_dialog.dart` | Modal loading |
| `dashed_line.dart` | Visual divider |
| `global_body_handler.dart` | Body wrapper utility |
| `dialog/guarantee_income_area_in_dialog.dart` | Guarantee income zone dialog |
| `dialog/guarantee_income_area_out_dialog.dart` | Out-of-zone warning |
| `advance_booking_cancel_dialog_widget.dart` | Advance booking cancel confirm |

### Responsive strategy

- Layout uses `MediaQuery`, `Get.width`, fixed padding — no dedicated responsive framework.
- Sub-view pattern: complex screens split into `views/<feature>_view/` sub-widgets.

### UI libraries in use

`flutter_svg`, `cached_network_image`, `carousel_slider`, `showcaseview` (coachmarks), `pull_to_refresh_flutter3`, `pinput`, `action_slider`, `animated_toggle_switch`, `dots_indicator`.

---

## 16. Assets Overview

### Registered in `pubspec.yaml`

```yaml
assets:
  - assets/images/
  - assets/icons/
  - assets/logos/
  - assets/jsons/
  - .env
```

### Images (`assets/images/`)

Backgrounds (`img_background_home.png`, `img_background_splash_screen.png`, chat, balance), empty states, onboarding, guarantee income illustrations, error/update prompts, registration progress SVGs.

### Icons (`assets/icons/`)

~90 SVG icons for navigation, account menu, order states, wallet, chat, notifications.

### Logos (`assets/logos/`)

`logo_evmoto.svg`, `logo.png` (launcher icon source).

### Fonts

No custom font files bundled — typography via `google_fonts` package (Nunito Sans downloaded at runtime).

### Localization resources

| File | Language |
|---|---|
| `assets/jsons/driver_lang_id.json` | Indonesian (default, `languageCodeSystem = 3`) |
| `assets/jsons/driver_lang_en.json` | English (`languageCodeSystem = 2`) |
| `assets/jsons/driver_lang_zh_cn.json` | Chinese Simplified (`languageCodeSystem = 1`) |

Loaded by `LanguageServices.switchLanguage()` into `Language` model; accessed as `languageServices.language.value.<key>`.

`GetMaterialApp` also declares `supportedLocales`: `en_US`, `id_ID`, `zh_CN` for system widgets.

---

## 17. Environment Configuration

### `lib/environment.dart`

Compile-time constants selected by commenting/uncommenting blocks:

| Environment | baseUrl | Status |
|---|---|---|
| Production | `https://api.evmotoid.com` | Commented out |
| Development v2 | `http://8.215.203.97:8500` | **Active** |
| Development v1 | `http://api-dev.evmotoapp.com:8500` | Commented out |

Also defines `socketUrl`, `prefixSendbirdUser`, `prefixSendbirdDriver`, `env`.

### `.env` (flutter_dotenv)

Loaded in `main.dart`. Used for `GOOGLE_KEY` in `GoogleMapsRepository`. File is listed as a Flutter asset (contents not in repo — **assumption:** provided locally per developer).

### Firebase Remote Config defaults

`driver_base_url`, `driver_cs_whatsapp`, `driver_appstore_link`, `driver_playstore_link` — but API `baseUrl` still comes from `environment.dart`, not Remote Config.

### Build flavors

**Not implemented.** No `productFlavors` in Android Gradle; no Xcode schemes for dev/prod environment switching.

### Maps API keys

- Android: `MAPS_API_KEY` from `local.properties` → manifest placeholder.
- iOS: `MAPS_API_KEY` in `Info.plist`.

---

## 18. Third-Party Services

| Service | Package / Integration | Usage |
|---|---|---|
| **Firebase Core** | `firebase_core` | App initialization |
| **Firebase Crashlytics** | `firebase_crashlytics` | Global fatal error reporting |
| **Firebase Remote Config** | `firebase_remote_config` | CS WhatsApp, store links |
| **Firebase Cloud Messaging** | `firebase_messaging` | Push notifications + background handler |
| **Cloud Firestore** | `cloud_firestore` | Order chat (messages, participants, read status) |
| **Firebase Storage** | `firebase_storage` | Image upload |
| **Google Maps** | `google_maps_flutter` | Order detail map, polylines, markers |
| **Geolocator** | `geolocator` | Driver GPS tracking |
| **Background Service** | `flutter_background_service` | Location/socket while online |
| **Local Notifications** | `flutter_local_notifications` | FCM display, background service notification |
| **Payment gateway** | REST + `flutter_inappwebview` | Deposit top-up redirect URL |
| **WhatsApp** | `url_launcher` | Customer support link from Remote Config |
| **Share** | `share_plus` | Share app store link |
| **FFmpeg** | `ffmpeg_kit_flutter_new` | Present in dependencies; specific call sites not verified in this overview |
| **Sendbird** | Prefix constants only | `isSendbirdInit` flag in `HomeController`; **no Sendbird SDK** in `pubspec.yaml` |
| **Analytics** | — | **Not integrated** |

---

## 19. Build & Deployment Overview

### Android (`android/app/build.gradle.kts`)

| Setting | Value |
|---|---|
| Application ID | `com.evmoto.driver.app` |
| Namespace | `com.evmoto.driver.app` |
| `targetSdk` | 35 |
| `minSdk` | From Flutter defaults (launcher icons config: 21) |
| Java/Kotlin | 17 |
| Plugins | Google Services, Firebase Crashlytics |
| Signing | Release via `key.properties` keystore |
| Desugaring | Enabled (for `flutter_local_notifications`) |

### iOS (`ios/Runner/Info.plist`)

| Setting | Value |
|---|---|
| Display name | Evmoto Driver |
| Background modes | `remote-notification`, `location` |
| Permissions | Camera, microphone, photo library, location (always + when in use) |
| Firebase proxy | Enabled |

### Versioning

Managed in `pubspec.yaml` (`version: 1.9.4+50`) — propagated to platform builds.

### Launcher icons

`flutter_launcher_icons` → `assets/logos/logo.png`.

### CI/CD

**Assumption:** No CI configuration files (`.github/workflows`, Fastlane, Codemagic) were found in the repository root during this analysis.

---

## 20. Development Standards Summary

Standards inferred from consistent codebase patterns:

1. **Feature-first module structure** — each feature in `lib/app/modules/<snake_case_name>/` with `bindings`, `controllers`, `views`.
2. **get_cli route generation** — `app_routes.dart` auto-generated; routes registered in `app_pages.dart`.
3. **GetX-only state management** — `.obs` + `Obx`; views as `GetView<Controller>`.
4. **Binding-based DI** — `Get.lazyPut` for controllers; repositories constructed in binding factory.
5. **Repository per API domain** — one repository file per backend concern.
6. **Global GetxService** for cross-cutting infrastructure (API, user, socket, location, theme, language).
7. **Reactive theme/typography services** instead of Material Theme extension.
8. **JSON asset i18n** rather than ARB/`flutter gen-l10n`.
9. **Sub-view decomposition** for large screens (`home_view/`, `my_order_view/`).
10. **SnackbarHelper** for user-facing errors/success messages.
11. **Bearer token per repository call** rather than centralized auth interceptor.

---

## 21. Current Architectural Inconsistencies

| Finding | Evidence |
|---|---|
| **Duplicate order history modules** | Both `my_order` and `my_order_v2` registered; home navigates to `MY_ORDER` only |
| **Monolithic controllers** | `HomeController` (~2800+ lines), `OrderDetailController` (~2200+ lines) |
| **Monolithic views** | `HomeView` (~2900+ lines) |
| **Repositories not in DI** | Instantiated with `Repository()` in bindings; `UserServices` creates `UserRepository()` directly |
| **Cross-layer coupling** | `SocketServices` calls `Get.find<HomeController>()` / `OrderDetailController` directly |
| **Dual environment config** | `environment.dart` hardcoded URLs vs Remote Config `driver_base_url` (unused for Dio) |
| **Sendbird incomplete** | Prefix constants + `isSendbirdInit` flag; no SDK dependency |
| **Auth header inconsistency** | Token attached per repository, not via Dio interceptor |
| **Commented-out code** | Retry interceptor, FCM background order handler, language persistence on init |
| **Password login unused** | `loginByMobileNumber` in repository; UI only uses OTP path |
| **Remote Config base URL unused** | API uses `environment.dart`, not `remoteConfig.getString("driver_base_url")` |
| **AccountBinding on home route** | `AccountController` depends on `HomeController` via `Get.find` — ordering/coupling risk |
| **No tests** | Only default `test/widget_test.dart` (counter app template) |

---

## 22. Project Health Assessment

### Strengths

- **Consistent module scaffolding** across all 47 features (bindings/controllers/views).
- **Clear separation** between global services and feature controllers.
- **Repository pattern** centralizes API paths and response parsing.
- **Reactive UI** is uniform (`Obx` only — no mixed state management).
- **Robust session handling** — secure token storage, forced logout on code 600, thorough cleanup on logout.
- **Real-time architecture** — TCP socket + FCM + Firestore chat covers driver operational needs.
- **Existing internal docs** — `docs/architecture.md`, `docs/api-guidelines.md`, `docs/ui-guidelines.md` complement this overview.

### Risks

- **Maintainability** — oversized home/order controllers and views are difficult to test and modify safely.
- **Tight coupling** — socket service directly manipulates feature controllers by route.
- **No automated tests** — regressions likely undetected.
- **Environment switching** requires manual code edits (error-prone for releases).
- **Parallel modules** (`my_order` vs `my_order_v2`) create confusion about canonical implementation.
- **Secrets in repo** — dev server IP hardcoded in `environment.dart`; `.env` for Google key (ensure not committed).
- **Repository reinstantiation** — new instance per binding; no shared caching layer.

---

## 23. Recommended Improvements

Improvements that preserve GetX architecture:

1. **Split `HomeController` and `HomeView`** into focused units (order hall, in-service, guarantee income, socket handler) — either sub-controllers or mixin-based partials.
2. **Consolidate `my_order` and `my_order_v2`** — pick one implementation, deprecate the other, update routes.
3. **Introduce an auth Dio interceptor** to attach Bearer token centrally instead of per-repository duplication.
4. **Decouple socket events from controllers** — use `GetX` streams, `Rx` subjects, or an event bus that controllers subscribe to.
5. **Environment via `--dart-define` or build flavors** — replace manual comment toggling in `environment.dart`.
6. **Register repositories with `Get.lazyPut`** — enables mocking and single instances.
7. **Add unit tests** for `LoginRepository`, `OrderRepository`, session logout, and `ApiServices` interceptor (code 600).
8. **Scope `Obx` widgets narrowly** in large views to reduce rebuild cost.
9. **Socket reconnect backoff** — replace fixed 3-second `Timer.periodic` with exponential backoff.
10. **Clean up commented code** (retry interceptor, FCM handlers, Sendbird stubs) or document intent.
11. **Align Remote Config** — either wire `driver_base_url` to Dio or remove unused config keys.
12. **Extract shared order-list widgets** between `my_order` and `my_order_v2` if both must coexist temporarily.

---

## Key File References

| Concern | File |
|---|---|
| Entry point | `lib/main.dart` |
| Environment | `lib/environment.dart` |
| Routes | `lib/app/routes/app_pages.dart`, `lib/app/routes/app_routes.dart` |
| API client | `lib/app/services/api_services.dart` |
| Auth token check | `lib/app/modules/splash_screen/controllers/splash_screen_controller.dart` |
| Login | `lib/app/repositories/login_repository.dart` |
| Home shell | `lib/app/modules/home/views/home_view.dart` |
| Socket | `lib/app/services/socket_services.dart` |
| Dependencies | `pubspec.yaml` |

---

*Document generated from codebase analysis. For API conventions see `docs/api-guidelines.md`; for structural deep-dive see `docs/architecture.md`.*
