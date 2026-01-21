import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/account_service_controller.dart';

class AccountServiceView extends GetView<AccountServiceController> {
  const AccountServiceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.selectService ?? "-",
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
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        controller
                                .languageServices
                                .language
                                .value
                                .selectService ??
                            "-",
                        style:
                            controller.typographyServices.bodySmallBold.value,
                      ),
                      SizedBox(height: 8),
                      for (var updatedServiceOrder
                          in controller.serviceOrderList) ...[
                        GestureDetector(
                          onTap: () {
                            if (updatedServiceOrder.updatedState == 2) {
                              updatedServiceOrder.updatedState = 1;
                            } else {
                              updatedServiceOrder.updatedState = 2;
                            }
                            controller.serviceOrderList.refresh();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              border: Border.all(
                                color: updatedServiceOrder.updatedState == 2
                                    ? Color(0XFFB3B3B3)
                                    : Color(0XFFE8E8E8),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      updatedServiceOrder.name ?? "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color:
                                                updatedServiceOrder
                                                        .updatedState ==
                                                    2
                                                ? controller
                                                      .themeColorServices
                                                      .textColor
                                                      .value
                                                : Color(0XFFB3B3B3),
                                          ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Checkbox(
                                        value:
                                            updatedServiceOrder.updatedState ==
                                            2,
                                        activeColor: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                        side: BorderSide(
                                          color: Color(0XFFB3B3B3),
                                        ),
                                        onChanged: (value) {
                                          if (value == false) {
                                            updatedServiceOrder.updatedState =
                                                1;
                                          } else {
                                            updatedServiceOrder.updatedState =
                                                2;
                                          }
                                          controller.serviceOrderList.refresh();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: controller.isFetch.value
            ? null
            : BottomAppBar(
                height: 78,
                color: controller.themeColorServices.neutralsColorGrey0.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoaderElevatedButton(
                      onPressed: () async {
                        await controller.onTapSave();
                      },
                      child: Text(
                        controller.languageServices.language.value.save ?? "-",
                        style: controller.typographyServices.bodySmallBold.value
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
