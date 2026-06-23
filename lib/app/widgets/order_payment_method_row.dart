import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderPaymentMethodRow extends StatelessWidget {
  final int? payType;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final bool showBackground;

  const OrderPaymentMethodRow({
    super.key,
    required this.payType,
    this.labelStyle,
    this.valueStyle,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    if (payType != 3 && payType != 4) {
      return const SizedBox.shrink();
    }

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Metode Pembayaran", style: labelStyle),
        _buildPaymentMethod(),
      ],
    );

    if (!showBackground) {
      return row;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0XFFE7F3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: row,
    );
  }

  Widget _buildPaymentMethod() {
    if (payType == 4) {
      return Image.asset("assets/icons/icon_gopay_horizontal.png", height: 21);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset("assets/icons/icon_cash.svg", height: 12, width: 20),
        const SizedBox(width: 4),
        Text("Cash", style: valueStyle),
      ],
    );
  }
}
