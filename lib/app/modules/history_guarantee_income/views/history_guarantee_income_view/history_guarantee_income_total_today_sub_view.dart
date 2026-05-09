import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/controllers/history_guarantee_income_controller.dart';

class HistoryGuaranteeIncomeTotalTodaySubView
    extends GetView<HistoryGuaranteeIncomeController> {
  const HistoryGuaranteeIncomeTotalTodaySubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              height: 87,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0XFF0573EA), Color(0XFF034184)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Guarantee Income Hari Ini",
                    style: controller.typographyServices.bodySmallRegular.value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/icon_wallet.svg',
                        color: Colors.white,
                        width: 16,
                        height: 15,
                      ),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp',
                            decimalDigits: 0,
                          ).format(0),
                          style: controller
                              .typographyServices
                              .headingMediumBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                                fontSize: 28,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
