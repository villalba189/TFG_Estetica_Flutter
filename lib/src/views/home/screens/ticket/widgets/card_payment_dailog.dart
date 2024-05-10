import 'package:estetica_app/src/views/home/screens/ticket/widgets/payment_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ticket_repository/ticket_repository.dart';

void showPagoTarjetaDialog({
  required BuildContext context,
  required TicketModel ticket,
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
            Text('${ticket.totalDes}€'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              showPagoRealizadoSuccessDialog(
                  context: context, ticket: ticket, type: 'tarjeta');
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
