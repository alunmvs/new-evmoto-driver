import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/data/models/bank_model.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/add_edit_withdraw_bank_account/controllers/add_edit_withdraw_bank_account_controller.dart';
import 'package:new_evmoto_driver/app/modules/add_edit_withdraw_bank_account/views/add_edit_withdraw_bank_account_view.dart';
import 'package:new_evmoto_driver/app/repositories/bank_account_repository.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockBankAccountRepository extends Mock implements BankAccountRepository {}

List<Bank> sampleBankList() => [
  Bank(code: '014', name: 'BCA'),
  Bank(code: '008', name: 'Mandiri'),
];

BankAccount sampleBankAccount() => BankAccount(
  id: 1,
  bank: 'BCA',
  bankCode: '014',
  name: 'John Doe',
  code: '1234567890',
);

void stubGetBankList(MockBankAccountRepository mockBankAccountRepository) {
  when(
    () => mockBankAccountRepository.getBankList(
      language: any(named: 'language'),
    ),
  ).thenAnswer((_) async => sampleBankList());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddEditWithdrawBankAccountView', () {
    late AddEditWithdrawBankAccountController controller;
    late MockBankAccountRepository mockBankAccountRepository;

    Future<void> waitForBankAccountFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const AddEditWithdrawBankAccountView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(formValidationRequired: 'Wajib diisi'),
      );
      mockBankAccountRepository = MockBankAccountRepository();
      stubGetBankList(mockBankAccountRepository);
      Get.testMode = true;
      Get.routing.args = {'is_edit': false};
      controller = AddEditWithdrawBankAccountController(
        bankAccountRepository: mockBankAccountRepository,
      );
      Get.put<AddEditWithdrawBankAccountController>(controller);
      await controller.onInit();
      await waitForBankAccountFetch();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders add bank account screen content', (tester) async {
      await pumpView(tester);

      expect(find.text('Tambah Rekening Penarikan'), findsOneWidget);
      expect(find.text('Nama Pemilik Rekening'), findsOneWidget);
      expect(find.text('Pilih Bank'), findsOneWidget);
      expect(find.text('Nomor Rekening'), findsOneWidget);
      expect(find.text('Tambah'), findsOneWidget);
      expect(find.byType(ReactiveForm), findsOneWidget);
      expect(find.byType(ReactiveTextField), findsNWidgets(2));
      expect(find.byType(ReactiveDropdownField<Bank>), findsOneWidget);
    });

    testWidgets('renders edit bank account screen content', (tester) async {
      Get.delete<AddEditWithdrawBankAccountController>();
      Get.routing.args = {
        'is_edit': true,
        'bank_account': sampleBankAccount(),
      };
      final editController = AddEditWithdrawBankAccountController(
        bankAccountRepository: mockBankAccountRepository,
      );
      Get.put<AddEditWithdrawBankAccountController>(editController);
      await editController.onInit();
      await waitForBankAccountFetch();

      await pumpView(tester);

      expect(find.text('Ubah Rekening Penarikan'), findsOneWidget);
      expect(find.text('Simpan'), findsOneWidget);
      expect(find.text('Tambah'), findsNothing);
    });

    testWidgets('shows loading indicator while fetching bank list', (
      tester,
    ) async {
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Tambah Rekening Penarikan'), findsOneWidget);
      expect(find.byType(ReactiveForm), findsNothing);
    });

    testWidgets('shows form field hints', (tester) async {
      await pumpView(tester);

      expect(
        find.text('Masukkan nama pemilik rekening'),
        findsOneWidget,
      );
      expect(find.text('Masukkan nomor rekening'), findsOneWidget);
      expect(find.text('Pilih bank'), findsOneWidget);
    });

    testWidgets('shows bank options in dropdown', (tester) async {
      await pumpView(tester);

      await tester.tap(find.byType(ReactiveDropdownField<Bank>));
      await tester.pumpAndSettle();

      expect(find.text('BCA'), findsWidgets);
      expect(find.text('Mandiri'), findsOneWidget);
    });

    testWidgets('submit button is enabled when form is rendered', (
      tester,
    ) async {
      await pumpView(tester);

      final submitButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Tambah'),
      );
      expect(submitButton.onPressed, isNotNull);
    });
  });
}
