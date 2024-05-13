import 'package:flutter/material.dart';

import '../resources/colors.dart';

class EsteticaCircularProgressIndicator extends StatelessWidget {
  final double? size;
  final double? strokeWidth;
  final Color? color;
  const EsteticaCircularProgressIndicator({
    super.key,
    this.size,
    this.strokeWidth,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? 2,
          color: color ?? AppColors.primaryColor,
        ),
      ),
    );
  }
}
