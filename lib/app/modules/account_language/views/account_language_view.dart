import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/account_language_controller.dart';

class AccountLanguageView extends GetView<AccountLanguageController> {
  const AccountLanguageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.selectLanguage ?? "-",
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
            child: RadioGroup(
              onChanged: (value) {
                controller.tempLanguageCode.value = value!;
              },
              groupValue: controller.tempLanguageCode.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    controller.languageServices.language.value.selectLanguage ??
                        "-",
                    style: controller.typographyServices.bodySmallBold.value,
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      controller.tempLanguageCode.value = "ZH_CN";
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller.tempLanguageCode.value == "ZH_CN"
                              ? Color(0XFFB3B3B3)
                              : Color(0XFFE8E8E8),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "當代中文",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color:
                                        controller.tempLanguageCode.value ==
                                            "ZH_CN"
                                        ? Color(0XFF272727)
                                        : Color(0XFFB3B3B3),
                                  ),
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Radio(
                              value: "ZH_CN",
                              side: BorderSide(color: Color(0XFFB3B3B3)),
                              activeColor: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      controller.tempLanguageCode.value = "EN";
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller.tempLanguageCode.value == "EN"
                              ? Color(0XFFB3B3B3)
                              : Color(0XFFE8E8E8),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "English",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color:
                                        controller.tempLanguageCode.value ==
                                            "EN"
                                        ? Color(0XFF272727)
                                        : Color(0XFFB3B3B3),
                                  ),
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Radio(
                              value: "EN",
                              side: BorderSide(color: Color(0XFFB3B3B3)),
                              activeColor: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      controller.tempLanguageCode.value = "ID";
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller.tempLanguageCode.value == "ID"
                              ? Color(0XFFB3B3B3)
                              : Color(0XFFE8E8E8),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Bahasa Indonesia",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color:
                                        controller.tempLanguageCode.value ==
                                            "ID"
                                        ? Color(0XFF272727)
                                        : Color(0XFFB3B3B3),
                                  ),
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Radio(
                              value: "ID",
                              side: BorderSide(color: Color(0XFFB3B3B3)),
                              activeColor: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
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
