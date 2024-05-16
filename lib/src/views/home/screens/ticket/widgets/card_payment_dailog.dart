import 'package:estetica_app/src/resources/colors.dart';
import 'package:estetica_app/src/views/home/screens/ticket/bloc/ticket_bloc.dart';
import 'package:estetica_app/src/views/home/screens/ticket/widgets/payment_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ticket_repository/ticket_repository.dart';

void showPagoTarjetaDialog({
  required BuildContext context,
  required TicketModel ticket,
  required TicketBloc bloc,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titleTextStyle: const TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: const Text('Pago con tarjeta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Marca el total a pagar en el datafono.'),
            const Text('Total a pagar:'),
            Text(
              '${double.parse(ticket.totalDes).toStringAsFixed(2)}€',
              style: const TextStyle(
                color: AppColors.colorBlack,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showPagoRealizadoSuccessDialog(
                  context: context,
                  ticket: ticket,
                  type: 'tarjeta',
                  bloc: bloc);
            },
            child: const Text('Pagado'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.colorRed),
            ),
          )
        ],
      );
    },
  );
}
