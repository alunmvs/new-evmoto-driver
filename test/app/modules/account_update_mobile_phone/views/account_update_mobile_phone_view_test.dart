import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/modules/account_update_mobile_phone/controllers/account_update_mobile_phone_controller.dart';
import 'package:new_evmoto_driver/app/modules/account_update_mobile_phone/views/account_update_mobile_phone_view.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class TestableHomeController extends HomeController {
  TestableHomeController({
    required super.vehicleRepository,
    required super.orderRepository,
    required super.userRepository,
    required super.accountRepository,
    required super.versioningServerRepository,
    required super.guaranteeIncomeRepository,
    required super.advanceBookingRepository,
  });

  @override
  // ignore: must_call_super
  Future<void> onInit() async {
    isFetch.value = false;
  }
}

HomeController registerTestableHomeController({
  required UserRepository userRepository,
}) {
  registerHomeControllerDependencies();
  if (!Get.isRegistered<UserServices>()) {
    registerMockUserServices();
  }
  final homeController = TestableHomeController(
    vehicleRepository: MockVehicleRepository(),
    orderRepository: MockOrderRepository(),
    userRepository: userRepository,
    accountRepository: MockAccountRepository(),
    versioningServerRepository: MockVersioningServerRepository(),
    guaranteeIncomeRepository: MockGuaranteeIncomeRepository(),
    advanceBookingRepository: MockAdvanceBookingRepository(),
  );
  Get.put<HomeController>(homeController);
  return homeController;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountUpdateMobilePhoneView', () {
    late AccountUpdateMobilePhoneController controller;
    late MockAccountRepository mockAccountRepository;
    late MockUserRepository mockUserRepository;

    Future<void> waitForUserInfoFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const AccountUpdateMobilePhoneView());
      await tester.pump();
    }

    void stubGetUserInfoDetail({String phone = '628123456789'}) {
      when(
        () => mockUserRepository.getUserInfoDetail(
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => UserInfo(phone: phone));
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(
          changeMobileNumber: 'Change Mobile Number',
          enterOldMobileNumber: 'Enter Old Mobile Number',
          enterNewMobileNumber: 'Enter New Mobile Number',
          sendOtpCode: 'Send OTP Code',
          otpWillSentNewMobileNumber: 'OTP will be sent to your new number',
          formValidationRequired: 'This field is required',
          formValidationLengthMin8: 'Minimum 8 digits',
          formValidationMobileMaxLength: 'Maximum 15 digits',
          formValidationFirst8: 'Must start with 8',
        ),
      );
      mockAccountRepository = MockAccountRepository();
      mockUserRepository = MockUserRepository();
      stubGetUserInfoDetail();
      registerTestableHomeController(userRepository: mockUserRepository);
      controller = AccountUpdateMobilePhoneController(
        accountRepository: mockAccountRepository,
      );
      Get.put<AccountUpdateMobilePhoneController>(controller);
      await controller.onInit();
      await waitForUserInfoFetch();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders update mobile phone screen content', (tester) async {
      await pumpView(tester);

      expect(find.text('Change Mobile Number'), findsOneWidget);
      expect(find.text('Enter Old Mobile Number'), findsOneWidget);
      expect(find.text('Enter New Mobile Number'), findsOneWidget);
      expect(find.text('Send OTP Code'), findsOneWidget);
      expect(
        find.text('OTP will be sent to your new number'),
        findsOneWidget,
      );
      expect(find.text('+62'), findsNWidgets(2));
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('shows loading indicator while fetching user info', (
      tester,
    ) async {
      final userInfoRequest = Completer<UserInfo>();
      when(
        () => mockUserRepository.getUserInfoDetail(
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) => userInfoRequest.future);

      Get.delete<AccountUpdateMobilePhoneController>();
      final loadingController = AccountUpdateMobilePhoneController(
        accountRepository: mockAccountRepository,
      );
      Get.put<AccountUpdateMobilePhoneController>(loadingController);

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Enter Old Mobile Number'), findsNothing);

      userInfoRequest.complete(UserInfo(phone: '628123456789'));
      for (var i = 0; i < 20 && loadingController.isFetch.value; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Enter Old Mobile Number'), findsOneWidget);
    });

    testWidgets('old mobile phone field is read-only and prefilled', (
      tester,
    ) async {
      await pumpView(tester);

      final textFields = find.byType(TextField);
      final oldPhoneField = tester.widget<TextField>(textFields.first);
      expect(oldPhoneField.readOnly, isTrue);
      expect(
        controller.formGroup.control('old_mobile_phone').value,
        '8123456789',
      );
    });

    testWidgets('shows validation error when new phone is invalid', (
      tester,
    ) async {
      controller.formGroup.control('new_mobile_phone').value = '7123456789';
      controller.formGroup.control('new_mobile_phone').markAsTouched();

      await pumpView(tester);
      await tester.pump();

      expect(find.text('Must start with 8'), findsOneWidget);
    });

    testWidgets('allows entering valid new mobile phone number', (
      tester,
    ) async {
      await pumpView(tester);

      await tester.enterText(find.byType(TextField).last, '8987654321');
      await tester.pump();

      expect(
        controller.formGroup.control('new_mobile_phone').value,
        '8987654321',
      );
      expect(controller.formGroup.valid, isTrue);
    });
  });
}
