import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';

class HomeBalanceSubView extends GetView<HomeController> {
  const HomeBalanceSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: controller.themeColorServices.sematicColorBlue100.value,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/icon_wallet.svg",
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller
                            .languageServices
                            .language
                            .value
                            .homeYourBalance ??
                        "-",
                    style: controller
                        .typographyServices
                        .captionSmallRegular
                        .value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey500
                              .value,
                        ),
                  ),
                  SizedBox(height: 2),
                  Obx(
                    () => Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(controller.userInfo.value.balance ?? 0.0),
                      style: controller.typographyServices.bodySmallBold.value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey800
                                .value,
                          ),
                    ),
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
