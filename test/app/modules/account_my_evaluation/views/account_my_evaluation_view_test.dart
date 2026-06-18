import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/rating_and_review_model.dart';
import 'package:new_evmoto_driver/app/modules/account_my_evaluation/controllers/account_my_evaluation_controller.dart';
import 'package:new_evmoto_driver/app/modules/account_my_evaluation/views/account_my_evaluation_view.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class TestAccountMyEvaluationController extends AccountMyEvaluationController {
  TestAccountMyEvaluationController({required super.accountRepository});

  @override
  Future<void> onInit() async {
    isFetch.value = false;
  }
}

RatingAndReview sampleRatingAndReview() {
  return RatingAndReview(
    sumScore: 4.5,
    ratingReview: [
      RatingReview(
        customerName: 'Alice',
        time: '2024-01-01 10:00',
        fraction: 5.0,
        content: 'Excellent service!',
      ),
      RatingReview(
        customerName: 'Bob',
        time: '2024-01-02 11:00',
        fraction: 4.0,
        content: 'Good ride',
      ),
    ],
  );
}

void stubGetRatingAndReview(
  MockAccountRepository mock,
  RatingAndReview data,
) {
  when(
    () => mock.getRatingAndReviewDetail(
      size: any(named: 'size'),
      pageNum: any(named: 'pageNum'),
      language: any(named: 'language'),
    ),
  ).thenAnswer((_) async => data);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountMyEvaluationView', () {
    late TestAccountMyEvaluationController controller;
    late MockAccountRepository mockAccountRepository;

    Future<void> waitForFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const AccountMyEvaluationView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(
          myEvaluation: 'My Evaluation',
          overallRating: 'Overall Rating',
          evaluationNotFoundTitle: 'No evaluations yet',
          evaluationNotFoundDescription: 'Your customer reviews will appear here',
        ),
      );
      mockAccountRepository = MockAccountRepository();
      stubGetRatingAndReview(mockAccountRepository, sampleRatingAndReview());
      controller = TestAccountMyEvaluationController(
        accountRepository: mockAccountRepository,
      );
      controller.ratingAndReview.value = RatingAndReview(ratingReview: []);
      Get.put<AccountMyEvaluationController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders my evaluation app bar title', (tester) async {
      await pumpView(tester);

      expect(find.text('My Evaluation'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching evaluations', (
      tester,
    ) async {
      final fetchCompleter = Completer<RatingAndReview>();
      when(
        () => mockAccountRepository.getRatingAndReviewDetail(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) => fetchCompleter.future);

      Get.delete<AccountMyEvaluationController>();
      final loadingController = AccountMyEvaluationController(
        accountRepository: mockAccountRepository,
      );
      Get.put<AccountMyEvaluationController>(loadingController);

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('My Evaluation'), findsOneWidget);

      fetchCompleter.complete(sampleRatingAndReview());
      await waitForFetch();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('5.0'), findsOneWidget);
    });

    testWidgets('renders rating filter grid labels', (tester) async {
      controller.ratingAndReview.value = sampleRatingAndReview();
      controller.ratingStatistics.clear();
      controller.ratingStatistics[5.0] = [sampleRatingAndReview().ratingReview!.first];
      controller.ratingStatistics[4.0] = [sampleRatingAndReview().ratingReview!.last];

      await pumpView(tester);

      expect(find.text('5.0'), findsOneWidget);
      expect(find.text('4.0'), findsOneWidget);
      expect(find.text('3.0'), findsOneWidget);
      expect(find.text('2.0'), findsOneWidget);
      expect(find.text('1.0'), findsOneWidget);
    });

    testWidgets('renders overall rating with total count', (tester) async {
      controller.ratingAndReview.value = sampleRatingAndReview();
      controller.ratingStatistics.clear();
      controller.ratingStatistics[5.0] = [sampleRatingAndReview().ratingReview!.first];
      controller.ratingStatistics[4.0] = [sampleRatingAndReview().ratingReview!.last];

      await pumpView(tester);

      expect(find.text('Overall Rating (2)'), findsOneWidget);
    });

    testWidgets('renders review list when data exists', (tester) async {
      controller.ratingAndReview.value = sampleRatingAndReview();
      controller.ratingStatistics.clear();
      controller.ratingStatistics[5.0] = [sampleRatingAndReview().ratingReview!.first];
      controller.ratingStatistics[4.0] = [sampleRatingAndReview().ratingReview!.last];

      await pumpView(tester);

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('2024-01-01 10:00'), findsOneWidget);
      expect(find.text('Excellent service!'), findsOneWidget);
      expect(find.text('Good ride'), findsOneWidget);
    });

    testWidgets('filters reviews when rating bucket is tapped', (tester) async {
      controller.ratingAndReview.value = sampleRatingAndReview();
      controller.ratingStatistics.clear();
      controller.ratingStatistics[5.0] = [sampleRatingAndReview().ratingReview!.first];
      controller.ratingStatistics[4.0] = [sampleRatingAndReview().ratingReview!.last];

      await pumpView(tester);

      await tester.tap(find.text('5.0'));
      await tester.pump();

      expect(controller.selectedIndex.value, 0);
      expect(find.text('Overall Rating (1)'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);

      await tester.tap(find.text('5.0'));
      await tester.pump();

      expect(controller.selectedIndex.value, 999);
      expect(find.text('Overall Rating (2)'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });
  });
}
