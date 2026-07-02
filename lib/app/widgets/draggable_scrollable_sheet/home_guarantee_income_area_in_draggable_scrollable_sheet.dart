import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_driver/app/data/models/guarantee_income_progress_bar_model.dart';
import 'package:new_evmoto_driver/app/services/location_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:slide_countdown/slide_countdown.dart';

class HomeGuaranteeIncomeAreaInDraggableScrollableSheet extends StatefulWidget {
  const HomeGuaranteeIncomeAreaInDraggableScrollableSheet({super.key});

  @override
  State<HomeGuaranteeIncomeAreaInDraggableScrollableSheet> createState() =>
      _HomeGuaranteeIncomeAreaInDraggableScrollableSheetState();
}

class _HomeGuaranteeIncomeAreaInDraggableScrollableSheetState
    extends State<HomeGuaranteeIncomeAreaInDraggableScrollableSheet> {
  final draggableScrollableController = DraggableScrollableController();
  final themeColorServices = ThemeColorServices();
  final typographyServices = TypographyServices();
  final locationServices = LocationServices();

  late GoogleMapController googleMapController;

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final polylinesCoordinate = <LatLng>[].obs;

  final activeGuaranteeIncomeProgressBar = Rx<GuaranteeIncomeProgressBar?>(
    null,
  );

  final startTimeLocal = Rx<DateTime?>(null);
  final endTimeLocal = Rx<DateTime?>(null);
  final guaranteeIncomeProgress = 0.0.obs;
  final onlineDurationMinutes = 0.obs;
  final draggableScrollableSize = 0.0.obs;

  @override
  void initState() {
    super.initState();

    draggableScrollableController.addListener(() {
      draggableScrollableSize.value = draggableScrollableController.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: draggableScrollableController,
      initialChildSize: (90 / 812),
      minChildSize: (90 / 812),
      maxChildSize: (451 / 812),
      builder: (context, scrollController) {
        return Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: themeColorServices.overlayDark100.value.withValues(
                    alpha: 0.25,
                  ),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 + 8),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.all(0),
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 6,
                        width: 61,
                        decoration: BoxDecoration(
                          color: Color(0XFFCDCDCD),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: draggableScrollableSize.value <= (90 / 812)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/img_guarantee_income_area_in-1.png",
                                    width: 32,
                                    height: 32,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Anda Berada Di Dalam Area Jaminan Pendapatan.",
                                      style: typographyServices
                                          .bodyLargeBold
                                          .value
                                          .copyWith(color: Color(0XFF2AA34B)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  SlideCountdown(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0XFF34A853),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    duration: () {
                                      final remaining = DateTime.now()
                                          .add(Duration(hours: 2))
                                          .difference(DateTime.now());
                                      return remaining.isNegative
                                          ? Duration.zero
                                          : remaining;
                                    }(),
                                    shouldShowMinutes: (duration) =>
                                        duration.inDays == 0,
                                    onDone: () async {},
                                    style: typographyServices
                                        .captionLargeRegular
                                        .value
                                        .copyWith(
                                          color: Color(0XFFFFFFFF),
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/img_guarantee_income_area_in-1.png",
                                    width: 32,
                                    height: 32,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Anda Berada Di Dalam Area Jaminan Pendapatan.",
                                      style: typographyServices
                                          .bodyLargeBold
                                          .value
                                          .copyWith(color: Color(0XFF2AA34B)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0XFFD7D7D7)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AspectRatio(
                                    aspectRatio: 320 / 116,
                                    child: GoogleMap(
                                      initialCameraPosition:
                                          initialCameraPosition.value,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                            googleMapController = controller;
                                          },
                                      markers: markers,
                                      polylines: polylines,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Color(0XFFEEFFF8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: 7,
                                        bottom: 5,
                                        left: 15,
                                        right: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Sisa waktu jaminan hari ini",
                                            style: typographyServices
                                                .captionLargeBold
                                                .value
                                                .copyWith(),
                                          ),
                                          SizedBox(height: 4),
                                          SlideCountdown(
                                            padding: EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            duration: () {
                                              final remaining = DateTime.now()
                                                  .add(Duration(hours: 2))
                                                  .difference(DateTime.now());
                                              return remaining.isNegative
                                                  ? Duration.zero
                                                  : remaining;
                                            }(),
                                            shouldShowMinutes: (duration) =>
                                                duration.inDays == 0,
                                            onDone: () async {},
                                            separatorStyle: typographyServices
                                                .headingMediumBold
                                                .value
                                                .copyWith(
                                                  fontSize: 28,
                                                  color: Color(0XFF048025),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                            style: typographyServices
                                                .headingMediumBold
                                                .value
                                                .copyWith(
                                                  fontSize: 28,
                                                  color: Color(0XFF048025),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "(Periode: 09:00 - 11:00)",
                                            style: typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(),
                                          ),
                                          SizedBox(height: 4),
                                          Stack(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 11,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 1,
                                                              ),
                                                          child: LinearProgressIndicator(
                                                            value:
                                                                guaranteeIncomeProgress
                                                                    .value,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  9999,
                                                                ),
                                                            minHeight: 11,
                                                            color: Color(
                                                              0XFF048025,
                                                            ),
                                                            backgroundColor:
                                                                Color(
                                                                  0XFFFFFFFF,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (activeGuaranteeIncomeProgressBar
                                                          .value
                                                          ?.onLineTime !=
                                                      null &&
                                                  endTimeLocal.value != null &&
                                                  startTimeLocal.value !=
                                                      null) ...[
                                                Positioned(
                                                  left:
                                                      (MediaQuery.of(
                                                            context,
                                                          ).size.width -
                                                          (16 * 2) -
                                                          (16 * 2) -
                                                          (4 * 2)) *
                                                      (activeGuaranteeIncomeProgressBar
                                                              .value!
                                                              .onLineTime! /
                                                          (endTimeLocal.value!
                                                              .difference(
                                                                startTimeLocal
                                                                    .value!,
                                                              )
                                                              .inMinutes)),
                                                  child: SizedBox(
                                                    height: 25,
                                                    child: Center(
                                                      child: SizedBox(
                                                        height: 15,
                                                        child: VerticalDivider(
                                                          color: Color(
                                                            0XFFB3B3B3,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: SvgPicture.asset(
                                                  (activeGuaranteeIncomeProgressBar
                                                                      .value
                                                                      ?.onlineDurationMinutes ==
                                                                  null &&
                                                              activeGuaranteeIncomeProgressBar
                                                                      .value
                                                                      ?.onLineTime ==
                                                                  null) ||
                                                          (activeGuaranteeIncomeProgressBar
                                                                  .value!
                                                                  .onlineDurationMinutes! <
                                                              activeGuaranteeIncomeProgressBar
                                                                  .value!
                                                                  .onLineTime!)
                                                      ? 'assets/icons/icon_progress_bar_finish_grey.svg'
                                                      : 'assets/icons/icon_progress_bar_finish_brown.svg',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0XFFF4F4F4),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "Tetap online minimal 1 jam dan hindari pembatalan agar jaminan pendapatan tetap berlaku.",
                                        style: typographyServices
                                            .captionLargeRegular
                                            .value
                                            .copyWith(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              LoaderElevatedButton(
                                buttonColor:
                                    themeColorServices.primaryBlue.value,
                                onPressed: () async {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/icon_guarantee_income_btn.png",
                                      width: 16,
                                      height: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Lihat Detail",
                                      style: typographyServices
                                          .bodyLargeBold
                                          .value
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
