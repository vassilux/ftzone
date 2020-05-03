import 'package:flutter/material.dart';

class XMarginWidget extends StatelessWidget {
  final double x;
  const XMarginWidget(this.x);
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: x);
  }
}