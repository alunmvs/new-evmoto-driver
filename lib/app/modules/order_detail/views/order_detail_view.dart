import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OrderDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
