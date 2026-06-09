import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/modules/my_activity/controllers/my_activity_controller.dart';

class MyActivityCouponIncomeSubView extends GetView<MyActivityController> {
  const MyActivityCouponIncomeSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  await controller.onTapSelectDateRangeCouponIncome(
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
                        "${DateFormat('yyyy-MM-dd').format(controller.couponIncomeSelectedDateRange.value!.start)} - ${DateFormat('yyyy-MM-dd').format(controller.couponIncomeSelectedDateRange.value!.end)}",
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                      border: TableBorder.all(),
                      columnWidths: {
                        0: FixedColumnWidth(150),
                        1: FixedColumnWidth(150),
                        2: FixedColumnWidth(150),
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
                                color: Color(0XFFECECEE),
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: Text(
                                    "Cash Income",
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
                                    "Coupon Income",
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
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(
                                      controller.orderIncomeCouponIncome.value,
                                    ),
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
                                child: Center(
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(
                                      controller.cashIncomeCouponIncome.value,
                                    ),
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
                                child: Center(
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(
                                      controller.couponIncomeCouponIncome.value,
                                    ),
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
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              if (controller.couponIncomeTableData.isNotEmpty) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FixedColumnWidth(150),
                          1: FixedColumnWidth(150),
                          2: FixedColumnWidth(150),
                          3: FixedColumnWidth(150),
                          4: FixedColumnWidth(150),
                          5: FixedColumnWidth(150),
                          6: FixedColumnWidth(150),
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
                                      "Date",
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
                                      "Order Time",
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
                                      "Pick Up Point",
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
                                      "Destination",
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
                                      "Cash Income",
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
                                      "Coupon Income",
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
                                      "Order Amount",
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
                          for (var data
                              in controller.couponIncomeTableData) ...[
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(
                                        data[0],
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
                                    child: Center(
                                      child: Text(
                                        data[1],
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
                                    child: Center(
                                      child: Text(
                                        data[2],
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
                                    child: Center(
                                      child: Text(
                                        data[3],
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
                                    child: Center(
                                      child: Text(
                                        data[4],
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
                                    child: Center(
                                      child: Text(
                                        data[5],
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
                                    child: Center(
                                      child: Text(
                                        data[6],
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
                          ],
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
