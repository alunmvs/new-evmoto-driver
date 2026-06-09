import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/my_vehicle_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/switch_vehicle_controller.dart';

class SwitchVehicleView extends GetView<SwitchVehicleController> {
  const SwitchVehicleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Ubah Kendaraan",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: Color(0XFFF7F7F7),
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
            : SmartRefresher(
                header: MaterialClassicHeader(
                  color: controller.themeColorServices.primaryBlue.value,
                ),
                footer: ClassicFooter(
                  loadStyle: LoadStyle.HideAlways,
                  textStyle: controller
                      .typographyServices
                      .bodySmallRegular
                      .value
                      .copyWith(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                  canLoadingIcon: null,
                  loadingIcon: null,
                  idleIcon: null,
                  noMoreIcon: null,
                  failedIcon: null,
                ),
                enablePullDown: true,
                enablePullUp: false,
                onRefresh: () async {
                  await Future.wait([controller.getMyVehicleDetail()]);
                  controller.refreshController.refreshCompleted();
                },
                onLoading: () async {
                  controller.refreshController.loadComplete();
                },
                controller: controller.refreshController,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0XFFE8E8E8)),
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kendaraan Saat Ini",
                                style: controller
                                    .typographyServices
                                    .bodySmallBold
                                    .value
                                    .copyWith(
                                      color: controller
                                          .themeColorServices
                                          .textColor
                                          .value,
                                    ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0XFFF7F7F7),
                                  border: Border.all(color: Color(0XFFCFCFCF)),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.myVehicle.value.car ==
                                                    null ||
                                                controller
                                                        .myVehicle
                                                        .value
                                                        .car ==
                                                    ""
                                            ? "Saat ini akses kendaraan anda belum tersedia, Silahkan hubungi layanan kami!"
                                            : controller.myVehicle.value.car!,
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value
                                            .copyWith(
                                              color:
                                                  controller
                                                          .myVehicle
                                                          .value
                                                          .car ==
                                                      null
                                                  ? Color(0XFFCFCFCF)
                                                  : controller
                                                        .themeColorServices
                                                        .primaryBlue
                                                        .value,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Kendaraan Tersedia",
                          style: controller
                              .typographyServices
                              .bodySmallBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .textColor
                                    .value,
                              ),
                        ),
                        SizedBox(height: 16),
                        if (controller
                                .myVehicle
                                .value
                                .alternativeVehicle
                                ?.isEmpty ??
                            true) ...[
                          Text(
                            "Saat ini belum tersedia kendaraan",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(color: Color(0XFFB3B3B3)),
                          ),
                        ],
                        for (var alternativeVehicle
                            in controller.myVehicle.value.alternativeVehicle ??
                                <AlternativeVehicle>[]) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                alternativeVehicle.name ?? "-",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value,
                              ),
                              SizedBox(
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await controller.onTapSwitchVehicle(
                                      alternativeVehicle: alternativeVehicle,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: controller
                                        .themeColorServices
                                        .primaryBlue
                                        .value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    "Pilih",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
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
                          SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
