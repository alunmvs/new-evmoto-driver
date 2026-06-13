import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/history_balance_withdraw/controllers/history_balance_withdraw_controller.dart';
import 'package:new_evmoto_driver/app/modules/history_balance_withdraw/views/history_balance_withdraw_view.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

import 'package:new_evmoto_driver/app/data/models/history_balance_revenue_model.dart';
class MockHistoryBalanceRepository extends Mock implements HistoryBalanceRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistoryBalanceWithdrawView', () {
    late HistoryBalanceWithdrawController controller;
    late MockHistoryBalanceRepository mockHistoryBalanceRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const HistoryBalanceWithdrawView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(),
      );
      mockHistoryBalanceRepository = MockHistoryBalanceRepository();
      when(
        () => mockHistoryBalanceRepository.getHistoryWithdrawList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => []);
      when(
        () => mockHistoryBalanceRepository.getHistoryRechargeList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => []);
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
      controller = HistoryBalanceWithdrawController(historyBalanceRepository: mockHistoryBalanceRepository);
      Get.put<HistoryBalanceWithdrawController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders screen scaffold', (tester) async {
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
