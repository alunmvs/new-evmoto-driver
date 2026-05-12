import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/data/models/guarantee_income_approval_model.dart';
import 'package:new_evmoto_driver/app/repositories/guarantee_income_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class HistoryGuaranteeIncomeController extends GetxController {
  final GuaranteeIncomeRepository guaranteeIncomeRepository;

  HistoryGuaranteeIncomeController({required this.guaranteeIncomeRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final recommendationDateTimeList = <DateTime>[
    for (int i = 0; i < 7; i++) DateTime.now().subtract(Duration(days: i)),
  ].obs;
  final selectedDateTime = DateTime.now().obs;

  final guaranteeIncomeApprovalList = <GuaranteeIncomeApproval>[].obs;
  final selectedGuaranteeIncomeApproval = GuaranteeIncomeApproval().obs;
  final totalSubsidyAmount = 0.0.obs;

  final isFetch = false.obs;
  final isFetchDate = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getGuaranteeIncomeApprovalList();
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

  Future<void> getGuaranteeIncomeApprovalList() async {
    isFetchDate.value = true;
    totalSubsidyAmount.value = 0.0;
    guaranteeIncomeApprovalList.value = [];
    selectedGuaranteeIncomeApproval.value = GuaranteeIncomeApproval();

    guaranteeIncomeApprovalList.value = await guaranteeIncomeRepository
        .getGuaranteeIncomeApprovalList(
          startDate: DateFormat('yyyy-MM-dd').format(selectedDateTime.value),
          endDate: DateFormat('yyyy-MM-dd').format(selectedDateTime.value),
        );

    if (guaranteeIncomeApprovalList.isNotEmpty) {
      for (var guaranteeIncomeApproval in guaranteeIncomeApprovalList) {
        totalSubsidyAmount.value +=
            guaranteeIncomeApproval.subsidyAmount ?? 0.0;
      }

      selectedGuaranteeIncomeApproval.value = guaranteeIncomeApprovalList.first;
    }

    isFetchDate.value = false;
  }
}
