import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/controllers/history_guarantee_income_controller.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/views/history_guarantee_income_view/history_guarantee_income_card_sub_view/history_guarantee_income_card_summary_sub_view.dart';

class HistoryGuaranteeIncomeCardSubView
    extends GetView<HistoryGuaranteeIncomeController> {
  HistoryGuaranteeIncomeCardSubView({super.key});

  final isSeeDetailOpen = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0XFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0XFFE5E5E5)),
            ),
            child: Column(
              children: [
                HistoryGuaranteeIncomeCardSummarySubView(enableBorder: false),
                GestureDetector(
                  onTap: () {
                    isSeeDetailOpen.value = !isSeeDetailOpen.value;
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    child: Column(
                      children: [
                        if (isSeeDetailOpen.value == true) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Guarantee Income",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(color: Color(0XFF7D7D7D)),
                              ),
                              Text(
                                "+ Rp20.000",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order Income",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(color: Color(0XFF7D7D7D)),
                              ),
                              Text(
                                "- Rp10.000",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(color: Color(0XFFE11C0B)),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Net Gurantee",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(color: Color(0XFF7D7D7D)),
                              ),
                              Text(
                                "Rp10.000",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0XFF34A853),
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Lihat Detail",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value,
                            ),
                            SizedBox(width: 8),
                            if (isSeeDetailOpen.value == false) ...[
                              SvgPicture.asset(
                                'assets/icons/icon_arrow_down_1.svg',
                                width: 10.42,
                                height: 6,
                              ),
                            ],
                            if (isSeeDetailOpen.value == true) ...[
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..scale(1.0, -1.0),
                                child: SvgPicture.asset(
                                  'assets/icons/icon_arrow_down_1.svg',
                                  width: 10.42,
                                  height: 6,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          HistoryGuaranteeIncomeCardSummarySubView(enableBorder: true),
        ],
      ),
    );
  }
}
