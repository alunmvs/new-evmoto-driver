import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_chat_controller.dart';

class OrderChatView extends GetView<OrderChatController> {
  const OrderChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderChatView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OrderChatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
