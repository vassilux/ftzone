import 'package:flutter/material.dart';

class YMarginWidget extends StatelessWidget {
  final double y;
  const YMarginWidget(this.y);
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: y);
  }
}