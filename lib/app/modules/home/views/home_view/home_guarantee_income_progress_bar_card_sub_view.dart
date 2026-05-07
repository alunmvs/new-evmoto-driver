import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';

class HomeGuaranteeIncomeProgressBarCardSubView
    extends GetView<HomeController> {
  const HomeGuaranteeIncomeProgressBarCardSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
      decoration: BoxDecoration(
        color: Color(0XFFFFEFC0),
        border: Border.all(color: Color(0XFFEFDFAF), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "(${controller.startTimeAdjustTz.value} - ${controller.endTimeAdjustTz.value})",
            style: controller.typographyServices.bodyLargeBold.value.copyWith(
              fontWeight: FontWeight.w900,
              color: Color(0XFF6E3500),
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Jaminan Pendapatan Hari Ini",
            style: controller.typographyServices.captionLargeRegular.value
                .copyWith(color: Color(0XFF624A06)),
          ),
          SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              controller.isActiveGuaranteeIncomeProgressBarOpen.value = true;
            },
            child: Container(
              height: 6 + 12,
              width: 100,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/icon_arrow_down_1.svg',
                    width: 10.42,
                    height: 6,
                    color: Color(0XFF553F00),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
