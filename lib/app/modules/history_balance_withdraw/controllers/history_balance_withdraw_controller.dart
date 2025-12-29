import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/history_balance_withdraw_model.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HistoryBalanceWithdrawController extends GetxController {
  final HistoryBalanceRepository historyBalanceRepository;

  HistoryBalanceWithdrawController({required this.historyBalanceRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final historyBalanceWithdrawList = <HistoryBalanceWithdraw>[].obs;
  final historyBalanceWithdrawPageNum = 1.obs;
  final isSeeMoreHistoryBalanceWithdrawList = true.obs;

  final refreshController = RefreshController();

  final isFetch = false.obs;

  @override
  Future<void> onReady() async {
    super.onReady();
    isFetch.value = true;
    await getHistoryBalanceWithdrawList();
    isFetch.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getHistoryBalanceWithdrawList() async {
    isSeeMoreHistoryBalanceWithdrawList.value = true;
    historyBalanceWithdrawPageNum.value = 1;

    historyBalanceWithdrawList.value = await historyBalanceRepository
        .getHistoryWithdrawList(
          size: 10,
          pageNum: historyBalanceWithdrawPageNum.value,
          language: languageServices.languageCodeSystem.value,
        );

    if (historyBalanceWithdrawList.isEmpty) {
      isSeeMoreHistoryBalanceWithdrawList.value = false;
    }
  }

  Future<void> seeMoreHistoryBalanceWithdrawList() async {
    historyBalanceWithdrawPageNum.value += 1;

    var historyBalanceWithdrawList = await historyBalanceRepository
        .getHistoryWithdrawList(
          size: 10,
          pageNum: historyBalanceWithdrawPageNum.value,
          language: languageServices.languageCodeSystem.value,
        );

    if (historyBalanceWithdrawList.isEmpty) {
      isSeeMoreHistoryBalanceWithdrawList.value = false;
    }

    this.historyBalanceWithdrawList.addAll(historyBalanceWithdrawList);
  }
}
