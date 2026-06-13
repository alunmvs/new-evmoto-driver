import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/notification/controllers/notification_controller.dart';
import 'package:new_evmoto_driver/app/modules/notification/views/notification_view.dart';
import 'package:new_evmoto_driver/app/repositories/notification_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationView', () {
    late NotificationController controller;
    late MockNotificationRepository mockNotificationRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const NotificationView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(),
      );
      mockNotificationRepository = MockNotificationRepository();
      when(
        () => mockNotificationRepository.getNotificationList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => []);
      controller = NotificationController(notificationRepository: mockNotificationRepository);
      Get.put<NotificationController>(controller);
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
