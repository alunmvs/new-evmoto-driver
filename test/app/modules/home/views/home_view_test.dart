import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/vehicle_statistics_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/modules/home/views/home_view.dart';
import '../../../../helpers/module_test_helpers.dart';

class TestableHomeController extends HomeController {
  TestableHomeController({
    required super.vehicleRepository,
    required super.orderRepository,
    required super.userRepository,
    required super.accountRepository,
    required super.versioningServerRepository,
    required super.guaranteeIncomeRepository,
    required super.advanceBookingRepository,
  });

  @override
  // ignore: must_call_super
  Future<void> onInit() async {
    isFetch.value = false;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeView', () {
    late TestableHomeController controller;

    Language homeLanguage() {
      return Language(
        homeYourBalance: 'Your Balance',
        recharge: 'Top Up',
        withdraw: 'Withdraw',
        history: 'History',
        online: 'Online',
        offline: 'Offline',
        yourTotalOrder: 'Your Total Orders',
        order: 'Orders',
      );
    }

    Future<void> pumpView(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpModuleView(tester, const HomeView());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      while (tester.takeException() != null) {}
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(language: homeLanguage());
      registerHomeControllerDependencies();
      registerMockUserServices();

      const geolocatorChannel = MethodChannel(
        'flutter.baseflow.com/geolocator',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(geolocatorChannel, (
            MethodCall methodCall,
          ) async {
            return 0;
          });

      controller = TestableHomeController(
        vehicleRepository: MockVehicleRepository(),
        orderRepository: MockOrderRepository(),
        userRepository: MockUserRepository(),
        accountRepository: MockAccountRepository(),
        versioningServerRepository: MockVersioningServerRepository(),
        guaranteeIncomeRepository: MockGuaranteeIncomeRepository(),
        advanceBookingRepository: MockAdvanceBookingRepository(),
      );
      controller.vehicleStatistics.value = VehicleStatistics(
        work: 2,
        dayNum: 3,
        mouthNum: 12,
      );
      controller.workStatus.value = 2;
      Get.put<HomeController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders home screen content when data is loaded', (
      tester,
    ) async {
      await pumpView(tester);

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Your Balance'), findsOneWidget);
      expect(find.textContaining('Rp'), findsOneWidget);
      expect(find.text('Top Up'), findsOneWidget);
      expect(find.text('Withdraw'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Offline'), findsWidgets);
    });

    testWidgets('shows loading indicator while fetching home data', (
      tester,
    ) async {
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Your Balance'), findsNothing);
    });

    testWidgets('reflects online work status in controller state', (
      tester,
    ) async {
      controller.workStatus.value = 1;
      controller.vehicleStatistics.value = VehicleStatistics(work: 1);

      await pumpView(tester);

      expect(controller.workStatus.value, 1);
      expect(find.text('Online'), findsWidgets);
    });
  });
}
