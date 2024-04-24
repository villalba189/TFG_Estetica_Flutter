import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../styles/colors.dart';
import '../styles/styles.dart';

SliverAppBar esteticaBar(
    {required String titulo,
    required bool leadingActive,
    required bool actionsActive,
    required BuildContext context}) {
  return SliverAppBar(
    shadowColor: Colors.grey,
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 5.0,
    forceElevated: true,
    pinned: true,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        leadingActive
            ? Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    leadingActive ? Icons.arrow_back_sharp : null,
                    color: AppColors.primaryColor,
                  ),
                ),
              )
            : Container(),
        Expanded(
          child: Center(
            child: Text(
              titulo,
              style: AppTextStyle.styleCabecera,
            ),
          ),
        ),
      ],
    ),
    actions: [
      actionsActive
          ? Container(
              padding: const EdgeInsets.all(7.0),
              margin: const EdgeInsets.only(right: 5),
              decoration: const ShapeDecoration(
                color: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              child: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            )
          : Container(),
    ],
  );
}
