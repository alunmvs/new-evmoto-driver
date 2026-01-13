import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/history_balance_recharge_controller.dart';

class HistoryBalanceRechargeView
    extends GetView<HistoryBalanceRechargeController> {
  const HistoryBalanceRechargeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Riwayat Isi Ulang Saldo",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.backgroundColor.value,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                if (controller.historyBalanceRechargeList.isEmpty) ...[
                  Column(
                    children: [
                      SizedBox(height: 16 * 2),
                      SvgPicture.asset(
                        "assets/images/img_history_activity_not_found.svg",
                        height: 80,
                        width: 80,
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Tidak Memiliki Riwayat Isi Ulang Saldo",
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
                          "Anda belum pernah melakukan isi ulang saldo.",
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
                for (var historyBalanceRecharge
                    in controller.historyBalanceRechargeList) ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0XFFEEEEEE)),
                    ),
                    child: Row(
                      children: [
                        // SizedBox(height: 30, width: 30, child: Placeholder()),
                        // SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "BCA Virtual Account",
                                style: controller
                                    .typographyServices
                                    .bodySmallBold
                                    .value,
                              ),
                              SizedBox(height: 4),
                              Text(
                                historyBalanceRecharge.name ?? "-",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value
                                    .copyWith(color: Color(0XFFB3B3B3)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: '-Rp',
                            decimalDigits: 0,
                          ).format(historyBalanceRecharge.amount),
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .redColor
                                    .value,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
