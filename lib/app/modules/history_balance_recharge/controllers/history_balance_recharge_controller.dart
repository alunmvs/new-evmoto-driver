import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/history_balance_recharge_model.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class HistoryBalanceRechargeController extends GetxController {
  final HistoryBalanceRepository historyBalanceRepository;

  HistoryBalanceRechargeController({required this.historyBalanceRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final historyBalanceRechargeList = <HistoryBalanceRecharge>[].obs;
  final historyBalanceRechargePageNum = 1.obs;
  final isSeeMoreHistoryBalanceRechargeList = true.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getHistoryBalanceRechargeList();
    isFetch.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getHistoryBalanceRechargeList() async {
    isSeeMoreHistoryBalanceRechargeList.value = true;
    historyBalanceRechargePageNum.value = 1;

    historyBalanceRechargeList.value = await historyBalanceRepository
        .getHistoryRechargeList(
          size: 10,
          pageNum: historyBalanceRechargePageNum.value,
          language: languageServices.languageCodeSystem.value,
        );

    if (historyBalanceRechargeList.isEmpty) {
      isSeeMoreHistoryBalanceRechargeList.value = false;
    }
  }

  Future<void> seeMoreHistoryBalanceRechargeList() async {
    historyBalanceRechargePageNum.value += 1;

    var historyBalanceRechargeList = await historyBalanceRepository
        .getHistoryRechargeList(
          size: 10,
          pageNum: historyBalanceRechargePageNum.value,
          language: languageServices.languageCodeSystem.value,
        );

    if (historyBalanceRechargeList.isEmpty) {
      isSeeMoreHistoryBalanceRechargeList.value = false;
    }

    this.historyBalanceRechargeList.addAll(historyBalanceRechargeList);
  }
}
