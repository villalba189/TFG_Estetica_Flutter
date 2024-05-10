import 'package:estetica_app/src/widgets/estetica_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_repository/ticket_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../../../styles/colors.dart';
import '../../../../../styles/spaces.dart';
import '../bloc/ticket_bloc.dart';
import 'payment_success_dialog.dart';

void showPagoEfectivoDialog(
    {required TicketModel ticket, required BuildContext context}) {
  TextEditingController cantidadController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      bool isPaid = context.select((TicketBloc bloc) => bloc.isPaid);
      String toPay = context.select((TicketBloc bloc) => bloc.toPay);
      return AlertDialog(
        titleTextStyle: const TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: const Text('Pago en efectivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total ${isPaid ? "a deber" : "a pagar"}: $toPay€'),
            AppSpaces.spaceH24,
            const Text('Introduzca la cantidad a pagar:'),
            AppSpaces.spaceH24,
            EsteticaTextFormField(
              model: EsteticaTextFormFieldModel(
                controller: cantidadController,
                hintText: 'Cantidad',
                type: EsteticaTextFormFieldType.number,
              ),
              onChanged: (p0) {
                context.read<TicketBloc>().add(
                      Event(TicketEventType.cashPayment,
                          data: cantidadController.text),
                    );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.colorRed),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showPagoRealizadoSuccessDialog(
                  context: context, ticket: ticket, type: "Efectivo");
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
