import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/history_balance_revenue_model.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/history_balance_revenue/controllers/history_balance_revenue_controller.dart';
import 'package:new_evmoto_driver/app/modules/history_balance_revenue/views/history_balance_revenue_view.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockHistoryBalanceRepository extends Mock
    implements HistoryBalanceRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  group('HistoryBalanceRevenueView', () {
    late HistoryBalanceRevenueController controller;
    late MockHistoryBalanceRepository mockHistoryBalanceRepository;

    Future<void> waitForRevenueFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const HistoryBalanceRevenueView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(destinationLocation: 'Lokasi Tujuan'),
      );
      mockHistoryBalanceRepository = MockHistoryBalanceRepository();
      when(
        () => mockHistoryBalanceRepository.getHistoryRevenueList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => HistoryBalanceRevenue());
      controller = HistoryBalanceRevenueController(
        historyBalanceRepository: mockHistoryBalanceRepository,
      );
      Get.put<HistoryBalanceRevenueController>(controller);
      await waitForRevenueFetch();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders revenue history screen content', (tester) async {
      await pumpView(tester);

      expect(find.text('Riwayat Pendapatan'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Belum Ada Riwayat'), findsOneWidget);
      expect(find.text('Tidak ada riwayat pada bagian ini'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching revenue history', (
      tester,
    ) async {
      final revenueRequest = Completer<HistoryBalanceRevenue>();
      when(
        () => mockHistoryBalanceRepository.getHistoryRevenueList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) => revenueRequest.future);

      Get.delete<HistoryBalanceRevenueController>();
      final loadingController = HistoryBalanceRevenueController(
        historyBalanceRepository: mockHistoryBalanceRepository,
      );
      Get.put<HistoryBalanceRevenueController>(loadingController);

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Belum Ada Riwayat'), findsNothing);

      revenueRequest.complete(HistoryBalanceRevenue());
      await waitForRevenueFetch();
    });

    testWidgets('renders revenue item when history data is available', (
      tester,
    ) async {
      controller.isFetch.value = false;
      controller.historyBalanceRevenue.value = HistoryBalanceRevenue(
        income: 100000,
        flow: 120000,
        revenue: [
          Revenue(
            orderId: 1,
            orderType: 1,
            payTime: '2026-06-13 09:15',
            payMoney: 45000,
          ),
        ],
      );

      await pumpView(tester);

      expect(find.text('2026-06-13 09:15'), findsOneWidget);
      expect(find.text('Motorcycle'), findsOneWidget);
      expect(find.text('Lokasi Tujuan'), findsOneWidget);
      expect(find.text('Yang didapatkan driver :'), findsOneWidget);
      expect(find.text('Rp45.000'), findsOneWidget);
      expect(find.text('Belum Ada Riwayat'), findsNothing);
    });

    testWidgets('renders city express delivery label for order type 2', (
      tester,
    ) async {
      controller.isFetch.value = false;
      controller.historyBalanceRevenue.value = HistoryBalanceRevenue(
        revenue: [
          Revenue(
            orderId: 2,
            orderType: 2,
            payTime: '2026-06-12 14:00',
            payMoney: 30000,
          ),
        ],
      );

      await pumpView(tester);

      expect(find.text('City Express Delivery'), findsOneWidget);
    });
  });
}
