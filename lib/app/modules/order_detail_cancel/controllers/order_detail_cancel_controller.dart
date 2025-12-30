import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class OrderDetailCancelController extends GetxController {
  final OrderRepository orderRepository;

  OrderDetailCancelController({required this.orderRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final orderId = "".obs;
  final orderType = 0.obs;
  final orderDetail = OrderDetail().obs;

  final formGroup = FormGroup({
    "reason": FormControl<String>(validators: <Validator>[]),
  });

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'].toString();
    orderType.value = Get.arguments['order_type'];

    await getOrderDetail();

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

  Future<void> getOrderDetail() async {
    orderDetail.value = await orderRepository.getOrderDetail(
      orderType: orderType.value,
      orderId: orderId.value,
      language: 2,
    );

    formGroup.control("reason").value = orderDetail.value.cancelReason;
  }
}
