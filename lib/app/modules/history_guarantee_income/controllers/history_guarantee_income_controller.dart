import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class HistoryGuaranteeIncomeController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final recommendationDateTimeList = <DateTime>[
    for (int i = 0; i < 7; i++) DateTime.now().subtract(Duration(days: i)),
  ].obs;
  final selectedDateTime = DateTime.now().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
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

  bool isDateSelected(DateTime date1) {
    var date2 = selectedDateTime.value;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
