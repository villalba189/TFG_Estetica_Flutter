import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../styles/colors.dart';
import '../styles/spaces.dart';
import '../styles/styles.dart';
import 'estetica_circular_progress_indicator.dart';

enum EsteticaButtonType {
  primary,
  secondary,
  tertiary,
}

class EsteticaButtonModel {
  ///Texto que se va a mostrar en el botón
  final String text;

  ///Tipo de botón (Según el tipo tiene un aspecto u otro)
  final EsteticaButtonType type;

  ///Indica si el botón va a ser redondeado
  ///Por defecto es true
  final bool isRounded;

  ///Indica si el botón esta habilitado
  ///Por defecto es true
  final bool isEnable;

  ///Indica si el botón es ancho
  ///Por defecto es false
  final bool isWide;

  ///Icono izquierdo
  ///Si no se especifica no se muestra
  final IconData? leftIcon;

  ///Tamaño del icono izquierdo
  ///Por defecto es 14.0
  final double? leftIconSize;

  ///Icono derecho
  ///Si no se especifica no se muestra
  final IconData? rightIcon;

  ///Tamaño del icono derecho
  ///Por defecto es 14.0
  final double? rightIconSize;

  ///Indica si el botón esta cargando
  ///Por defecto es false
  final bool isLoading;

  EsteticaButtonModel({
    required this.text,
    required this.type,
    this.isRounded = true,
    this.isEnable = true,
    this.isWide = false,
    this.leftIcon,
    this.rightIcon,
    this.isLoading = false,
    this.leftIconSize = 14.0,
    this.rightIconSize = 14.0,
  });
}

class EsteticaButton extends StatelessWidget {
  const EsteticaButton({
    super.key,
    required this.model,
    required this.onTapFunction,
  });

  final Function()? onTapFunction;
  final EsteticaButtonModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: model.isEnable ? onTapFunction : null,
      child: Opacity(
        opacity: model.isEnable ? 1 : 0.4,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: model.isWide ? 18.0 : 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(model.isRounded ? 40.0 : 8.0),
            color: _getBackgroundColor(),
            border: Border.all(
              color: _getBorderColor(),
              width: 1.0,
            ),
          ),
          child: model.isLoading ? _getLoader() : _getButtonContent(),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (model.type) {
      case EsteticaButtonType.primary:
        return AppColors.primaryColor;
      case EsteticaButtonType.secondary:
        return AppColors.colorWhite;
      case EsteticaButtonType.tertiary:
        return AppColors.colorWhite;
    }
  }

  Color _getBorderColor() {
    switch (model.type) {
      case EsteticaButtonType.primary:
      case EsteticaButtonType.secondary:
        return AppColors.primaryColor;
      case EsteticaButtonType.tertiary:
        return AppColors.colorRed;
    }
  }

  Color _getTextColor() {
    switch (model.type) {
      case EsteticaButtonType.primary:
        return AppColors.colorWhite;
      case EsteticaButtonType.secondary:
        return AppColors.primaryColor;
      case EsteticaButtonType.tertiary:
        return AppColors.colorRed;
    }
  }

  Widget _getButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          model.isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        if (model.leftIcon != null) ...[
          FaIcon(
            model.leftIcon,
            size: model.leftIconSize,
            color: _getTextColor(),
          ),
          AppSpaces.spaceW8,
        ],
        Text(
          model.text,
          style: AppTextStyle.title.copyWith(
            color: _getTextColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
        if (model.rightIcon != null) ...[
          AppSpaces.spaceW8,
          FaIcon(
            model.rightIcon,
            size: model.rightIconSize,
            color: _getTextColor(),
          ),
        ],
      ],
    );
  }

  Widget _getLoader() {
    switch (model.type) {
      case EsteticaButtonType.primary:
        return const EsteticaCircularProgressIndicator(
          color: AppColors.colorWhite,
          size: 19.0,
        );
      case EsteticaButtonType.secondary:
        return const EsteticaCircularProgressIndicator(
          color: AppColors.primaryColor,
          size: 19.0,
        );
      case EsteticaButtonType.tertiary:
        return const EsteticaCircularProgressIndicator(
          color: AppColors.colorRed,
          size: 19.0,
        );
    }
  }
}
