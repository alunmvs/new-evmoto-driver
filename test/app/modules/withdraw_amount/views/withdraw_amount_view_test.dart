import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/modules/withdraw_amount/controllers/withdraw_amount_controller.dart';
import 'package:new_evmoto_driver/app/modules/withdraw_amount/views/withdraw_amount_view.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../helpers/module_test_helpers.dart';
import '../withdraw_amount_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WithdrawAmountView', () {
    late WithdrawAmountController controller;
    late MockWithdrawRepository mockWithdrawRepository;

    Future<void> waitForWithdrawFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpModuleView(tester, const WithdrawAmountView());
      await tester.pump();
      while (tester.takeException() != null) {}
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerWithdrawAmountDependencies(withdrawMin: 50000);
      mockWithdrawRepository = MockWithdrawRepository();
      stubGetAdminFee(mockWithdrawRepository);
      Get.testMode = true;
      Get.routing.args = {'selected_bank_account': sampleBankAccount()};
      controller = WithdrawAmountController(
        withdrawRepository: mockWithdrawRepository,
      );
      Get.put<WithdrawAmountController>(controller);
      await controller.onInit();
      await waitForWithdrawFetch();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders withdraw amount screen content', (tester) async {
      await pumpView(tester);

      expect(find.text('Masukkan Nominal'), findsWidgets);
      expect(find.text('Saldo Aktif Saya'), findsWidgets);
      expect(find.text('Nomor Rekening'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('***** 67890'), findsOneWidget);
      expect(find.text('Riwayat Tarik Dana'), findsOneWidget);
      expect(find.text('Lanjutkan'), findsOneWidget);
      expect(find.byType(ReactiveForm), findsOneWidget);
      expect(find.byType(ReactiveTextField), findsOneWidget);
    });

    testWidgets('shows formatted active balance', (tester) async {
      await pumpView(tester);

      expect(find.textContaining('Rp500.000'), findsWidgets);
    });

    testWidgets('shows loading indicator while fetching admin fee', (
      tester,
    ) async {
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Nomor Rekening'), findsNothing);
      expect(find.byType(ReactiveForm), findsNothing);
      expect(find.text('Lanjutkan'), findsNothing);
    });

    testWidgets('shows withdraw form field hint', (tester) async {
      await pumpView(tester);

      expect(find.text('Masukkan nominal'), findsOneWidget);
    });

    testWidgets('shows expanded info when isInfoExpanded is true', (
      tester,
    ) async {
      controller.isInfoExpanded.value = true;

      await pumpView(tester);

      expect(find.textContaining('Minimal penarikan'), findsWidgets);
      expect(
        find.text('Biaya admin mengikuti kebijakan bank'),
        findsWidgets,
      );
    });

    testWidgets('hides expanded info when isInfoExpanded is false', (
      tester,
    ) async {
      controller.isInfoExpanded.value = false;

      await pumpView(tester);

      expect(find.text('Biaya admin mengikuti kebijakan bank'), findsNothing);
    });

    testWidgets('submit button is enabled when form is rendered', (
      tester,
    ) async {
      await pumpView(tester);

      final submitButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Lanjutkan'),
      );
      expect(submitButton.onPressed, isNotNull);
    });

    testWidgets('masks short bank account numbers', (tester) async {
      Get.delete<WithdrawAmountController>();
      Get.routing.args = {
        'selected_bank_account': BankAccount(
          bank: 'BCA',
          bankCode: '014',
          name: 'Jane Doe',
          code: '1234',
        ),
      };
      final shortCodeController = WithdrawAmountController(
        withdrawRepository: mockWithdrawRepository,
      );
      Get.put<WithdrawAmountController>(shortCodeController);
      await shortCodeController.onInit();
      await waitForWithdrawFetch();

      await pumpView(tester);

      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('*****'), findsOneWidget);
    });
  });
}
