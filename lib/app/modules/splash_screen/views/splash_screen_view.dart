import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/widgets/global_body_handler.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: GlobalBodyHandler(
          isFetch: controller.isFetch.value,
          isCriticalError: controller.isCriticalError.value,
          onInit: () async {
            await controller.onInit();
          },
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
              : controller.splashScreenQueryImage.value.url == null
              ? Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/img_background_splash_screen.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          "assets/logos/logo.png",
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
