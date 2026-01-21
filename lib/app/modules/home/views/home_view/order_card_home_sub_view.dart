import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';

class OrderCardHomeSubView extends GetView<HomeController> {
  final Order order;

  const OrderCardHomeSubView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(
          Routes.ORDER_DETAIL,
          arguments: {"order_id": order.id, "order_type": order.type},
        );
        await controller.refreshAll();
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: controller.themeColorServices.neutralsColorGrey0.value,
          border: Border.all(
            color: controller.themeColorServices.neutralsColorGrey200.value,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 27,
                  height: 27,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_passenger.svg",
                        width: 11.7,
                        height: 14.17,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.user ?? "-",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(
                              color:
                                  controller.themeColorServices.textColor.value,
                            ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_star.svg",
                            width: 9.17,
                            height: 10,
                            color: controller
                                .themeColorServices
                                .sematicColorYellow400
                                .value,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "5.0 (0)",
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/icons/icon_card_origin.svg",
                  width: 27,
                  height: 27,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.languageServices.language.value.pickedUp ??
                            "-",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .imageUploadVerticalDividerColor
                                  .value,
                            ),
                      ),
                      Text(
                        order.startAddress ?? "-",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(
                              color:
                                  controller.themeColorServices.textColor.value,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 27,
                  height: 27,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_card_destination.svg",
                        width: 17,
                        height: 17,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller
                                .languageServices
                                .language
                                .value
                                .destinationLocation ??
                            "-",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .imageUploadVerticalDividerColor
                                  .value,
                            ),
                      ),
                      Text(
                        order.endAddress ?? "-",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(
                              color:
                                  controller.themeColorServices.textColor.value,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(
              height: 0,
              color: controller.themeColorServices.neutralsColorGrey200.value,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.languageServices.language.value.totalCost ?? "-",
                  style: controller.typographyServices.bodySmallRegular.value
                      .copyWith(
                        color: controller.themeColorServices.textColor.value,
                      ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(order.orderMoney ?? 0.0),
                  style: controller.typographyServices.bodySmallBold.value
                      .copyWith(
                        color: controller.themeColorServices.textColor.value,
                      ),
                ),
              ],
            ),
            if (order.state == 1) ...[
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: LoaderElevatedButton(
                      onPressed: () async {
                        await controller.onTapGrabDialog(order: order);
                      },
                      child: Text(
                        "Ambil",
                        style: controller.typographyServices.bodySmallBold.value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
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
      ),
    );
  }
}
