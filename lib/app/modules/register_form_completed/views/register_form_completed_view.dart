import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/register_form_completed_controller.dart';

class RegisterFormCompletedView
    extends GetView<RegisterFormCompletedController> {
  const RegisterFormCompletedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                SvgPicture.asset(
                  "assets/logos/logo_evmoto.svg",
                  width: 95.46,
                  height: 29.56,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Informasi Sudah Dilengkapi",
                          style: controller
                              .typographyServices
                              .headingSmallBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .textColor
                                    .value,
                              ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Mohon menunggu konfirmasi lanjutan",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .secondaryTextColor
                                    .value,
                              ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      "assets/images/img_progress_register_3_of_3.svg",
                      width: 72,
                      height: 72,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 63),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            border: Border.all(color: Color(0XFFECECEC)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 19),
                              Text(
                                "DATA YANG DIKIRIM BERHASIL",
                                style: controller
                                    .typographyServices
                                    .bodyLargeBold
                                    .value
                                    .copyWith(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorGreen400
                                          .value,
                                    ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Terima kasih telah memilih untuk bergabung dengan Keluarga EVMOTO. Tim kami akan menghubungi Anda dalam waktu 2 jam untuk mengonfirmasi informasi yang relevan. Mohon pastikan telepon Anda tetap aktif. Terima kasih atas dukungan dan pengertian Anda.",
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
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: Color(0XFFECECEC),
                        child: Image.asset(
                          "assets/icons/icon_register_completed.png",
                          width: 53,
                          height: 53,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          shadowColor: controller.themeColorServices.overlayDark100.value
              .withValues(alpha: 0.1),
          color: controller.themeColorServices.neutralsColorGrey0.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 46,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.onTapSubmit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.themeColorServices.primaryBlue.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Konfirmasi",
                    style: controller.typographyServices.bodyLargeBold.value
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
