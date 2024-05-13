import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/colors.dart';
import '../resources/styles.dart';

enum EsteticaTextFormFieldType {
  text,
  number,
  phone,
  email,
}

class EsteticaTextFormFieldModel {
  final EsteticaTextFormFieldType type;
  final String? initialValue;
  final String? value;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final IconData? trailingIcon;
  final TextEditingController? controller;
  final int? maxLength;
  final bool showIsValidated;
  final bool inputUpperFormatter;

  EsteticaTextFormFieldModel({
    required this.type,
    this.initialValue,
    this.value,
    this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.trailingIcon,
    this.controller,
    this.maxLength,
    this.showIsValidated = false,
    this.inputUpperFormatter = false,
  });
}

class EsteticaTextFormField extends StatelessWidget {
  final EsteticaTextFormFieldModel model;
  final void Function(String)? onChanged;
  final void Function()? trailingIconOnPressed;

  const EsteticaTextFormField({
    super.key,
    required this.model,
    this.onChanged,
    this.trailingIconOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.labelText ?? '',
          style: AppTextStyle.labelTextField,
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.deny('  '),
                _NoLeadingSpaceFormatter(),
                // if (model.inputUpperFormatter) UpperCaseTextFormatter(),
              ],
              initialValue: model.initialValue,
              controller: model.value != null
                  ? TextEditingController(text: model.value)
                  : model.controller,
              //style: AppTextStyle.titleSmall,
              onChanged: onChanged,
              keyboardType: _getKeyboardTypeByType(),
              enabled: onChanged != null,
              maxLength: model.maxLength,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                counterText: model.maxLength != null
                    ? '${model.maxLength}/ ${model.controller?.text.length ?? 0}'
                    : null,
                contentPadding: const EdgeInsets.all(8.0),
                hintText: model.hintText,
                helperText: model.helperText,
                errorText: model.errorText,
                filled: onChanged == null,
                fillColor: onChanged == null
                    ? AppColors.colorReadOnly
                    : AppColors.colorWhite,
                /*  suffixIcon: model.showIsValidated
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.secondary,
                      )
                    : null,*/
              ),
            ),
            if (model.trailingIcon != null)
              IconButton(
                onPressed: trailingIconOnPressed,
                icon: Icon(model.trailingIcon),
              ),
          ],
        ),
      ],
    );
  }

  TextInputType? _getKeyboardTypeByType() {
    switch (model.type) {
      case EsteticaTextFormFieldType.text:
        return TextInputType.name;
      case EsteticaTextFormFieldType.number:
        return TextInputType.number;
      case EsteticaTextFormFieldType.phone:
        return TextInputType.phone;
      case EsteticaTextFormFieldType.email:
        return TextInputType.emailAddress;
    }
  }
}

class _NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}
