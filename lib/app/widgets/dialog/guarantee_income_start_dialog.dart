import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/dialog_helper.dart';
import 'package:new_evmoto_driver/app/utils/dialog_tags.dart';
import 'package:new_evmoto_driver/main.dart';

class GuaranteeIncomeStartDialog extends StatelessWidget {
  GuaranteeIncomeStartDialog({super.key});

  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
                maxHeight: MediaQuery.of(
                  navigatorKey.currentContext!,
                ).size.height,
              ),
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: firebaseRemoteConfigServices.remoteConfig
                            .getString("driver_guarantee_income_banner"),
                        width: MediaQuery.of(context).size.width,
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          DialogHelper.dismiss(DialogTags.guaranteeIncomeStart);
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
