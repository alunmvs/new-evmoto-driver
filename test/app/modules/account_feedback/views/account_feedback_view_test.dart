import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/account_feedback/controllers/account_feedback_controller.dart';
import 'package:new_evmoto_driver/app/modules/account_feedback/views/account_feedback_view.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountFeedbackView', () {
    late AccountFeedbackController controller;
    late MockAccountRepository mockAccountRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const AccountFeedbackView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(
          evaluationNotFoundTitle: 'Send Feedback',
          hintFeedback: 'Write your feedback here',
          noteMax200Char: 'Maximum 200 characters',
          sendFeedback: 'Submit Feedback',
        ),
      );
      mockAccountRepository = MockAccountRepository();
      when(
        () => mockAccountRepository.createFeedback(
          language: any(named: 'language'),
          type: any(named: 'type'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async {});
      controller = AccountFeedbackController(
        accountRepository: mockAccountRepository,
      );
      Get.put<AccountFeedbackController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders feedback screen content', (tester) async {
      await pumpView(tester);

      expect(find.text('Send Feedback'), findsOneWidget);
      expect(find.text('Write your feedback here'), findsOneWidget);
      expect(find.text('Maximum 200 characters'), findsOneWidget);
      expect(find.text('Submit Feedback'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows validation error when content is empty', (
      tester,
    ) async {
      controller.formGroup.control('content').markAsTouched();

      await pumpView(tester);
      await tester.pumpAndSettle();

      expect(find.text('Wajib diisi'), findsOneWidget);
    });

    testWidgets('allows entering feedback content', (tester) async {
      await pumpView(tester);

      await tester.enterText(find.byType(TextField), 'Great experience');
      await tester.pumpAndSettle();

      expect(
        controller.formGroup.control('content').value,
        'Great experience',
      );
      expect(controller.formGroup.valid, isTrue);
    });

    testWidgets('submits feedback when submit button is tapped', (
      tester,
    ) async {
      await pumpView(tester);

      await tester.enterText(find.byType(TextField), 'Great experience');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Submit Feedback'));
      await tester.pumpAndSettle();

      verify(
        () => mockAccountRepository.createFeedback(
          language: 2,
          type: 2,
          content: 'Great experience',
        ),
      ).called(1);
    });
  });
}
