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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Perkiraan Pendapatan",
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await controller.onTapSelectDateRangeGuaranteeIncome(
                          context: context,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          border: Border.all(color: Color(0XFFEEEEEE)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/icon_calendar_date.svg',
                            ),
                            SizedBox(width: 8),
                            Text(
                              DateFormat('dd MMMM yyyy').format(
                                controller
                                    .guaranteeIncomeSelectedDateRange
                                    .value!
                                    .start,
                              ),
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0XFFEEEEEE)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(
                              controller.netPaymentOfGuaranteeTotal.value,
                            ),
                            style: controller
                                .typographyServices
                                .headingMediumBold
                                .value
                                .copyWith(
                                  fontSize: 28,
                                  color: Color(0XFF028225),
                                ),
                          ),
                          Text(
                            '*Syarat dan ketentuan berlaku',
                            style: controller
                                .typographyServices
                                .captionLargeRegular
                                .value
                                .copyWith(color: Color(0XFFB3B3B3)),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/images/img_guarantee_income.png',
                        width: 75,
                        height: 72,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder.all(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0XFFEEEEEE),
                        ),
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
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFF319758),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "\n",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFF319758),
                                  ),
                                  child: Text(
                                    "Rush\nHour",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFF319758),
                                  ),
                                  child: Text(
                                    "Normal\nHour",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFF319758),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Total\n",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF0FAF0),
                                  ),
                                  child: Text(
                                    "Working Time",
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
                                                      .bodySmallBold
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
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFD8FFE2),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var detail
                                                  in controller
                                                      .workingTimeRushHourDropdown) ...[
                                                Text(
                                                  detail,
                                                  style: controller
                                                      .typographyServices
                                                      .captionSmallBold
                                                      .value
                                                      .copyWith(
                                                        color: Color(
                                                          0XFF0D6B26,
                                                        ),
                                                      ),
                                                ),
                                                if (controller
                                                        .workingTimeRushHourDropdown
                                                        .last !=
                                                    detail) ...[
                                                  SizedBox(height: 8),
                                                ],
                                              ],
                                            ],
                                          ),
                                        ),
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
                                                      .bodySmallBold
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
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFD8FFE2),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
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
                                                if (controller
                                                        .workingTimeNormalHourDropdown
                                                        .last !=
                                                    detail) ...[
                                                  SizedBox(height: 8),
                                                ],
                                              ],
                                            ],
                                          ),
                                        ),
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
                                        .bodySmallBold
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
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF0FAF0),
                                  ),
                                  child: Text(
                                    "Guarantee Income/Hour",
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
                                                      .bodySmallBold
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
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFD8FFE2),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var detail
                                                  in controller
                                                      .guaranteeIncomeHourRushHourDropdown) ...[
                                                Text(
                                                  detail,
                                                  style: controller
                                                      .typographyServices
                                                      .captionSmallBold
                                                      .value
                                                      .copyWith(
                                                        color: Color(
                                                          0XFF0D6B26,
                                                        ),
                                                      ),
                                                ),
                                                if (controller
                                                        .guaranteeIncomeHourRushHourDropdown
                                                        .last !=
                                                    detail) ...[
                                                  SizedBox(height: 8),
                                                ],
                                              ],
                                            ],
                                          ),
                                        ),
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
                                                      .bodySmallBold
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
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFD8FFE2),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var detail
                                                  in controller
                                                      .guaranteeIncomeHourNormalHourDropdown) ...[
                                                Text(
                                                  detail,
                                                  style: controller
                                                      .typographyServices
                                                      .captionSmallBold
                                                      .value
                                                      .copyWith(
                                                        color: Color(
                                                          0XFF0D6B26,
                                                        ),
                                                      ),
                                                ),
                                                if (controller
                                                        .guaranteeIncomeHourNormalHourDropdown
                                                        .last !=
                                                    detail) ...[
                                                  SizedBox(height: 8),
                                                ],
                                              ],
                                            ],
                                          ),
                                        ),
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
                                        .bodySmallBold
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
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF0FAF0),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Total Guarantee Income",
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
                                          .totalGuaranteeIncomeRushHour
                                          .value,
                                    ),
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
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
                                        .bodySmallBold
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
                                        .bodySmallBold
                                        .value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Table(
                        border: TableBorder.all(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0XFFEEEEEE),
                        ),
                        columnWidths: {
                          0: FixedColumnWidth(300),
                          1: FixedColumnWidth(100),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFF319758),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Revenue Summary",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFF319758),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Total",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    "Order Income",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(12),
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
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF0FAF0),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Net Payment of Guarantee",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF0FAF0),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
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
                      SizedBox(height: 16),
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
