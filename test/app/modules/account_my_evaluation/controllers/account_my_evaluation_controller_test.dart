import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/rating_and_review_model.dart';
import 'package:new_evmoto_driver/app/modules/account_my_evaluation/controllers/account_my_evaluation_controller.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

RatingAndReview sampleRatingAndReview() {
  return RatingAndReview(
    sumScore: 4.2,
    ratingReview: [
      RatingReview(
        customerName: 'Alice',
        time: '2024-01-01',
        fraction: 5.0,
        content: 'Excellent service!',
      ),
      RatingReview(
        customerName: 'Bob',
        time: '2024-01-02',
        fraction: 4.0,
        content: 'Good ride',
      ),
      RatingReview(
        customerName: 'Charlie',
        time: '2024-01-03',
        fraction: 5.0,
        content: '',
      ),
      RatingReview(
        customerName: 'Dave',
        time: '2024-01-04',
        fraction: 3.0,
        content: 'Average',
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

  group('AccountMyEvaluationController', () {
    late AccountMyEvaluationController controller;
    late MockAccountRepository mockAccountRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockAccountRepository = MockAccountRepository();
      controller = AccountMyEvaluationController(
        accountRepository: mockAccountRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test('should initialize with default values', () {
      expect(controller.pageNum.value, 1);
      expect(controller.size.value, 100);
      expect(controller.selectedIndex.value, 999);
      expect(controller.isFetch.value, false);
      expect(controller.ratingStatistics, isEmpty);
      expect(controller.ratingAndReview.value.ratingReview, isNull);
    });

    test('onInit should fetch rating and review detail', () async {
      final sampleData = sampleRatingAndReview();
      stubGetRatingAndReview(mockAccountRepository, sampleData);

      await controller.onInit();

      expect(controller.isFetch.value, isFalse);
      expect(controller.ratingAndReview.value.sumScore, 4.2);
      expect(controller.ratingAndReview.value.ratingReview, hasLength(4));
      verify(
        () => mockAccountRepository.getRatingAndReviewDetail(
          size: 100,
          pageNum: 1,
          language: 2,
        ),
      ).called(1);
    });

    test('getRatingAndReviewDetail should group reviews by fraction', () async {
      stubGetRatingAndReview(mockAccountRepository, sampleRatingAndReview());

      await controller.getRatingAndReviewDetail();

      expect(controller.ratingStatistics[5.0], hasLength(2));
      expect(controller.ratingStatistics[4.0], hasLength(1));
      expect(controller.ratingStatistics[3.0], hasLength(1));
      expect(controller.ratingStatistics[2.0], isNull);
      expect(controller.ratingStatistics[1.0], isNull);
    });

    test('getRatingByIndex should return correct rating label', () {
      expect(controller.getRatingByIndex(index: 0), '5.0');
      expect(controller.getRatingByIndex(index: 1), '4.0');
      expect(controller.getRatingByIndex(index: 2), '3.0');
      expect(controller.getRatingByIndex(index: 3), '2.0');
      expect(controller.getRatingByIndex(index: 4), '1.0');
      expect(controller.getRatingByIndex(index: 99), '-');
    });

    test('getTotalRatingByIndex should return count for each rating bucket', () async {
      stubGetRatingAndReview(mockAccountRepository, sampleRatingAndReview());
      await controller.getRatingAndReviewDetail();

      expect(controller.getTotalRatingByIndex(index: 0), '2');
      expect(controller.getTotalRatingByIndex(index: 1), '1');
      expect(controller.getTotalRatingByIndex(index: 2), '1');
      expect(controller.getTotalRatingByIndex(index: 3), '0');
      expect(controller.getTotalRatingByIndex(index: 4), '0');
      expect(controller.getTotalRatingByIndex(index: 999), '4');
      expect(controller.getTotalRatingByIndex(index: 99), '-');
    });

    test('getTotalRatingByIndex should return zero when bucket is empty', () async {
      stubGetRatingAndReview(
        mockAccountRepository,
        RatingAndReview(ratingReview: []),
      );
      await controller.getRatingAndReviewDetail();

      expect(controller.getTotalRatingByIndex(index: 0), '0');
      expect(controller.getTotalRatingByIndex(index: 999), '0');
    });

    test('getRatingAndReviewListByIndex should filter reviews by selected index', () async {
      stubGetRatingAndReview(mockAccountRepository, sampleRatingAndReview());
      await controller.getRatingAndReviewDetail();

      expect(
        controller.getRatingAndReviewListByIndex(index: 0).map((e) => e.customerName),
        ['Alice', 'Charlie'],
      );
      expect(
        controller.getRatingAndReviewListByIndex(index: 1).map((e) => e.customerName),
        ['Bob'],
      );
      expect(
        controller.getRatingAndReviewListByIndex(index: 2).map((e) => e.customerName),
        ['Dave'],
      );
      expect(controller.getRatingAndReviewListByIndex(index: 3), isEmpty);
      expect(
        controller.getRatingAndReviewListByIndex(index: 999),
        hasLength(4),
      );
    });

    test('should clean up controller without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
