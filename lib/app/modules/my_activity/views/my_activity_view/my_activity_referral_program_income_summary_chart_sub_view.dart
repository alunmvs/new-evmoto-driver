import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/modules/my_activity/controllers/my_activity_controller.dart';

class MyActivityReferralProgramIncomeSummaryChartSubView
    extends GetView<MyActivityController> {
  const MyActivityReferralProgramIncomeSummaryChartSubView({super.key});

  static final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final weeklyIncome = controller.referralProgramWeeklyIncome;
      final barColor = controller.themeColorServices.primaryBlue.value;
      final maxAmount = weeklyIncome
          .map((item) => item.amount)
          .fold(0.0, (max, amount) => amount > max ? amount : max);
      final chartMaxY = maxAmount == 0 ? 1000000.0 : maxAmount * 1.35;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0XFFE1ECFA)),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0XFFF1F4F9),
                border: Border(bottom: BorderSide(color: Color(0XFFE5E5E7))),
              ),
              child: Text(
                'Ringkasan Pendapatan',
                style: controller.typographyServices.bodyLargeBold.value
                    .copyWith(color: const Color(0XFF272727)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 16, 12),
              child: SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    maxY: chartMaxY,
                    minY: 0,
                    alignment: BarChartAlignment.spaceAround,
                    groupsSpace: 12,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(color: Color(0XFFE5E5E5)),
                        bottom: BorderSide(color: Color(0XFFE5E5E5)),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          reservedSize: 28,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= weeklyIncome.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                weeklyIncome[index].label,
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(color: const Color(0XFF272727)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barTouchData: const BarTouchData(enabled: false),
                    barGroups: List.generate(weeklyIncome.length, (index) {
                      final item = weeklyIncome[index];
                      final labelStyle = controller
                          .typographyServices
                          .captionLargeBold
                          .value
                          .copyWith(color: const Color(0XFF272727));
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: item.amount,
                            color: barColor,
                            width: 40,
                            borderRadius: BorderRadius.zero,
                            label: BarChartRodLabel(
                              text: _currencyFormat.format(item.amount),
                              style: labelStyle,
                              offset: const Offset(0, 6),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
