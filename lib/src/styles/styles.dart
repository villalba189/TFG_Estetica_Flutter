import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyle {
  static const TextStyle styleCabecera = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 28,
    fontFamily: 'DancingScript',
    color: AppColors.primaryColor,
  );

  static const labelTextField = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 16,
  );

  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
