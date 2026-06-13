import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/account_service/controllers/account_service_controller.dart';
import 'package:new_evmoto_driver/app/modules/account_service/views/account_service_view.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

import 'package:new_evmoto_driver/app/data/models/rating_and_review_model.dart';
class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountServiceView', () {
    late AccountServiceController controller;
    late MockAccountRepository mockAccountRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const AccountServiceView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(),
      );
      mockAccountRepository = MockAccountRepository();
      when(
        () => mockAccountRepository.getServiceOrderList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => []);
      when(
        () => mockAccountRepository.getRatingAndReviewDetail(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async => RatingAndReview());
      when(
        () => mockAccountRepository.createFeedback(
          language: any(named: 'language'),
          type: any(named: 'type'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async => true);
      controller = AccountServiceController(accountRepository: mockAccountRepository);
      Get.put<AccountServiceController>(controller);
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
