import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/my_order_v2/controllers/my_order_v2_controller.dart';
import 'package:new_evmoto_driver/app/modules/my_order_v2/views/my_order_v2_view.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MyOrderV2View', () {
    late MyOrderV2Controller controller;
    late MockOrderRepository mockOrderRepository;

    Future<void> waitForInit() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const MyOrderV2View());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(
          all: 'Semua',
          cancel: 'Batalkan',
          pickedUp: 'Dijemput',
          destinationLocation: 'Lokasi Tujuan',
        ),
      );
      mockOrderRepository = MockOrderRepository();
      controller = MyOrderV2Controller(orderRepository: mockOrderRepository);
      Get.put<MyOrderV2Controller>(controller);
      await waitForInit();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders order screen with title and tabs', (tester) async {
      await pumpView(tester);

      expect(find.text('Order Saya'), findsOneWidget);
      expect(find.text('Semua'), findsOneWidget);
      expect(find.text('Reguler'), findsWidgets);
      expect(find.text('Booking'), findsWidgets);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('shows order content after initialization', (tester) async {
      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets('renders all-order tab content', (tester) async {
      await pumpView(tester);

      expect(find.text('Total Orderan : 6'), findsOneWidget);
      expect(find.text('Dalam Layanan'), findsOneWidget);
      expect(find.text('Lokasi Tujuan'), findsOneWidget);
      expect(find.text('Sedang Menunggu'), findsOneWidget);
      expect(find.text('Tanggal dan Waktu'), findsOneWidget);
      expect(find.text('Dijemput'), findsOneWidget);
    });

    testWidgets('can switch to Reguler tab', (tester) async {
      await pumpView(tester);

      final tabBar = find.byType(TabBar);
      await tester.tap(
        find.descendant(of: tabBar, matching: find.text('Reguler')),
      );
      await tester.pumpAndSettle();

      expect(controller.tabController?.index, 1);
    });

    testWidgets('can switch to Booking tab', (tester) async {
      await pumpView(tester);

      final tabBar = find.byType(TabBar);
      await tester.tap(
        find.descendant(of: tabBar, matching: find.text('Booking')),
      );
      await tester.pumpAndSettle();

      expect(controller.tabController?.index, 2);
    });
  });
}
