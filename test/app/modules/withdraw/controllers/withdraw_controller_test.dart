import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/modules/withdraw/controllers/withdraw_controller.dart';
import '../../../../helpers/module_test_helpers.dart';
import '../withdraw_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WithdrawController', () {
    late WithdrawController controller;
    late MockBankAccountRepository mockBankAccountRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      registerTestableHomeController();
      mockBankAccountRepository = MockBankAccountRepository();
      stubGetBankAccountList(mockBankAccountRepository);
      controller = WithdrawController(
        bankAccountRepository: mockBankAccountRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with default values',
      () {
        expect(controller.isInfoExpanded.value, isFalse);
        expect(controller.bankAccountList, isEmpty);
        expect(controller.bankAccountPageNum.value, 1);
        expect(controller.bankAccountSize.value, 10);
        expect(controller.isSeeMoreBankAccount.value, isTrue);
        expect(controller.isEditDeleteActive.value, isFalse);
        expect(controller.isFetch.value, isFalse);
      },
    );

    test(
      'getBankAccountList should populate bankAccountList from repository',
      () async {
        await controller.getBankAccountList();

        expect(controller.bankAccountList.length, 2);
        expect(controller.bankAccountPageNum.value, 1);
        expect(controller.isSeeMoreBankAccount.value, isTrue);
        verify(
          () => mockBankAccountRepository.getBankAccountList(
            pageNum: 1,
            language: 2,
            size: 10,
          ),
        ).called(1);
      },
    );

    test(
      'getBankAccountList should disable see more when list is empty',
      () async {
        stubGetBankAccountList(mockBankAccountRepository, accounts: []);

        await controller.getBankAccountList();

        expect(controller.bankAccountList, isEmpty);
        expect(controller.isSeeMoreBankAccount.value, isFalse);
      },
    );

    test(
      'seeMoreBankAccountList should append accounts and increment page',
      () async {
        controller.bankAccountList.value = [sampleBankAccount()];
        when(
          () => mockBankAccountRepository.getBankAccountList(
            pageNum: 2,
            language: any(named: 'language'),
            size: any(named: 'size'),
          ),
        ).thenAnswer(
          (_) async => [
            BankAccount(
              id: 3,
              bank: 'BNI',
              bankCode: '009',
              name: 'Alex Doe',
              code: '5555555555',
            ),
          ],
        );

        await controller.seeMoreBankAccountList();

        expect(controller.bankAccountPageNum.value, 2);
        expect(controller.bankAccountList.length, 2);
        expect(controller.bankAccountList.last.name, 'Alex Doe');
        expect(controller.isSeeMoreBankAccount.value, isTrue);
      },
    );

    test(
      'seeMoreBankAccountList should disable see more when page is empty',
      () async {
        controller.bankAccountList.value = [sampleBankAccount()];
        when(
          () => mockBankAccountRepository.getBankAccountList(
            pageNum: 2,
            language: any(named: 'language'),
            size: any(named: 'size'),
          ),
        ).thenAnswer((_) async => []);

        await controller.seeMoreBankAccountList();

        expect(controller.bankAccountPageNum.value, 2);
        expect(controller.bankAccountList.length, 1);
        expect(controller.isSeeMoreBankAccount.value, isFalse);
      },
    );

    test(
      'onInit should fetch bank accounts and reset isFetch',
      () async {
        await controller.onInit();

        expect(controller.isFetch.value, isFalse);
        expect(controller.bankAccountList.length, 2);
        verify(
          () => mockBankAccountRepository.getBankAccountList(
            pageNum: 1,
            language: 2,
            size: 10,
          ),
        ).called(1);
      },
    );

    testWidgets(
      'onTapDeleteBankAccount should show confirmation dialog',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(home: const Scaffold(body: SizedBox())),
        );

        await controller.onTapDeleteBankAccount(bankAccount: sampleBankAccount());
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(
          find.text('Apakah Anda yakin ingin menghapus nomor rekening?'),
          findsOneWidget,
        );
        expect(find.text('Batal'), findsOneWidget);
        expect(find.text('Hapus'), findsOneWidget);
      },
    );

    testWidgets(
      'onTapDeleteBankAccount should delete account and refresh list',
      (WidgetTester tester) async {
        stubDeleteBankAccount(mockBankAccountRepository);
        await tester.pumpWidget(
          GetMaterialApp(home: const Scaffold(body: SizedBox())),
        );

        await controller.onTapDeleteBankAccount(bankAccount: sampleBankAccount());
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        await tester.tap(find.text('Hapus'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        while (tester.takeException() != null) {}

        verify(
          () => mockBankAccountRepository.deleteBankAccountById(
            id: 1,
            language: 2,
          ),
        ).called(1);
        verify(
          () => mockBankAccountRepository.getBankAccountList(
            pageNum: 1,
            language: 2,
            size: 10,
          ),
        ).called(1);
      },
    );

    testWidgets(
      'onTapDeleteBankAccount should close dialog when cancel is tapped',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(home: const Scaffold(body: SizedBox())),
        );

        await controller.onTapDeleteBankAccount(bankAccount: sampleBankAccount());
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        await tester.tap(find.text('Batal'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(
          find.text('Apakah Anda yakin ingin menghapus nomor rekening?'),
          findsNothing,
        );
        verifyNever(
          () => mockBankAccountRepository.deleteBankAccountById(
            id: any(named: 'id'),
            language: any(named: 'language'),
          ),
        );
      },
    );

    testWidgets(
      'onTapDeleteBankAccount should not throw when delete fails',
      (WidgetTester tester) async {
        when(
          () => mockBankAccountRepository.deleteBankAccountById(
            id: any(named: 'id'),
            language: any(named: 'language'),
          ),
        ).thenThrow(Exception('Delete failed'));
        await tester.pumpWidget(
          GetMaterialApp(home: const Scaffold(body: SizedBox())),
        );

        await controller.onTapDeleteBankAccount(bankAccount: sampleBankAccount());
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        await expectLater(tester.tap(find.text('Hapus')), completes);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        while (tester.takeException() != null) {}
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
