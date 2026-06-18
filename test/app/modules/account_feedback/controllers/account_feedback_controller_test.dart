import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/modules/account_feedback/controllers/account_feedback_controller.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void stubCreateFeedback(MockAccountRepository mockAccountRepository) {
  when(
    () => mockAccountRepository.createFeedback(
      language: any(named: 'language'),
      type: any(named: 'type'),
      content: any(named: 'content'),
    ),
  ).thenAnswer((_) async {});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountFeedbackController', () {
    late AccountFeedbackController controller;
    late MockAccountRepository mockAccountRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockAccountRepository = MockAccountRepository();
      controller = AccountFeedbackController(
        accountRepository: mockAccountRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with empty content and invalid form',
      () {
        expect(controller.formGroup.control('content').value, isNull);
        expect(controller.formGroup.valid, isFalse);
      },
    );

    test(
      'onTapSubmitFeedback should not call repository when content is empty',
      () async {
        await controller.onTapSubmitFeedback();

        expect(controller.formGroup.valid, isFalse);
        verifyNever(
          () => mockAccountRepository.createFeedback(
            language: any(named: 'language'),
            type: any(named: 'type'),
            content: any(named: 'content'),
          ),
        );
      },
    );

    test(
      'form should be valid when content is filled',
      () {
        controller.formGroup.control('content').value = 'Great app';
        controller.formGroup.markAllAsTouched();

        expect(controller.formGroup.valid, isTrue);
      },
    );

    testWidgets(
      'onTapSubmitFeedback should submit feedback and navigate back',
      (WidgetTester tester) async {
        stubCreateFeedback(mockAccountRepository);
        controller.formGroup.control('content').value = 'Great app';

        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: '/home',
            getPages: [
              GetPage(
                name: '/home',
                page: () => const Scaffold(body: Text('Home')),
              ),
              GetPage(
                name: '/feedback',
                page: () => const Scaffold(body: Text('Feedback')),
              ),
            ],
          ),
        );
        Get.toNamed('/feedback');
        await tester.pumpAndSettle();
        expect(Get.currentRoute, '/feedback');

        await controller.onTapSubmitFeedback();
        await tester.pumpAndSettle();

        verify(
          () => mockAccountRepository.createFeedback(
            language: 2,
            type: 2,
            content: 'Great app',
          ),
        ).called(1);
        expect(Get.currentRoute, '/home');
      },
    );

    test(
      'should clean up controller without error when onClose is called',
      () {
        expect(() => controller.onClose(), returnsNormally);
      },
    );
  });
}
