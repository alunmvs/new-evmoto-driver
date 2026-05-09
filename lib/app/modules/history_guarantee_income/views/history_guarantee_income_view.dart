import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/views/history_guarantee_income_view/history_guarantee_income_card_sub_view.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/views/history_guarantee_income_view/history_guarantee_income_date_list_sub_view.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/views/history_guarantee_income_view/history_guarantee_income_total_today_sub_view.dart';

import '../controllers/history_guarantee_income_controller.dart';

class HistoryGuaranteeIncomeView
    extends GetView<HistoryGuaranteeIncomeController> {
  const HistoryGuaranteeIncomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Guarantee Income",
          style: controller.typographyServices.bodyLargeBold.value,
        ),
        centerTitle: false,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        surfaceTintColor:
            controller.themeColorServices.neutralsColorGrey0.value,
      ),
      backgroundColor: controller.themeColorServices.backgroundColor.value,
      body: Column(
        children: [
          SizedBox(height: 16),
          HistoryGuaranteeIncomeTotalTodaySubView(),
          SizedBox(height: 16),
          HistoryGuaranteeIncomeDateListSubView(),
          SizedBox(height: 16),
          Divider(
            height: 0,
            color: controller.themeColorServices.neutralsColorGrey200.value,
          ),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (var i = 0; i < 10; i++) ...[
                      HistoryGuaranteeIncomeCardSubView(),
                      SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
