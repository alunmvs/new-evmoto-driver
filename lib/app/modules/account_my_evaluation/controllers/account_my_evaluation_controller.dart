import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/rating_and_review_model.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class AccountMyEvaluationController extends GetxController {
  final AccountRepository accountRepository;

  AccountMyEvaluationController({required this.accountRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final ratingAndReview = RatingAndReview().obs;

  final pageNum = 1.obs;
  final size = 100.obs;

  final ratingStatistics = <double?, List<RatingReview>?>{}.obs;

  final selectedIndex = 999.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getRatingAndReviewDetail();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getRatingAndReviewDetail() async {
    ratingAndReview.value = await accountRepository.getRatingAndReviewDetail(
      size: size.value,
      pageNum: pageNum.value,
      language: 2,
    );

    for (var i in ratingAndReview.value.ratingReview!) {
      if (ratingStatistics.containsKey(i.fraction) == false) {
        ratingStatistics[i.fraction] = [];
      }
      ratingStatistics[i.fraction]!.add(i);
    }
  }

  String getRatingByIndex({required int index}) {
    switch (index) {
      case 0:
        return '5.0';
      case 1:
        return '4.0';
      case 2:
        return '3.0';
      case 3:
        return '2.0';
      case 4:
        return '1.0';
      default:
        return '-';
    }
  }

  String getTotalRatingByIndex({required int index}) {
    switch (index) {
      case 0:
        if (ratingStatistics[5.0] == null) {
          return '0';
        }
        return ratingStatistics[5.0]!.length.toString();
      case 1:
        if (ratingStatistics[4.0] == null) {
          return '0';
        }
        return ratingStatistics[4.0]!.length.toString();
      case 2:
        if (ratingStatistics[3.0] == null) {
          return '0';
        }
        return ratingStatistics[3.0]!.length.toString();
      case 3:
        if (ratingStatistics[2.0] == null) {
          return '0';
        }
        return ratingStatistics[2.0]!.length.toString();
      case 4:
        if (ratingStatistics[1.0] == null) {
          return '0';
        }
        return ratingStatistics[1.0]!.length.toString();
      case 999:
        return ratingAndReview.value.ratingReview!.length.toString();
      default:
        return '-';
    }
  }

  List<RatingReview> getRatingAndReviewListByIndex({required int index}) {
    switch (index) {
      case 0:
        return ratingStatistics[5.0] ?? <RatingReview>[];
      case 1:
        return ratingStatistics[4.0] ?? <RatingReview>[];
      case 2:
        return ratingStatistics[3.0] ?? <RatingReview>[];
      case 3:
        return ratingStatistics[2.0] ?? <RatingReview>[];
      case 4:
        return ratingStatistics[1.0] ?? <RatingReview>[];
      case 999:
        return ratingAndReview.value.ratingReview ?? <RatingReview>[];
      default:
        return ratingAndReview.value.ratingReview ?? <RatingReview>[];
    }
  }
}
