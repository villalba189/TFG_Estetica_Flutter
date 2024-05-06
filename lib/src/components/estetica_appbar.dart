import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/styles.dart';

SliverAppBar esteticaBar(
    {required String titulo,
    required bool leadingActive,
    required bool actionsActive,
    required bool ticketActive,
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
        if (leadingActive) ...[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:
                  Icon(Icons.arrow_back_sharp, color: AppColors.primaryColor),
            ),
          )
        ],
        if (ticketActive) ...[
          Builder(
            // Usar Builder para obtener el context correcto
            builder: (newContext) => Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(newContext).openDrawer(); // Usar newContext aquí
                },
                child: Icon(Icons.receipt, color: AppColors.primaryColor),
              ),
            ),
          ),
        ],
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
      if (actionsActive) ...[
        Container(
          padding: const EdgeInsets.all(7.0),
          margin: const EdgeInsets.only(right: 5),
          decoration: const ShapeDecoration(
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
          ),
          child: const Icon(Icons.settings, color: Colors.white),
        ),
      ]
    ],
  );
}
