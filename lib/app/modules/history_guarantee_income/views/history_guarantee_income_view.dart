import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/data/models/guarantee_income_approval_model.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/views/history_guarantee_income_view/history_guarantee_income_date_list_sub_view.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/views/history_guarantee_income_view/history_guarantee_income_total_today_sub_view.dart';
import 'package:new_evmoto_driver/app/widgets/dashed_line.dart';
import '../controllers/history_guarantee_income_controller.dart';

class HistoryGuaranteeIncomeView
    extends GetView<HistoryGuaranteeIncomeController> {
  const HistoryGuaranteeIncomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Riwayat Guarantee Income",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.backgroundColor.value,
        body: controller.isFetch.value
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  HistoryGuaranteeIncomeTotalTodaySubView(),
                  SizedBox(height: 16),
                  HistoryGuaranteeIncomeDateListSubView(),
                  SizedBox(height: 16),
                  Divider(
                    height: 0,
                    color: controller
                        .themeColorServices
                        .neutralsColorGrey200
                        .value,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            if (controller.isFetchDate.value == true) ...[
                              Column(
                                children: [
                                  SizedBox(height: 16 * 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                            color: controller
                                                .themeColorServices
                                                .primaryBlue
                                                .value,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                            if (controller.isFetchDate.value == false) ...[
                              if (controller
                                      .selectedGuaranteeIncomeApproval
                                      .value
                                      .id ==
                                  null) ...[
                                Column(
                                  children: [
                                    SizedBox(height: 16 * 6),
                                    Image.asset(
                                      "assets/images/img_empty_guarantee_income.png",
                                      height: 80,
                                      width: 80,
                                    ),
                                    SizedBox(height: 16),
                                    Center(
                                      child: Text(
                                        "Tidak Ada Guarantee Income",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value
                                            .copyWith(
                                              color: controller
                                                  .themeColorServices
                                                  .textColor
                                                  .value,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Center(
                                      child: Text(
                                        "Anda belum memiliki pendapatan Guarantee Income pada hari ini",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(
                                              color: controller
                                                  .themeColorServices
                                                  .textColor
                                                  .value,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (controller
                                      .selectedGuaranteeIncomeApproval
                                      .value
                                      .id !=
                                  null) ...[
                                Container(
                                  padding: EdgeInsets.all(16),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Color(0XFFFFFFFF),
                                    border: Border.all(
                                      color: Color(0XFFE5E5E5),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (controller
                                              .selectedGuaranteeIncomeApproval
                                              .value
                                              .approvalStatus ==
                                          0) ...[
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFDE961C),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            "Menunggu Konfirmasi",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey0
                                                      .value,
                                                ),
                                          ),
                                        ),
                                      ],
                                      if (controller
                                              .selectedGuaranteeIncomeApproval
                                              .value
                                              .approvalStatus ==
                                          1) ...[
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0XFF34A853),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            "Sudah Dibayarkan",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey0
                                                      .value,
                                                ),
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 16),
                                      for (var interval
                                          in controller
                                                  .selectedGuaranteeIncomeApproval
                                                  .value
                                                  .intervals ??
                                              <Intervals>[]) ...[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "(${interval.startTime} - ${interval.endTime})",
                                                    style: controller
                                                        .typographyServices
                                                        .bodyLargeRegular
                                                        .value
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                  Text(
                                                    " / jam ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(interval.amountPerHour ?? 0.0)}",
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallRegular
                                                        .value
                                                        .copyWith(
                                                          color: Color(
                                                            0XFF7D7D7D,
                                                          ),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              NumberFormat.currency(
                                                locale: 'id_ID',
                                                symbol: 'Rp',
                                                decimalDigits: 0,
                                              ).format(
                                                interval.earnedMoney ?? 0.0,
                                              ),
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeBold
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFF34A853),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        if (interval !=
                                            controller
                                                .selectedGuaranteeIncomeApproval
                                                .value
                                                .intervals
                                                ?.last) ...[
                                          SizedBox(height: 8),
                                          DashedLine(color: Color(0XFFE5E5E5)),
                                          SizedBox(height: 8),
                                        ],
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
