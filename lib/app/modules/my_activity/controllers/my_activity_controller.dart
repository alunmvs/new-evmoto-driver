import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/data/models/activity_model.dart';
import 'package:new_evmoto_driver/app/data/models/coupon_income_model.dart'
    hide Daily;
import 'package:new_evmoto_driver/app/data/models/guarantee_income_model.dart';
import 'package:new_evmoto_driver/app/repositories/activity_repository.dart';
import 'package:new_evmoto_driver/app/repositories/guarantee_income_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';

class MyActivityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ActivityRepository activityRepository;
  final GuaranteeIncomeRepository guaranteeIncomeRepository;

  MyActivityController({
    required this.activityRepository,
    required this.guaranteeIncomeRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final userServices = Get.find<UserServices>();

  TabController? tabController;
  final indexTabBar = 0.obs;

  final activityList = <Activity>[].obs;
  final pageNum = 1.obs;
  final size = 10.obs;
  final isSeeMoreActivityList = true.obs;

  final guaranteeIncome = GuaranteeIncome().obs;
  final couponIncome = CouponIncome().obs;

  // Guarantee Income Data Table (Static)
  final workingTimeRushHour = 0.obs;
  final workingTimeNormalHour = 0.obs;
  final workingTimeTotal = 0.obs;

  final guaranteeIncomeHourRushHour = 0.obs;
  final guaranteeIncomeHourNormalHour = 0.obs;
  final guaranteeIncomeTotal = 0.0.obs;

  final totalGuaranteeIncomeRushHour = 0.0.obs;
  final totalGuaranteeIncomeNormalHour = 0.0.obs;
  final totalGuaranteeIncomeTotal = 0.0.obs;

  final orderIncomeRushHour = 0.0.obs;
  final orderIncomeNormalHour = 0.0.obs;
  final orderIncomeTotal = 0.0.obs;

  final netPaymentOfGuaranteeTotal = 0.0.obs;

  final workingTimeRushHourDropdown = <String>[].obs;
  final workingTimeNormalHourDropdown = <String>[].obs;
  final guaranteeIncomeHourRushHourDropdown = <String>[].obs;
  final guaranteeIncomeHourNormalHourDropdown = <String>[].obs;

  final isDropdownWorkingTimeRushHourShow = false.obs;
  final isDropdownWorkingTimeNormalHourShow = false.obs;
  final isDropdownGuaranteeIncomeHourRushHourShow = false.obs;
  final isDropdownGuaranteeIncomeHourNormalHourShow = false.obs;

  // Coupon Income
  final orderIncomeCouponIncome = 0.0.obs;
  final cashIncomeCouponIncome = 0.0.obs;
  final couponIncomeCouponIncome = 0.0.obs;

  final couponIncomeTableData = [].obs;

  // Filter
  final Rx<DateTimeRange?> guaranteeIncomeSelectedDateRange =
      Rx<DateTimeRange?>(null);
  final Rx<DateTimeRange?> couponIncomeSelectedDateRange = Rx<DateTimeRange?>(
    null,
  );

  final ensureIncomeRuleId = Rx<int?>(null);

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController ??= TabController(length: 2, vsync: this);

    guaranteeIncomeSelectedDateRange.value = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );
    couponIncomeSelectedDateRange.value = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );

    await Future.wait([getEnsureIncomeRuleId()]);
    await Future.wait([getGuaranteeIncome(), getCouponIncome()]);
    await Future.wait([
      generateGuaranteeIncomeTableData(),
      generateCouponIncomeTableData(),
    ]);

    tabController!.addListener(() {
      indexTabBar.value = tabController!.index;
    });
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

  Future<void> getEnsureIncomeRuleId() async {
    ensureIncomeRuleId.value = await guaranteeIncomeRepository
        .getActiveEnsureIncomeRuleId();
  }

  Future<void> onTapSelectDateRangeGuaranteeIncome({
    required BuildContext context,
  }) async {
    var result = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: guaranteeIncomeSelectedDateRange.value?.start,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: themeColorServices.primaryBlue.value,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: themeColorServices.primaryBlue.value,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerForegroundColor: Colors.black,
              headerBackgroundColor: Colors.white,
              rangePickerBackgroundColor: Colors.white,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: Center(child: child),
        );
      },
    );

    if (result != null) {
      guaranteeIncomeSelectedDateRange.value = DateTimeRange(
        start: result,
        end: result,
      );
      await getGuaranteeIncome();
      await generateGuaranteeIncomeTableData();
    }
  }

  Future<void> onTapSelectDateRangeCouponIncome({
    required BuildContext context,
  }) async {
    var result = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: couponIncomeSelectedDateRange.value?.start,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: themeColorServices.primaryBlue.value,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: themeColorServices.primaryBlue.value,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerForegroundColor: Colors.black,
              headerBackgroundColor: Colors.white,
              rangePickerBackgroundColor: Colors.white,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: Center(child: child),
        );
      },
    );

    if (result != null) {
      couponIncomeSelectedDateRange.value = DateTimeRange(
        start: result,
        end: result,
      );
      await getCouponIncome();
      await generateCouponIncomeTableData();
    }
  }

  Future<void> getGuaranteeIncome() async {
    if (ensureIncomeRuleId.value != null) {
      guaranteeIncome.value = await guaranteeIncomeRepository
          .getGuaranteeIncome(
            driverId: userServices.userInfo.value.id,
            ensureIncomeRuleId: ensureIncomeRuleId.value,
            startDate: guaranteeIncomeSelectedDateRange.value != null
                ? DateFormat(
                    'yyyy-MM-dd',
                  ).format(guaranteeIncomeSelectedDateRange.value!.start)
                : null,
            endDate: guaranteeIncomeSelectedDateRange.value != null
                ? DateFormat(
                    'yyyy-MM-dd',
                  ).format(guaranteeIncomeSelectedDateRange.value!.end)
                : null,
          );
    }

    workingTimeRushHour.value = 0;
    workingTimeNormalHour.value = 0;
    workingTimeTotal.value = 0;

    guaranteeIncomeHourRushHour.value = 0;
    guaranteeIncomeHourNormalHour.value = 0;
    guaranteeIncomeTotal.value = 0;

    totalGuaranteeIncomeRushHour.value = 0;
    totalGuaranteeIncomeNormalHour.value = 0;
    totalGuaranteeIncomeTotal.value = 0;

    orderIncomeRushHour.value = 0;
    orderIncomeNormalHour.value = 0;
    orderIncomeTotal.value = 0;

    netPaymentOfGuaranteeTotal.value = 0;

    workingTimeRushHourDropdown.value = [];
    workingTimeNormalHourDropdown.value = [];
    guaranteeIncomeHourRushHourDropdown.value = [];
    guaranteeIncomeHourNormalHourDropdown.value = [];

    isDropdownWorkingTimeRushHourShow.value = false;
    isDropdownWorkingTimeNormalHourShow.value = false;
    isDropdownGuaranteeIncomeHourRushHourShow.value = false;
    isDropdownGuaranteeIncomeHourNormalHourShow.value = false;
  }

  Future<void> getCouponIncome() async {
    couponIncome.value = await guaranteeIncomeRepository.getCouponIncome(
      driverId: userServices.userInfo.value.id,
      startDate: couponIncomeSelectedDateRange.value != null
          ? DateFormat(
              'yyyy-MM-dd',
            ).format(couponIncomeSelectedDateRange.value!.start)
          : null,
      endDate: couponIncomeSelectedDateRange.value != null
          ? DateFormat(
              'yyyy-MM-dd',
            ).format(couponIncomeSelectedDateRange.value!.end)
          : null,
    );

    orderIncomeCouponIncome.value = 0;
    cashIncomeCouponIncome.value = 0;
    couponIncomeCouponIncome.value = 0;

    couponIncomeTableData.value = [];
  }

  Future<void> generateGuaranteeIncomeTableData() async {
    var sumGuaranteeIncomeRushHour = 0.0;
    var countGuaranteeIncomeRushHour = 0;
    var sumGuaranteeIncomeNormalHour = 0.0;
    var countGuaranteeIncomeNormalHour = 0;

    for (var daily in guaranteeIncome.value.daily ?? <Daily>[]) {
      var dailySumGuaranteeIncomeRushHour = 0.0;
      var dailyCountGuaranteeIncomeRushHour = 0;
      var dailySumGuaranteeIncomeNormalHour = 0.0;
      var dailyCountGuaranteeIncomeNormalHour = 0;

      var logOnlineOfflineTextListRushHour = [];
      var logOnlineOfflineTextListNormalHour = [];

      for (var period in daily.periods ?? <Periods>[]) {
        // Working Hour
        if (period.hourType == 2) {
          workingTimeRushHour.value += period.onlineDurationMinutes ?? 0;
        }
        if (period.hourType == 1) {
          workingTimeNormalHour.value += period.onlineDurationMinutes ?? 0;
        }
        workingTimeTotal.value += period.onlineDurationMinutes ?? 0;

        // Guarantee Income / Hour
        if (period.hourType == 2) {
          // sumGuaranteeIncomeRushHour +=
          //     (period.amount! /
          //             getMinutesDifference(
          //               period.startTime!,
          //               period.endTime!,
          //             ))
          //         .round();
          sumGuaranteeIncomeRushHour += period.guaranteedAmountPerHour ?? 0.0;
          countGuaranteeIncomeRushHour += 1;

          dailySumGuaranteeIncomeRushHour +=
              period.guaranteedAmountPerHour ?? 0.0;
          dailyCountGuaranteeIncomeRushHour += 1;
        }
        if (period.hourType == 1) {
          // sumGuaranteeIncomeNormalHour +=
          //     (period.amount! /
          //             getMinutesDifference(
          //               period.startTime!,
          //               period.endTime!,
          //             ))
          //         .round();
          sumGuaranteeIncomeNormalHour += period.guaranteedAmountPerHour ?? 0.0;
          countGuaranteeIncomeNormalHour += 1;

          dailySumGuaranteeIncomeNormalHour +=
              period.guaranteedAmountPerHour ?? 0.0;
          dailyCountGuaranteeIncomeNormalHour += 1;
        }

        // Total Guarantee Income
        if (period.hourType == 2) {
          totalGuaranteeIncomeRushHour.value += period.guaranteedAmount ?? 0.0;
        }
        if (period.hourType == 1) {
          totalGuaranteeIncomeNormalHour.value +=
              period.guaranteedAmount ?? 0.0;
        }
        totalGuaranteeIncomeTotal.value += period.guaranteedAmount ?? 0.0;

        // Order Income
        if (period.hourType == 2) {
          orderIncomeRushHour.value += period.orderIncome ?? 0.0;
        }
        if (period.hourType == 1) {
          orderIncomeNormalHour.value += period.orderIncome ?? 0.0;
        }
        // orderIncomeTotal.value += period.orderIncome ?? 0.0;

        // Log Online Offline
        if (period.hourType == 2) {
          // for (var logOnlineOffline in daily.logOnlineOffline ?? <String>[]) {
          //   logOnlineOfflineTextListRushHour.add("• $logOnlineOffline");
          // }

          for (var onlineTime in period.onlineTimes ?? <OnlineTimes>[]) {
            logOnlineOfflineTextListRushHour.add(
              "• ${onlineTime.start} - ${onlineTime.end}",
            );
          }
        }
        if (period.hourType == 1) {
          // for (var logOnlineOffline in daily.logOnlineOffline ?? <String>[]) {
          //   logOnlineOfflineTextListNormalHour.add("• $logOnlineOffline");
          // }

          for (var onlineTime in period.onlineTimes ?? <OnlineTimes>[]) {
            logOnlineOfflineTextListNormalHour.add(
              "${onlineTime.start} - ${onlineTime.end}",
            );
          }
        }
      }

      if (dailyCountGuaranteeIncomeRushHour != 0) {
        var dailyGuaranteeIncomeHourRushHour =
            (dailySumGuaranteeIncomeRushHour /
                    dailyCountGuaranteeIncomeRushHour)
                .round();

        guaranteeIncomeHourRushHourDropdown.add(
          NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp',
            decimalDigits: 0,
          ).format(dailyGuaranteeIncomeHourRushHour),
        );
      }
      if (dailyCountGuaranteeIncomeNormalHour != 0) {
        var dailyGuaranteeIncomeHourNormalHour =
            (dailySumGuaranteeIncomeNormalHour /
                    dailyCountGuaranteeIncomeNormalHour)
                .round();

        guaranteeIncomeHourNormalHourDropdown.add(
          NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp',
            decimalDigits: 0,
          ).format(dailyGuaranteeIncomeHourNormalHour),
        );
      }

      if (logOnlineOfflineTextListRushHour.isNotEmpty &&
          daily.subsidyEligible != false) {
        workingTimeRushHourDropdown.add(
          logOnlineOfflineTextListRushHour.join("\n"),
        );
      }

      if (logOnlineOfflineTextListNormalHour.isNotEmpty &&
          daily.subsidyEligible != false) {
        workingTimeNormalHourDropdown.add(
          logOnlineOfflineTextListNormalHour.join("\n"),
        );
      }

      orderIncomeTotal.value += daily.totalDayOrderIncome ?? 0.0;
      netPaymentOfGuaranteeTotal.value += daily.dailyNetGuaranteedIncome ?? 0.0;
      guaranteeIncomeTotal.value += daily.totalDayGuaranteedAmount ?? 0.0;
    }
    if (countGuaranteeIncomeRushHour != 0) {
      guaranteeIncomeHourRushHour.value =
          (sumGuaranteeIncomeRushHour / countGuaranteeIncomeRushHour).round();
    }
    if (countGuaranteeIncomeNormalHour != 0) {
      guaranteeIncomeHourNormalHour.value =
          (sumGuaranteeIncomeNormalHour / countGuaranteeIncomeNormalHour)
              .round();
    }
    // guaranteeIncomeTotal.value =
    //     guaranteeIncomeHourRushHour.value + guaranteeIncomeHourNormalHour.value;

    // netPaymentOfGuaranteeTotal.value =
    //     (totalGuaranteeIncomeTotal.value - orderIncomeTotal.value) <= 0
    //     ? 0
    //     : (totalGuaranteeIncomeTotal.value - orderIncomeTotal.value);
  }

  Future<void> generateCouponIncomeTableData() async {
    if (couponIncome.value.daily != null) {
      for (var daily in couponIncome.value.daily!) {
        for (var order in daily.orders!) {
          orderIncomeCouponIncome.value += order.orderIncome ?? 0.0;
          cashIncomeCouponIncome.value += order.cashIncome ?? 0.0;
          couponIncomeCouponIncome.value += order.couponIncome ?? 0.0;

          couponIncomeTableData.add([
            daily.date,
            order.orderTime ?? "-",
            order.startAddressName ?? "-",
            order.endAddressName ?? "-",
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(order.cashIncome),
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(order.couponIncome),
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(order.orderIncome),
          ]);
        }
      }
    }
  }

  int getMinutesDifference(String start, String end) {
    final startParts = start.split(':');
    final endParts = end.split(':');

    final startHour = int.parse(startParts[0]);
    final startMinute = int.parse(startParts[1]);

    final endHour = int.parse(endParts[0]);
    final endMinute = int.parse(endParts[1]);

    final startTotalMinutes = startHour * 60 + startMinute;
    final endTotalMinutes = endHour * 60 + endMinute;

    return endTotalMinutes - startTotalMinutes;
  }

  Future<void> getActivityList() async {
    pageNum.value = 1;
    isSeeMoreActivityList.value = true;

    activityList.value = await activityRepository.getActivityList(
      language: languageServices.languageCodeSystem.value,
      pageNum: pageNum.value,
      size: size.value,
    );

    if (activityList.isEmpty) {
      isSeeMoreActivityList.value = false;
    }
  }

  Future<void> seeMoreActivityList() async {
    pageNum.value += 1;

    var activityList = await activityRepository.getActivityList(
      language: languageServices.languageCodeSystem.value,
      pageNum: pageNum.value,
      size: size.value,
    );

    this.activityList.addAll(activityList);

    if (activityList.isEmpty) {
      isSeeMoreActivityList.value = false;
    }
  }
}
