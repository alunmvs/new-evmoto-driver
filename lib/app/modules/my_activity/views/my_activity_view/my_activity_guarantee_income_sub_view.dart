import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/modules/my_activity/controllers/my_activity_controller.dart';

class MyActivityGuaranteeIncomeSubView extends GetView<MyActivityController> {
  const MyActivityGuaranteeIncomeSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.ensureIncomeRuleId.value == null) ...[
                SizedBox(height: 120),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/img_history_activity_not_found.svg",
                        height: 80,
                        width: 80,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Belum Tersedia Gurantee Income",
                        style:
                            controller.typographyServices.bodyLargeBold.value,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Belum ada informasi Gurantee Income untuk saat ini. Silakan cek kembali nanti.",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
              if (controller.ensureIncomeRuleId.value != null) ...[
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    await controller.onTapSelectDateRangeGuaranteeIncome(
                      context: context,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0XFFE6E6E6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${DateFormat('yyyy-MM-dd').format(controller.guaranteeIncomeSelectedDateRange.value!.start)} - ${DateFormat('yyyy-MM-dd').format(controller.guaranteeIncomeSelectedDateRange.value!.end)}",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                        ),
                        SizedBox(width: 8),
                        SvgPicture.asset('assets/icons/icon_calendar_date.svg'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Perkiraan pendapatan",
                      style:
                          controller.typographyServices.bodySmallRegular.value,
                    ),
                    SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp',
                        decimalDigits: 0,
                      ).format(controller.netPaymentOfGuaranteeTotal.value),
                      style: controller
                          .typographyServices
                          .headingMediumBold
                          .value
                          .copyWith(color: Color(0XFF34A853)),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FixedColumnWidth(100),
                          1: FixedColumnWidth(100),
                          2: FixedColumnWidth(100),
                          3: FixedColumnWidth(100),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  color: Color(0XFFECECEE),
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      "",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  color: Color(0XFFECECEE),
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      "Rush Hour",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  color: Color(0XFFECECEE),
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      "Normal Hour",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  color: Color(0XFFECECEE),
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      "Total",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  color: Color(0XFFB5FFC9),
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      "Working Time",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller
                                              .isDropdownWorkingTimeRushHourShow
                                              .value = !controller
                                              .isDropdownWorkingTimeRushHourShow
                                              .value;
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${controller.workingTimeRushHour.value} mins",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallRegular
                                                      .value,
                                                ),
                                              ),
                                              if (controller
                                                  .workingTimeRushHourDropdown
                                                  .isNotEmpty) ...[
                                                SvgPicture.asset(
                                                  controller
                                                              .isDropdownWorkingTimeRushHourShow
                                                              .value ==
                                                          true
                                                      ? 'assets/icons/icon_arrow_up.svg'
                                                      : 'assets/icons/icon_arrow_down.svg',
                                                  width: 15,
                                                  height: 15,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (controller
                                              .isDropdownWorkingTimeRushHourShow
                                              .value ==
                                          true) ...[
                                        SizedBox(height: 8),
                                        for (var detail
                                            in controller
                                                .workingTimeRushHourDropdown) ...[
                                          Text(
                                            detail,
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value,
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller
                                              .isDropdownWorkingTimeNormalHourShow
                                              .value = !controller
                                              .isDropdownWorkingTimeNormalHourShow
                                              .value;
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${controller.workingTimeNormalHour.value} mins",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallRegular
                                                      .value,
                                                ),
                                              ),
                                              if (controller
                                                  .workingTimeNormalHourDropdown
                                                  .isNotEmpty) ...[
                                                SvgPicture.asset(
                                                  controller
                                                              .isDropdownWorkingTimeNormalHourShow
                                                              .value ==
                                                          true
                                                      ? 'assets/icons/icon_arrow_up.svg'
                                                      : 'assets/icons/icon_arrow_down.svg',
                                                  width: 15,
                                                  height: 15,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (controller
                                              .isDropdownWorkingTimeNormalHourShow
                                              .value ==
                                          true) ...[
                                        SizedBox(height: 8),
                                        for (var detail
                                            in controller
                                                .workingTimeNormalHourDropdown) ...[
                                          Text(
                                            detail,
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value,
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "${controller.workingTimeTotal.value} mins",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  color: Color(0XFFB5FFC9),
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      "Guarantee Income/Hour",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller
                                              .isDropdownGuaranteeIncomeHourRushHourShow
                                              .value = !controller
                                              .isDropdownGuaranteeIncomeHourRushHourShow
                                              .value;
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  NumberFormat.currency(
                                                    locale: 'id_ID',
                                                    symbol: 'Rp',
                                                    decimalDigits: 0,
                                                  ).format(
                                                    controller
                                                        .guaranteeIncomeHourRushHour
                                                        .value,
                                                  ),
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallRegular
                                                      .value,
                                                ),
                                              ),
                                              if (controller
                                                  .guaranteeIncomeHourRushHourDropdown
                                                  .isNotEmpty) ...[
                                                SvgPicture.asset(
                                                  controller
                                                              .isDropdownGuaranteeIncomeHourRushHourShow
                                                              .value ==
                                                          true
                                                      ? 'assets/icons/icon_arrow_up.svg'
                                                      : 'assets/icons/icon_arrow_down.svg',
                                                  width: 15,
                                                  height: 15,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (controller
                                              .isDropdownGuaranteeIncomeHourRushHourShow
                                              .value ==
                                          true) ...[
                                        SizedBox(height: 8),
                                        for (var detail
                                            in controller
                                                .guaranteeIncomeHourRushHourDropdown) ...[
                                          Text(
                                            detail,
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value,
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller
                                              .isDropdownGuaranteeIncomeHourNormalHourShow
                                              .value = !controller
                                              .isDropdownGuaranteeIncomeHourNormalHourShow
                                              .value;
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  NumberFormat.currency(
                                                    locale: 'id_ID',
                                                    symbol: 'Rp',
                                                    decimalDigits: 0,
                                                  ).format(
                                                    controller
                                                        .guaranteeIncomeHourNormalHour
                                                        .value,
                                                  ),
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallRegular
                                                      .value,
                                                ),
                                              ),
                                              if (controller
                                                  .guaranteeIncomeHourNormalHourDropdown
                                                  .isNotEmpty) ...[
                                                SvgPicture.asset(
                                                  controller
                                                              .isDropdownGuaranteeIncomeHourNormalHourShow
                                                              .value ==
                                                          true
                                                      ? 'assets/icons/icon_arrow_up.svg'
                                                      : 'assets/icons/icon_arrow_down.svg',
                                                  width: 15,
                                                  height: 15,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (controller
                                              .isDropdownGuaranteeIncomeHourNormalHourShow
                                              .value ==
                                          true) ...[
                                        SizedBox(height: 8),
                                        for (var detail
                                            in controller
                                                .guaranteeIncomeHourNormalHourDropdown) ...[
                                          Text(
                                            detail,
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value,
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ],
                                    ],
                                  ),
                                ),
                              ),

                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(
                                      controller.guaranteeIncomeTotal.value,
                                    ),
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  color: Color(0XFFB5FFC9),
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      "Total Guarantee Income",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(
                                      controller
                                          .totalGuaranteeIncomeRushHour
                                          .value,
                                    ),
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(
                                      controller
                                          .totalGuaranteeIncomeNormalHour
                                          .value,
                                    ),
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(
                                      controller
                                          .totalGuaranteeIncomeTotal
                                          .value,
                                    ),
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FixedColumnWidth(300),
                          1: FixedColumnWidth(100),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  color: Color(0XFFB5FFC9),
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      "Order Income",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                ),
                              ),

                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(controller.orderIncomeTotal.value),
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  color: Color(0XFFB5FFC9),
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      "Net Payment of Guarantee",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(
                                      controller
                                          .netPaymentOfGuaranteeTotal
                                          .value,
                                    ),
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
