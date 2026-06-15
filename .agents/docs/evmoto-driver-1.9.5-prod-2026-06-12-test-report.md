# Evmoto Driver — Automated Test Report

> A simple summary of automated checks run on the app. Written for product owners, QA, and anyone who wants to know *what was tested* without reading code.

---

## At a Glance

| Item | Detail |
|------|--------|
| **App name** | Evmoto Driver |
| **App version** | 1.9.5 |
| **Environment** | Production (`prod`) |
| **Test date** | 12 June 2026 |
| **Test run time** | ~62 seconds |
| **Total checks defined** | 111 |
| **Executed** | 53 |
| **Passed** | 53 |
| **Failed** | 0 |
| **Skipped (pending setup)** | 58 |
| **Overall result** | ✅ All executed checks passed |

---

## What Was Tested?

Automated tests simulate how a driver interacts with the app — typing a phone number, tapping buttons, opening screens — and confirm that the app behaves as expected. No real phone calls, SMS, or live server requests are made during these tests; they run on a simulated device with mocked dependencies.

This run covers **48 feature areas** across authentication, orders, balance/withdrawals, account settings, chat, and notifications. **53 checks ran and passed**; **58 checks are defined but temporarily skipped** because they need heavier integration setup (maps, webviews, or full runtime services).

---

## 1. Authentication & Onboarding

### Login — Behind the Scenes (Unit Tests)

*File: `login_controller_test.dart`*  
*9 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | When the screen first opens, the phone field is empty and the Continue button stays inactive | ✅ Pass |
| 2 | A valid Indonesian mobile number (starts with 8, 8–15 digits) is accepted | ✅ Pass |
| 3 | An empty phone number keeps the Continue button inactive | ✅ Pass |
| 4 | A number that does **not** start with 8 is rejected | ✅ Pass |
| 5 | A number shorter than 8 digits is rejected | ✅ Pass |
| 6 | A number longer than 15 digits is rejected | ✅ Pass |
| 7 | The form updates automatically as the user types | ✅ Pass |
| 8 | Tapping Continue with a valid number (e.g. `8123456789`) sends the driver to the OTP screen with the correct full number (`628123456789`) | ✅ Pass |
| 9 | Closing the screen cleans up properly with no errors | ✅ Pass |

### Login — What the User Sees (Widget Tests)

*File: `login_view_test.dart`*  
*6 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen shows the title "Login Driver Evmoto", description, phone label, country code (+62), and Continue button | ✅ Pass |
| 2 | Continue button is disabled when the phone field is empty | ✅ Pass |
| 3 | Continue button becomes active when a valid phone number is entered | ✅ Pass |
| 4 | Error message appears when the number does not start with 8 | ✅ Pass |
| 5 | Error message appears when the number has fewer than 8 digits | ✅ Pass |
| 6 | Tapping Continue with a valid number opens the OTP verification screen with the correct phone number | ✅ Pass |

### Login OTP Verification — Behind the Scenes (Unit Tests)

*File: `login_verification_otp_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Login OTP Verification — What the User Sees (Widget Tests)

*File: `login_verification_otp_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Login Verification Otp screen | ⏭️ Skipped |

</details>

### Register — Behind the Scenes (Unit Tests)

*File: `register_controller_test.dart`*  
*2 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Form starts empty and invalid | ✅ Pass |
| 2 | Form becomes valid when a correct phone number is entered | ✅ Pass |

### Register — What the User Sees (Widget Tests)

*File: `register_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Registration form renders correctly | ✅ Pass |

### Register Form — Behind the Scenes (Unit Tests)

*File: `register_form_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Register Form — What the User Sees (Widget Tests)

*File: `register_form_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Register Form screen | ⏭️ Skipped |

</details>

### Register Completed — Behind the Scenes (Unit Tests)

*File: `register_form_completed_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Tapping submit navigates to the login screen | ✅ Pass |

### Register Completed — What the User Sees (Widget Tests)

*File: `register_form_completed_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Registration completion screen renders correctly | ✅ Pass |

### Register OTP Verification — Behind the Scenes (Unit Tests)

*File: `register_verification_otp_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Register OTP Verification — What the User Sees (Widget Tests)

*File: `register_verification_otp_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Register Verification Otp screen | ⏭️ Skipped |

</details>

### Splash Screen — Behind the Scenes (Unit Tests)

*File: `splash_screen_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Splash Screen — What the User Sees (Widget Tests)

*File: `splash_screen_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Splash screen renders without errors | ✅ Pass |

## 2. Home & Orders

### Home — Behind the Scenes (Unit Tests)

*File: `home_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Home — What the User Sees (Widget Tests)

*File: `home_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders home screen | ⏭️ Skipped |

</details>

### My Orders — Behind the Scenes (Unit Tests)

*File: `my_order_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### My Orders — What the User Sees (Widget Tests)

*File: `my_order_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  My Order screen | ⏭️ Skipped |

</details>

### My Orders V2 — Behind the Scenes (Unit Tests)

*File: `my_order_v2_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### My Orders V2 — What the User Sees (Widget Tests)

*File: `my_order_v2_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  My Order V2 screen | ⏭️ Skipped |

</details>

### My Activity — Behind the Scenes (Unit Tests)

*File: `my_activity_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### My Activity — What the User Sees (Widget Tests)

*File: `my_activity_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  My Activity screen | ⏭️ Skipped |

</details>

### Order Detail — Behind the Scenes (Unit Tests)

*File: `order_detail_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Order Detail — What the User Sees (Widget Tests)

*File: `order_detail_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Order Detail screen | ⏭️ Skipped |

</details>

### Order Payment Confirmation — Behind the Scenes (Unit Tests)

*File: `order_payment_confirmation_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Order Payment Confirmation — What the User Sees (Widget Tests)

*File: `order_payment_confirmation_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Order Payment Confirmation screen | ⏭️ Skipped |

</details>

### Order Payment Detail — Behind the Scenes (Unit Tests)

*File: `order_payment_detail_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Order Payment Detail — What the User Sees (Widget Tests)

*File: `order_payment_detail_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Order Payment Detail screen | ⏭️ Skipped |

</details>

### Order Payment Pending — Behind the Scenes (Unit Tests)

*File: `order_payment_pending_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Order Payment Pending — What the User Sees (Widget Tests)

*File: `order_payment_pending_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Order Payment Pending screen | ⏭️ Skipped |

</details>

### Pending Fee Detail — Behind the Scenes (Unit Tests)

*File: `order_payment_pending_fee_detail_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Pending Fee Detail — What the User Sees (Widget Tests)

*File: `order_payment_pending_fee_detail_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Order Payment Pending Fee Detail screen | ⏭️ Skipped |

</details>

## 3. Balance & Withdrawals

### Deposit Balance — Behind the Scenes (Unit Tests)

*File: `deposit_balance_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Deposit Balance — What the User Sees (Widget Tests)

*File: `deposit_balance_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Deposit Balance screen | ⏭️ Skipped |

</details>

### Deposit Payment Webview — Behind the Scenes (Unit Tests)

*File: `deposit_balance_payment_webview_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Deposit Payment Webview — What the User Sees (Widget Tests)

*File: `deposit_balance_payment_webview_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Deposit Balance Payment Webview screen | ⏭️ Skipped |

</details>

### Balance History (All) — Behind the Scenes (Unit Tests)

*File: `history_balance_all_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Balance History (All) — What the User Sees (Widget Tests)

*File: `history_balance_all_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  History Balance All screen | ⏭️ Skipped |

</details>

### Balance Recharge History — Behind the Scenes (Unit Tests)

*File: `history_balance_recharge_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts in a ready (not loading) state | ✅ Pass |

### Balance Recharge History — What the User Sees (Widget Tests)

*File: `history_balance_recharge_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen layout renders without errors | ✅ Pass |

### Balance Revenue History — Behind the Scenes (Unit Tests)

*File: `history_balance_revenue_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Balance Revenue History — What the User Sees (Widget Tests)

*File: `history_balance_revenue_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  History Balance Revenue screen | ⏭️ Skipped |

</details>

### Balance Withdraw History — Behind the Scenes (Unit Tests)

*File: `history_balance_withdraw_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts in a ready (not loading) state | ✅ Pass |

### Balance Withdraw History — What the User Sees (Widget Tests)

*File: `history_balance_withdraw_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen layout renders without errors | ✅ Pass |

### Guarantee Income History — Behind the Scenes (Unit Tests)

*File: `history_guarantee_income_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Guarantee Income History — What the User Sees (Widget Tests)

*File: `history_guarantee_income_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  History Guarantee Income screen | ⏭️ Skipped |

</details>

### Withdraw — Behind the Scenes (Unit Tests)

*File: `withdraw_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Withdraw — What the User Sees (Widget Tests)

*File: `withdraw_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Withdraw screen | ⏭️ Skipped |

</details>

### Withdraw Amount — Behind the Scenes (Unit Tests)

*File: `withdraw_amount_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Withdraw Amount — What the User Sees (Widget Tests)

*File: `withdraw_amount_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Withdraw Amount screen | ⏭️ Skipped |

</details>

### Withdraw Detail — Behind the Scenes (Unit Tests)

*File: `withdraw_detail_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Withdrawal details load correctly from navigation data | ✅ Pass |

### Withdraw Detail — What the User Sees (Widget Tests)

*File: `withdraw_detail_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Withdraw Detail screen | ⏭️ Skipped |

</details>

### Add/Edit Bank Account — Behind the Scenes (Unit Tests)

*File: `add_edit_withdraw_bank_account_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Add/Edit Bank Account — What the User Sees (Widget Tests)

*File: `add_edit_withdraw_bank_account_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Add Edit Withdraw Bank Account screen | ⏭️ Skipped |

</details>

### Coupon Income Agreement — Behind the Scenes (Unit Tests)

*File: `agreement_coupon_income_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Agreement content is loaded when the screen opens | ✅ Pass |

### Coupon Income Agreement — What the User Sees (Widget Tests)

*File: `agreement_coupon_income_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen shows the agreement title bar correctly | ✅ Pass |

### Guarantee Income Agreement — Behind the Scenes (Unit Tests)

*File: `agreement_guarantee_income_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Agreement content is loaded when the screen opens | ✅ Pass |

### Guarantee Income Agreement — What the User Sees (Widget Tests)

*File: `agreement_guarantee_income_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen shows the agreement title bar correctly | ✅ Pass |

## 4. Account & Settings

### Account — Behind the Scenes (Unit Tests)

*File: `account_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Account — What the User Sees (Widget Tests)

*File: `account_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Account screen | ⏭️ Skipped |

</details>

### About Us — Behind the Scenes (Unit Tests)

*File: `account_about_us_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Agreement content is loaded when the screen opens | ✅ Pass |

### About Us — What the User Sees (Widget Tests)

*File: `account_about_us_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen shows the agreement title bar correctly | ✅ Pass |

### Account Feedback — Behind the Scenes (Unit Tests)

*File: `account_feedback_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Account Feedback — What the User Sees (Widget Tests)

*File: `account_feedback_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Feedback screen layout renders correctly | ✅ Pass |

### Language Settings — Behind the Scenes (Unit Tests)

*File: `account_language_controller_test.dart`*  
*2 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Current language is read from app settings on open | ✅ Pass |
| 2 | Selected language updates when user picks a new option | ✅ Pass |

### Language Settings — What the User Sees (Widget Tests)

*File: `account_language_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Language selection options are displayed | ✅ Pass |

### Legal Terms & Platform Rules — Behind the Scenes (Unit Tests)

*File: `account_legal_terms_and_platform_rules_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Agreement content is loaded when the screen opens | ✅ Pass |

### Legal Terms & Platform Rules — What the User Sees (Widget Tests)

*File: `account_legal_terms_and_platform_rules_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen shows the agreement title bar correctly | ✅ Pass |

### My Evaluation — Behind the Scenes (Unit Tests)

*File: `account_my_evaluation_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### My Evaluation — What the User Sees (Widget Tests)

*File: `account_my_evaluation_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Account My Evaluation screen | ⏭️ Skipped |

</details>

### Other Settings — Behind the Scenes (Unit Tests)

*File: `account_other_setting_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Other Settings — What the User Sees (Widget Tests)

*File: `account_other_setting_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Account Other Setting screen | ⏭️ Skipped |

</details>

### Account Service — Behind the Scenes (Unit Tests)

*File: `account_service_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts in a ready (not loading) state | ✅ Pass |

### Account Service — What the User Sees (Widget Tests)

*File: `account_service_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen layout renders without errors | ✅ Pass |

### Update Mobile Phone — Behind the Scenes (Unit Tests)

*File: `account_update_mobile_phone_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Update Mobile Phone — What the User Sees (Widget Tests)

*File: `account_update_mobile_phone_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Account Update Mobile Phone screen | ⏭️ Skipped |

</details>

### Update Phone OTP — Behind the Scenes (Unit Tests)

*File: `account_update_mobile_phone_verification_otp_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Update Phone OTP — What the User Sees (Widget Tests)

*File: `account_update_mobile_phone_verification_otp_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Account Update Mobile Phone Verification Otp screen | ⏭️ Skipped |

</details>

### User Guide — Behind the Scenes (Unit Tests)

*File: `account_user_guide_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Agreement content is loaded when the screen opens | ✅ Pass |

### User Guide — What the User Sees (Widget Tests)

*File: `account_user_guide_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen shows the agreement title bar correctly | ✅ Pass |

### Switch Vehicle — Behind the Scenes (Unit Tests)

*File: `switch_vehicle_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Vehicle details load when the screen opens | ✅ Pass |

### Switch Vehicle — What the User Sees (Widget Tests)

*File: `switch_vehicle_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Vehicle switch screen renders without errors | ✅ Pass |

### Terms & Conditions — Behind the Scenes (Unit Tests)

*File: `terms_and_conditions_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Agreement content is loaded when the screen opens | ✅ Pass |

### Terms & Conditions — What the User Sees (Widget Tests)

*File: `terms_and_conditions_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen shows the agreement title bar correctly | ✅ Pass |

### Privacy Policy — Behind the Scenes (Unit Tests)

*File: `privacy_policy_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Agreement content is loaded when the screen opens | ✅ Pass |

### Privacy Policy — What the User Sees (Widget Tests)

*File: `privacy_policy_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders scaffold with app bar | ⏭️ Skipped |

</details>

## 5. Communication

### Chat List — Behind the Scenes (Unit Tests)

*File: `chat_list_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Chat List — What the User Sees (Widget Tests)

*File: `chat_list_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Chat List screen | ⏭️ Skipped |

</details>

### Chat Detail — Behind the Scenes (Unit Tests)

*File: `chat_detail_controller_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Controller can be created without errors | ⏭️ Skipped |

</details>

### Chat Detail — What the User Sees (Widget Tests)

*File: `chat_detail_view_test.dart`*  
*1 checks — all skipped (pending setup)*

<details>
<summary>1 check(s) skipped — pending integration setup</summary>

| # | Planned check | Status |
|---|---------------|--------|
| 1 | Renders  Chat Detail screen | ⏭️ Skipped |

</details>

### Notifications — Behind the Scenes (Unit Tests)

*File: `notification_controller_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts in a ready (not loading) state | ✅ Pass |

### Notifications — What the User Sees (Widget Tests)

*File: `notification_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen layout renders without errors | ✅ Pass |

## 6. Utilities

### Photo Viewer — Behind the Scenes (Unit Tests)

*File: `photo_viewer_controller_test.dart`*  
*2 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Photo URL is read from navigation arguments | ✅ Pass |
| 2 | Photo URL defaults safely when no image is provided | ✅ Pass |

### Photo Viewer — What the User Sees (Widget Tests)

*File: `photo_viewer_view_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Photo viewer screen renders without errors | ✅ Pass |

### General App Health — General App Health Check (Smoke Test)

*File: `widget_test.dart`*  
*1 checks — all passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | The basic app shell can start and display content without errors | ✅ Pass |

---

## Areas Not Covered by This Report

These automated checks **do not** currently test (or only have placeholder/skipped tests for):

- Full end-to-end order acceptance flow with live GPS tracking
- Real SMS/OTP delivery and live API responses
- Google Maps, InAppWebView, and other native plugins in widget tests
- Home screen runtime (location, socket, background services) — tests exist but are skipped
- Order detail, payment flows, and complex multi-step forms — tests exist but are skipped
- Performance on physical devices (iOS / Android hardware)
- Push notifications on real devices

Those areas would need separate manual testing or integration tests in the future.

---

## How to Re-run These Tests

From the project folder, run:

```bash
flutter test test/ --reporter expanded
```

Expected outcome: `All tests passed!` in roughly 60–90 seconds.

Tests also run automatically before release builds via the Makefile:

```bash
make build-appbundle
make clean-cache-ios
```

---

## Document Info

| Field | Value |
|-------|-------|
| **Generated** | 12 June 2026 |
| **App version** | 1.9.5 |
| **Environment** | prod (Production) |
| **Test framework** | Flutter Test |
| **Source test files** | 95 files under `test/` |

---

*This report reflects the state of automated tests at the time of generation. Re-run tests after any code change to get an up-to-date result.*
