import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/my_vehicle_model.dart';
import 'package:new_evmoto_driver/app/repositories/vehicle_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class SwitchVehicleController extends GetxController {
  final VehicleRepository vehicleRepository;

  SwitchVehicleController({required this.vehicleRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final refreshController = RefreshController();

  final myVehicle = MyVehicle().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getMyVehicleDetail();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getMyVehicleDetail() async {
    myVehicle.value = await vehicleRepository.getMyVehicleDetail(
      language: languageServices.languageCodeSystem.value,
    );
  }

  Future<void> onTapSwitchVehicle({
    required AlternativeVehicle alternativeVehicle,
  }) async {
    try {
      await vehicleRepository.switchVehicle(
        language: languageServices.languageCodeSystem.value,
        carId: alternativeVehicle.id!,
      );
      SnackbarHelper.showSnackbarSuccess(text: "Berhasil mengubah kendaraan");
      await getMyVehicleDetail();
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }
}
