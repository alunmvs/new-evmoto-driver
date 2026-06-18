import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/modules/my_order/controllers/my_order_controller.dart';
import 'package:new_evmoto_driver/app/modules/my_order/views/my_order_view.dart';
import 'package:new_evmoto_driver/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

class MockAdvanceBookingRepository extends Mock
    implements AdvanceBookingRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MyOrderView', () {
    late MyOrderController controller;
    late MockOrderRepository mockOrderRepository;
    late MockAdvanceBookingRepository mockAdvanceBookingRepository;

    Future<void> waitForFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const MyOrderView());
      await tester.pump();
    }

    void stubEmptyOrderLists() {
      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          state: any(named: 'state'),
        ),
      ).thenAnswer((_) async => []);
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(
          all: 'Semua',
          toBePaid: 'Belum Dibayar',
          cancelOrder: 'Dibatalkan',
          noActivityYet: 'Belum ada aktivitas',
          thereIsNoActivityAllActivities: 'Semua aktivitas akan muncul di sini',
        ),
      );
      mockOrderRepository = MockOrderRepository();
      mockAdvanceBookingRepository = MockAdvanceBookingRepository();
      stubEmptyOrderLists();
      controller = MyOrderController(
        orderRepository: mockOrderRepository,
        advanceBookingRepository: mockAdvanceBookingRepository,
      );
      Get.put<MyOrderController>(controller);
      controller.isFetch.value = false;
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders my order screen with title and tabs', (tester) async {
      await pumpView(tester);

      expect(find.text('Order Saya'), findsOneWidget);
      expect(find.text('Semua'), findsOneWidget);
      expect(find.text('Belum Dibayar'), findsOneWidget);
      expect(find.text('Dibatalkan'), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching orders', (tester) async {
      final fetchCompleter = Completer<void>();
      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          state: any(named: 'state'),
        ),
      ).thenAnswer((_) => fetchCompleter.future.then((_) => <Order>[]));

      Get.delete<MyOrderController>();
      final loadingController = MyOrderController(
        orderRepository: mockOrderRepository,
        advanceBookingRepository: mockAdvanceBookingRepository,
      );
      Get.put<MyOrderController>(loadingController);

      await pumpView(tester);
      unawaited(loadingController.onInit());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TabBar), findsNothing);

      fetchCompleter.complete();
      await waitForFetch();
      await tester.pump();
    });

    testWidgets('shows empty state on all orders tab', (tester) async {
      await pumpView(tester);

      expect(find.text('Belum ada aktivitas'), findsOneWidget);
      expect(find.text('Semua aktivitas akan muncul di sini'), findsOneWidget);
    });

    testWidgets('shows notification badge when pending payment list is not empty',
        (tester) async {
      controller.toBePaidList.assignAll([
        Order(id: 1, type: 1, startAddress: 'Origin', endAddress: 'Destination'),
      ]);

      await pumpView(tester);

      expect(find.byType(TabBar), findsOneWidget);
      final badgeContainers = find.descendant(
        of: find.byType(TabBar),
        matching: find.byType(Container),
      );
      expect(badgeContainers, findsWidgets);
    });

    testWidgets('switches to pending payment tab', (tester) async {
      await pumpView(tester);

      await tester.tap(find.text('Belum Dibayar'));
      await tester.pumpAndSettle();

      expect(find.text('Belum Dibayar'), findsOneWidget);
    });

    testWidgets('switches to cancelled tab', (tester) async {
      await pumpView(tester);

      await tester.tap(find.text('Dibatalkan'));
      await tester.pumpAndSettle();

      expect(find.text('Dibatalkan'), findsOneWidget);
    });
  });
}
