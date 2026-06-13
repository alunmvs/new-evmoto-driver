import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/modules/account/views/account_view.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import '../../../../helpers/module_test_helpers.dart';
import '../account_test_helpers.dart';

class MockOtpRepository extends Mock implements OtpRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountView', () {
    late TestableAccountController controller;
    late MockOtpRepository mockOtpRepository;
    late MockUserRepository mockUserRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpModuleView(tester, const AccountView());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      while (tester.takeException() != null) {}
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      mockAccountPlatformChannels();
      registerCommonModuleDependencies(language: accountLanguage());
      registerTestableHomeControllerForAccount();
      mockOtpRepository = MockOtpRepository();
      mockUserRepository = MockUserRepository();
      controller = registerTestableAccountController(
        otpRepository: mockOtpRepository,
        userRepository: mockUserRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders account screen content when data is loaded', (
      tester,
    ) async {
      await pumpView(tester);

      expect(find.text('Test Driver'), findsOneWidget);
      expect(find.text('628123456789'), findsOneWidget);
      expect(find.text('B 1234 ABC | Toyota'), findsOneWidget);
      expect(find.text('My Balance'), findsOneWidget);
      expect(find.textContaining('Rp'), findsOneWidget);
      expect(find.text('Total Orders'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('My Rating'), findsOneWidget);
      expect(find.text('4.8'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching account data', (
      tester,
    ) async {
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Driver'), findsNothing);
    });

    testWidgets('renders account menu items', (tester) async {
      await pumpView(tester);

      expect(find.text('My Evaluation'), findsOneWidget);
      expect(find.text('Send Feedback'), findsOneWidget);
      expect(find.text('Select Service'), findsOneWidget);
      expect(find.text('Change Vehicle'), findsOneWidget);
      expect(find.text('Recommend to Friend'), findsOneWidget);
      expect(find.text('Contact CS'), findsOneWidget);
      expect(find.text('Other Settings'), findsOneWidget);
      expect(find.text('Kelola Akun'), findsOneWidget);
    });

    testWidgets('displays app version information', (tester) async {
      await pumpView(tester);

      expect(find.text('App Version v.1.9.5+100'), findsOneWidget);
    });
  });
}
