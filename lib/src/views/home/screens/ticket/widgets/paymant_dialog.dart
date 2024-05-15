import 'package:estetica_app/src/views/home/screens/ticket/bloc/ticket_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ticket_repository/ticket_repository.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/spaces.dart';
import '../../../../../widgets/estetica_button.dart';
import 'card_payment_dailog.dart';
import 'cash_payment_dialog.dart';

enum MetodoPago { efectivo, tarjeta }

extension ShowPaymentDialog on BuildContext {
  showMetodoPagoDialog({
    TicketModel? ticket,
    TicketBloc? bloc,
  }) {
    showDialog(
      context: this,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: const TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          title: const Text('Metodo de pago'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Seleccione su método de pago:'),
              AppSpaces.spaceH24,
              Row(
                children: [
                  EsteticaButton(
                    model: EsteticaButtonModel(
                      text: 'Efectivo',
                      type: EsteticaButtonType.secondary,
                      leftIcon: Icons.money,
                    ),
                    onTapFunction: () {
                      Navigator.pop(context);
                      showPagoEfectivoDialog(
                        ticket: ticket!,
                        context: context,
                        bloc: bloc!,
                      );
                    },
                  ),
                  AppSpaces.spaceW10,
                  EsteticaButton(
                    model: EsteticaButtonModel(
                      text: 'Tarjeta',
                      type: EsteticaButtonType.secondary,
                      leftIcon: Icons.credit_card,
                    ),
                    onTapFunction: () {
                      Navigator.pop(context);
                      showPagoTarjetaDialog(
                          ticket: ticket!, context: context, bloc: bloc!);
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Volver',
                  style: TextStyle(color: AppColors.colorRed),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
