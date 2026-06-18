import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/withdraw/controllers/withdraw_controller.dart';
import 'package:new_evmoto_driver/app/modules/withdraw/views/withdraw_view.dart';
import '../../../../helpers/module_test_helpers.dart';
import '../withdraw_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WithdrawView', () {
    late WithdrawController controller;
    late MockBankAccountRepository mockBankAccountRepository;

    Future<void> waitForBankAccountFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpModuleView(tester, const WithdrawView());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      while (tester.takeException() != null) {}
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(language: Language());
      registerTestableHomeController(balance: 50000);
      mockBankAccountRepository = MockBankAccountRepository();
      stubGetBankAccountList(mockBankAccountRepository);
      controller = WithdrawController(
        bankAccountRepository: mockBankAccountRepository,
      );
      Get.put<WithdrawController>(controller);
      await controller.onInit();
      await waitForBankAccountFetch();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders withdraw screen content', (tester) async {
      await pumpView(tester);

      expect(find.text('Tarik Dana'), findsOneWidget);
      expect(find.text('Saldo Aktif Saya'), findsWidgets);
      expect(find.text('Rp50.000'), findsWidgets);
      expect(find.text('Riwayat Tarik Dana'), findsOneWidget);
      expect(find.text('Tambahkan Nomor Rekening Baru'), findsOneWidget);
      expect(find.text('Nomor Rekening Tersimpan'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching bank accounts', (
      tester,
    ) async {
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Nomor Rekening Tersimpan'), findsNothing);
      expect(find.text('Tambahkan Nomor Rekening Baru'), findsNothing);
    });

    testWidgets('shows saved bank accounts when list is not empty', (
      tester,
    ) async {
      await pumpView(tester);

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('***** 67890'), findsOneWidget);
      expect(find.text('***** 43210'), findsOneWidget);
      expect(find.text('Belum Ada Nomor Rekening'), findsNothing);
    });

    testWidgets('shows empty state when bank account list is empty', (
      tester,
    ) async {
      Get.delete<WithdrawController>();
      stubGetBankAccountList(mockBankAccountRepository, accounts: []);
      final emptyController = WithdrawController(
        bankAccountRepository: mockBankAccountRepository,
      );
      Get.put<WithdrawController>(emptyController);
      await emptyController.onInit();
      await waitForBankAccountFetch();

      await pumpView(tester);

      expect(find.text('Belum Ada Nomor Rekening'), findsOneWidget);
      expect(
        find.text(
          'Tambahkan nomor rekening untuk memudahkan kamu dalam aktivitas Tarik Dana.',
        ),
        findsOneWidget,
      );
      expect(find.text('John Doe'), findsNothing);
    });

    testWidgets('shows edit and delete actions when edit mode is active', (
      tester,
    ) async {
      controller.isEditDeleteActive.value = true;

      await pumpView(tester);

      expect(find.text('Edit'), findsNWidgets(2));
      expect(find.text('Hapus'), findsNWidgets(2));
    });

    testWidgets('hides edit and delete actions when edit mode is inactive', (
      tester,
    ) async {
      controller.isEditDeleteActive.value = false;

      await pumpView(tester);

      expect(find.text('Edit'), findsNothing);
      expect(find.text('Hapus'), findsNothing);
    });
  });
}
