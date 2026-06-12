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
| **Test run time** | ~9 seconds |
| **Total checks** | 16 |
| **Passed** | 16 |
| **Failed** | 0 |
| **Overall result** | ✅ All checks passed |

---

## What Was Tested?

Automated tests simulate how a driver interacts with the app — typing a phone number, tapping buttons — and confirm that the app behaves as expected. No real phone calls, SMS, or server requests are made during these tests; they run on a simulated device.

The checks focus on the **login** flow — the first step a driver sees when opening the app.

---

## 1. Login Screen — Behind the Scenes (Unit Tests)

*File: `login_controller_test.dart`*  
*9 checks — all passed*

These tests verify the rules and logic that power the login screen, without showing the full visual layout.

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

---

## 2. Login Screen — What the User Sees (Widget Tests)

*File: `login_view_test.dart`*  
*6 checks — all passed*

These tests open the actual login screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen shows the title “Login Driver Evmoto”, description, phone label, country code (+62), and Continue button | ✅ Pass |
| 2 | Continue button is disabled when the phone field is empty | ✅ Pass |
| 3 | Continue button becomes active when a valid phone number is entered | ✅ Pass |
| 4 | Error message appears when the number does not start with 8 | ✅ Pass |
| 5 | Error message appears when the number has fewer than 8 digits | ✅ Pass |
| 6 | Tapping Continue with a valid number opens the OTP verification screen with the correct phone number | ✅ Pass |

---

## 3. General App Health Check (Smoke Test)

*File: `widget_test.dart`*  
*1 check — passed*

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | The basic app shell can start and display content without errors | ✅ Pass |

---

## Areas Not Covered by This Report

These automated checks **do not** currently test:

- OTP verification screen (login step after phone number)
- Driver registration and onboarding
- Home screen, accepting orders, or GPS tracking
- Withdrawal, balance history, or guarantee income
- Vehicle switching and vehicle management
- Chat, notifications, or account settings
- Real SMS delivery or live server responses
- Performance on physical devices (iOS / Android hardware)

Those areas would need separate manual testing or additional automated tests in the future.

---

## How to Re-run These Tests

From the project folder, run:

```bash
flutter test test/ --reporter expanded
```

Expected outcome: `All tests passed!` in roughly 9–12 seconds.

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
| **Source test files** | 3 files under `test/` |

---

*This report reflects the state of automated tests at the time of generation. Re-run tests after any code change to get an up-to-date result.*
