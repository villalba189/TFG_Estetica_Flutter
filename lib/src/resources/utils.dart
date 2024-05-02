import 'package:flutter/material.dart';

void clearFocusAndHideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
