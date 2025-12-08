import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_payment_model.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class OrderPaymentDetailController extends GetxController {
  final OrderRepository orderRepository;

  OrderPaymentDetailController({required this.orderRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final refreshController = RefreshController();

  final orderId = "".obs;
  final orderType = 0.obs;
  final orderDetail = OrderDetail().obs;
  final orderPayment = OrderPayment().obs;

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

  Future<void> refreshAll() async {
    await getOrderDetail();
    await getOrderPayment();
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
}
