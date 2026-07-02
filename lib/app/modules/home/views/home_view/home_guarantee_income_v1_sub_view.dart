import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/modules/home/views/home_view/home_guarantee_income_v1_sub_view/home_guarantee_income_area_in_draggable_scrollable_sheet.dart';
import 'package:new_evmoto_driver/app/widgets/draggable_scrollable_sheet/home_guarantee_income_area_out_after_order_draggable_scrollable_sheet.dart';
import 'package:new_evmoto_driver/app/widgets/draggable_scrollable_sheet/home_guarantee_income_area_out_no_order_draggable_scrollable_sheet.dart';

class HomeGuaranteeIncomeV1SubView extends GetView<HomeController> {
  const HomeGuaranteeIncomeV1SubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.ensureIncomeRuleId.value != null &&
              controller.guaranteeIncomeProgressBarList.isNotEmpty) ...[
            if (controller.guaranteeIncomeProgressBarList.first.type ==
                    'OUTSIDE_ONGOING_ORDER' ||
                controller.guaranteeIncomeProgressBarList.first.type ==
                    'OUTSIDE_NO_ORDER') ...[
              HomeGuaranteeIncomeAreaOutNoOrderDraggableScrollableSheet(),
            ],
            if (controller.guaranteeIncomeProgressBarList.first.type ==
                'OUTSIDE_AFTER_ORDER') ...[
              HomeGuaranteeIncomeAreaOutAfterOrderDraggableScrollableSheet(),
            ],
            if (controller.guaranteeIncomeProgressBarList.first.type ==
                'INSIDE') ...[
              HomeGuaranteeIncomeAreaInDraggableScrollableSheet(),
            ],
          ],
        ],
      ),
    );
  }
}
