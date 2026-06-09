import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

Future<XFile?> onTapImageUpload({
  required String title,
  CameraDevice? preferredCameraDevice,
}) async {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  var result;

  await Get.bottomSheet(
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
          child: Material(
            color: themeColorServices.neutralsColorGrey0.value,
            child: SizedBox(
              width: Get.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: typographyServices.bodyLargeBold.value,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.close(1);
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: 24,
                            height: 24,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_close.svg",
                                  width: 18,
                                  height: 18,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: Get.width,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0XFFE8E8E8)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var imagePicker = ImagePicker();

                              var image = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                                maxWidth: 720,
                                preferredCameraDevice: CameraDevice.front,
                              );

                              if (image != null) {
                                result = image;
                                Get.close(1);
                              }
                            },
                            child: Container(
                              width: Get.width,
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Color(0XFFCFE9FC),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_gallery.svg",
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    languageServices.language.value.gallery ??
                                        "-",
                                    style:
                                        typographyServices.bodySmallBold.value,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () async {
                              var imagePicker = ImagePicker();

                              var image = await imagePicker.pickImage(
                                source: ImageSource.camera,
                                maxWidth: 720,
                                preferredCameraDevice:
                                    preferredCameraDevice ?? CameraDevice.rear,
                              );

                              if (image != null) {
                                result = image;
                                Get.close(1);
                              }
                            },
                            child: Container(
                              width: Get.width,
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Color(0XFFCFE9FC),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_camera.svg",
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    languageServices.language.value.camera ??
                                        "-",
                                    style:
                                        typographyServices.bodySmallBold.value,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    isScrollControlled: true,
  );

  return result;
}
