import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/guarantee_income_approval_model.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/controllers/history_guarantee_income_controller.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/views/history_guarantee_income_view.dart';
import 'package:new_evmoto_driver/app/repositories/guarantee_income_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockGuaranteeIncomeRepository extends Mock
    implements GuaranteeIncomeRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  group('HistoryGuaranteeIncomeView', () {
    late HistoryGuaranteeIncomeController controller;
    late MockGuaranteeIncomeRepository mockGuaranteeIncomeRepository;

    Future<void> waitForInitialFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpModuleView(tester, const HistoryGuaranteeIncomeView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockGuaranteeIncomeRepository = MockGuaranteeIncomeRepository();
      when(
        () => mockGuaranteeIncomeRepository.getGuaranteeIncomeApprovalList(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => []);
      controller = HistoryGuaranteeIncomeController(
        guaranteeIncomeRepository: mockGuaranteeIncomeRepository,
      );
      Get.put<HistoryGuaranteeIncomeController>(controller);
      await waitForInitialFetch();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders history guarantee income app bar and summary card', (
      tester,
    ) async {
      controller.isFetch.value = false;
      controller.isFetchDate.value = false;
      controller.selectedGuaranteeIncomeApproval.value = GuaranteeIncomeApproval(
        id: 1,
        approvalStatus: 1,
        subsidyAmount: 0,
      );

      await pumpView(tester);

      expect(find.text('Riwayat Guarantee Income'), findsOneWidget);
      expect(find.text('Guarantee Income Hari Ini'), findsOneWidget);
    });

    testWidgets('shows loading indicator while initial fetch is in progress', (
      tester,
    ) async {
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Guarantee Income Hari Ini'), findsNothing);
    });

    testWidgets('shows empty state when there is no guarantee income', (
      tester,
    ) async {
      controller.isFetch.value = false;
      controller.isFetchDate.value = false;
      controller.selectedGuaranteeIncomeApproval.value = GuaranteeIncomeApproval();
      controller.totalSubsidyAmount.value = 0;

      await pumpView(tester);

      expect(find.text('Tidak Ada Guarantee Income'), findsOneWidget);
      expect(
        find.text(
          'Anda belum memiliki pendapatan Guarantee Income pada hari ini',
        ),
        findsOneWidget,
      );
      expect(find.text('Rp0'), findsOneWidget);
    });

    testWidgets('shows pending status when approval is waiting confirmation', (
      tester,
    ) async {
      controller.isFetch.value = false;
      controller.isFetchDate.value = false;
      controller.totalSubsidyAmount.value = 50000;
      controller.selectedGuaranteeIncomeApproval.value = GuaranteeIncomeApproval(
        id: 1,
        approvalStatus: 0,
        subsidyAmount: 50000,
        intervals: [
          Intervals(
            startTime: '08:00',
            endTime: '10:00',
            amountPerHour: 10000,
            earnedMoney: 20000,
          ),
        ],
      );

      await pumpView(tester);

      expect(find.text('Menunggu Konfirmasi'), findsOneWidget);
      expect(find.text('(08:00 - 10:00)'), findsOneWidget);
      expect(find.textContaining('/ jam Rp10.000'), findsOneWidget);
      expect(find.text('Rp20.000'), findsOneWidget);
      expect(find.text('Rp50.000'), findsOneWidget);
    });

    testWidgets('shows paid status when approval has been paid', (
      tester,
    ) async {
      controller.isFetch.value = false;
      controller.isFetchDate.value = false;
      controller.totalSubsidyAmount.value = 75000;
      controller.selectedGuaranteeIncomeApproval.value = GuaranteeIncomeApproval(
        id: 2,
        approvalStatus: 1,
        subsidyAmount: 75000,
        intervals: [
          Intervals(
            startTime: '14:00',
            endTime: '16:00',
            amountPerHour: 15000,
            earnedMoney: 30000,
          ),
        ],
      );

      await pumpView(tester);

      expect(find.text('Sudah Dibayarkan'), findsOneWidget);
      expect(find.text('(14:00 - 16:00)'), findsOneWidget);
      expect(find.textContaining('/ jam Rp15.000'), findsOneWidget);
      expect(find.text('Rp30.000'), findsOneWidget);
      expect(find.text('Rp75.000'), findsOneWidget);
    });

    testWidgets('renders horizontal date selector list', (tester) async {
      controller.isFetch.value = false;
      controller.isFetchDate.value = false;

      await pumpView(tester);

      expect(find.byType(SingleChildScrollView), findsWidgets);
      expect(
        find.text(DateTime.now().day.toString()),
        findsWidgets,
      );
    });
  });
}
