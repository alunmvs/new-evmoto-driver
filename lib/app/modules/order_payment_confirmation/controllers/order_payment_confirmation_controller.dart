import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_payment_model.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class OrderPaymentConfirmationController extends GetxController {
  final OrderRepository orderRepository;

  OrderPaymentConfirmationController({required this.orderRepository});

  final formGroup = FormGroup({
    "additional_charge": FormControl<String>(validators: <Validator>[]),
    "surcharge_description": FormControl<String>(validators: <Validator>[]),
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final orderId = "".obs;
  final orderType = 0.obs;
  final orderDetail = OrderDetail().obs;
  final orderPayment = OrderPayment().obs;

  final isInformationShow = false.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'].toString();
    orderType.value = Get.arguments['order_type'];
    await getOrderDetail();
    await getOrderPayment();
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
  }

  Future<void> getOrderPayment() async {
    orderPayment.value = await orderRepository.getOrderPayment(
      orderType: orderType.value,
      orderId: orderId.value,
      language: 2,
      payManner: orderDetail.value.payManner!,
    );
  }

  Future<void> confirmOrderPayment() async {
    await orderRepository.confirmOrderPayment(
      orderType: orderType.value,
      orderId: orderId.value,
      language: 2,
      payManner: orderDetail.value.payManner!,
    );
  }

  Future<void> confirmCashReceived() async {
    await orderRepository.confirmCashReceived(
      orderType: orderType.value,
      orderId: orderId.value,
      language: 2,
    );
  }
}
