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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pendapatan Dengan Kupon",
                    style: controller.typographyServices.bodySmallBold.value,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await controller.onTapSelectDateRangeCouponIncome(
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
                                  .couponIncomeSelectedDateRange
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
                          ).format(controller.couponIncomeCouponIncome.value),
                          style: controller
                              .typographyServices
                              .headingMediumBold
                              .value
                              .copyWith(fontSize: 28, color: Color(0XFF028225)),
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
                      'assets/images/img_coupon_income.png',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                      border: TableBorder.all(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0XFFEEEEEE),
                      ),
                      columnWidths: {
                        0: FixedColumnWidth(150),
                        1: FixedColumnWidth(175),
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
                                  "Jenis Pendapatan",
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
                                  "Pendapatan",
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
                                  ).format(
                                    controller.orderIncomeCouponIncome.value,
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
                                child: Text(
                                  "Cash Income",
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
                                  ).format(
                                    controller.cashIncomeCouponIncome.value,
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
                                  "Coupon Income",
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
                                    controller.couponIncomeCouponIncome.value,
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
                  ],
                ),
              ),
              if (controller.couponIncomeTableData.isNotEmpty) ...[
                SizedBox(height: 16),
                Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          border: TableBorder.all(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0XFFEEEEEE),
                          ),
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
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Color(0XFF319758),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "Date",
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
                                      "Order Time",
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
                                      "Pick Up Point",
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
                                      "Destination",
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
                                      "Cash Income",
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
                                      "Coupon Income",
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
                                      "Order Amount",
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
                            for (var data
                                in controller.couponIncomeTableData) ...[
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft:
                                              controller
                                                      .couponIncomeTableData
                                                      .last ==
                                                  data
                                              ? Radius.circular(12)
                                              : Radius.zero,
                                        ),
                                      ),
                                      child: Text(
                                        data[0],
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
                                        data[1],
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
                                        data[2],
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
                                        data[3],
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
                                        data[4],
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
                                        data[5],
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
                                        borderRadius: BorderRadius.only(
                                          bottomRight:
                                              controller
                                                      .couponIncomeTableData
                                                      .last ==
                                                  data
                                              ? Radius.circular(12)
                                              : Radius.zero,
                                        ),
                                      ),
                                      child: Text(
                                        data[6],
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
