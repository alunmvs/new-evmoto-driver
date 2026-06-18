import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/modules/withdraw_amount/controllers/withdraw_amount_controller.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import '../../../../helpers/module_test_helpers.dart';
import '../withdraw_amount_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WithdrawAmountController', () {
    late WithdrawAmountController controller;
    late MockWithdrawRepository mockWithdrawRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerWithdrawAmountDependencies(withdrawMin: 50000);
      mockWithdrawRepository = MockWithdrawRepository();
      stubGetAdminFee(mockWithdrawRepository);
      controller = WithdrawAmountController(
        withdrawRepository: mockWithdrawRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with default state',
      () {
        expect(controller.isInfoExpanded.value, isFalse);
        expect(controller.isFetch.value, isFalse);
        expect(controller.canRequestFocus.value, isTrue);
        expect(controller.adminFee.value, 0);
        expect(controller.selectedBankAccount.value.id, isNull);
        expect(controller.formGroup.valid, isFalse);
        expect(controller.formGroup.control('money').value, isNull);
      },
    );

    test(
      'getAdminFee should fetch admin fee from repository',
      () async {
        controller.selectedBankAccount.value = sampleBankAccount();

        await controller.getAdminFee();

        expect(controller.adminFee.value, 2500);
        verify(
          () => mockWithdrawRepository.getAdminFeeByBankCode(bankCode: '014'),
        ).called(1);
      },
    );

    test(
      'onInit should read selected bank account from arguments and fetch admin fee',
      () async {
        Get.testMode = true;
        Get.routing.args = {'selected_bank_account': sampleBankAccount()};

        await controller.onInit();

        expect(controller.selectedBankAccount.value.name, 'John Doe');
        expect(controller.selectedBankAccount.value.bankCode, '014');
        expect(controller.adminFee.value, 2500);
        expect(controller.isFetch.value, isFalse);
        verify(
          () => mockWithdrawRepository.getAdminFeeByBankCode(bankCode: '014'),
        ).called(1);
      },
    );

    test(
      'onInit should throw when bank account has no bank code',
      () async {
        Get.testMode = true;
        Get.routing.args = <String, dynamic>{};

        await expectLater(controller.onInit(), throwsA(isA<TypeError>()));
      },
    );

    test(
      'onTapSubmit should not open bottom sheet when form is invalid',
      () async {
        await controller.onTapSubmit();

        verifyNever(
          () => mockWithdrawRepository.requestWithdrawal(
            bankName: any(named: 'bankName'),
            code: any(named: 'code'),
            language: any(named: 'language'),
            money: any(named: 'money'),
            name: any(named: 'name'),
          ),
        );
        expect(controller.formGroup.control('money').touched, isTrue);
      },
    );

    test(
      'onTapSubmit should reject amount below minimum withdrawal',
      () async {
        controller.selectedBankAccount.value = sampleBankAccount();
        fillValidWithdrawForm(controller, amount: '10000');

        await controller.onTapSubmit();

        verifyNever(
          () => mockWithdrawRepository.requestWithdrawal(
            bankName: any(named: 'bankName'),
            code: any(named: 'code'),
            language: any(named: 'language'),
            money: any(named: 'money'),
            name: any(named: 'name'),
          ),
        );
      },
    );

    testWidgets(
      'onTapSubmit should open confirmation bottom sheet when form is valid',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(home: const Scaffold(body: SizedBox())),
        );
        controller.selectedBankAccount.value = sampleBankAccount();
        fillValidWithdrawForm(controller, amount: '100.000');

        final submitFuture = controller.onTapSubmit();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Konfirmasi Penarikan Dana'), findsOneWidget);
        expect(find.text('Konfirmasi'), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);

        Get.back();
        await submitFuture;
      },
    );

    testWidgets(
      'onTapSubmit should request withdrawal and navigate on confirmation',
      (WidgetTester tester) async {
        stubRequestWithdrawal(mockWithdrawRepository);

        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const Scaffold(body: SizedBox())),
              GetPage(
                name: Routes.HISTORY_BALANCE_WITHDRAW,
                page: () => const Scaffold(body: Text('Withdraw History')),
              ),
            ],
          ),
        );

        controller.selectedBankAccount.value = sampleBankAccount();
        fillValidWithdrawForm(controller, amount: '100000');

        final submitFuture = controller.onTapSubmit();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final confirmButton = tester.widget<LoaderElevatedButton>(
          find.byType(LoaderElevatedButton),
        );
        await confirmButton.onPressed!.call();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await submitFuture;

        verify(
          () => mockWithdrawRepository.requestWithdrawal(
            bankName: 'BCA',
            code: '1234567890',
            language: 2,
            money: 100000,
            name: 'John Doe',
          ),
        ).called(1);
        expect(Get.currentRoute, Routes.HISTORY_BALANCE_WITHDRAW);
      },
    );

    testWidgets(
      'onTapSubmit should not throw when withdrawal request fails',
      (WidgetTester tester) async {
        when(
          () => mockWithdrawRepository.requestWithdrawal(
            bankName: any(named: 'bankName'),
            code: any(named: 'code'),
            language: any(named: 'language'),
            money: any(named: 'money'),
            name: any(named: 'name'),
          ),
        ).thenThrow(Exception('Withdrawal failed'));

        await tester.pumpWidget(
          GetMaterialApp(home: const Scaffold(body: SizedBox())),
        );
        controller.selectedBankAccount.value = sampleBankAccount();
        fillValidWithdrawForm(controller, amount: '100000');

        final submitFuture = controller.onTapSubmit();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final confirmButton = tester.widget<LoaderElevatedButton>(
          find.byType(LoaderElevatedButton),
        );
        await expectLater(confirmButton.onPressed!.call(), completes);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await submitFuture;
      },
    );

    test(
      'isInfoExpanded should toggle when value changes',
      () {
        expect(controller.isInfoExpanded.value, isFalse);

        controller.isInfoExpanded.value = true;
        expect(controller.isInfoExpanded.value, isTrue);

        controller.isInfoExpanded.value = false;
        expect(controller.isInfoExpanded.value, isFalse);
      },
    );

    test(
      'should clean up controller without error when onClose is called',
      () {
        expect(() => controller.onClose(), returnsNormally);
      },
    );
  });
}
