import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/data/models/history_balance_revenue_model.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class HistoryBalanceRevenueController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final HistoryBalanceRepository historyBalanceRepository;

  HistoryBalanceRevenueController({required this.historyBalanceRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  late TabController tabController;

  final historyBalanceRevenue = HistoryBalanceRevenue().obs;
  final historyBalancePageNum = 1.obs;
  final isSeeMoreHistoryBalance = true.obs;

  final indexBanner = 0.0.obs;

  final recommendationDateTimeList = <DateTime>[
    for (int i = 0; i < 7; i++) DateTime.now().subtract(Duration(days: i)),
  ].obs;
  final selectedDateTime = DateTime.now().obs;

  final index = 0.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      index.value = tabController.index;
    });
    await getHistoryBalanceRevenue();
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

  bool isDateSelected(DateTime date1) {
    var date2 = selectedDateTime.value;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> getHistoryBalanceRevenue() async {
    isSeeMoreHistoryBalance.value = true;
    historyBalancePageNum.value = 1;

    historyBalanceRevenue.value = await historyBalanceRepository
        .getHistoryRevenueList(
          size: 10,
          pageNum: historyBalancePageNum.value,
          language: languageServices.languageCodeSystem.value,
          startTime: DateFormat('yyyy-MM-dd').format(selectedDateTime.value),
          endTime: DateFormat('yyyy-MM-dd').format(selectedDateTime.value),
        );

    if (historyBalanceRevenue.value.revenue?.isEmpty ?? true) {
      isSeeMoreHistoryBalance.value = false;
    }
  }
}
