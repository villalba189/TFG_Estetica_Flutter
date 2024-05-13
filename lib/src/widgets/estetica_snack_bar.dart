import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../resources/colors.dart';
import '../resources/spaces.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 1,
          backgroundColor: AppColors.primaryColorDark,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: Row(
            children: [
              Icon(
                isError
                    ? FontAwesomeIcons.solidCircleXmark
                    : FontAwesomeIcons.solidCircleCheck,
                color: isError ? AppColors.colorRed : AppColors.colorGreen,
                size: 16,
              ),
              AppSpaces.spaceW8,
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                      color: AppColors.colorWhite, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
