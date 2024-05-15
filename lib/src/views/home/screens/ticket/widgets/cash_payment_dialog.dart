import 'package:estetica_app/src/widgets/estetica_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_repository/ticket_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/spaces.dart';
import '../bloc/ticket_bloc.dart';
import 'payment_success_dialog.dart';

void showPagoEfectivoDialog(
    {required TicketModel ticket,
    required BuildContext context,
    required TicketBloc bloc}) {
  TextEditingController cantidadController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        child: AlertDialog(
          titleTextStyle: const TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          title: const Text('Pago en efectivo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<TicketBloc, BlocEvent>(
                builder: (context, state) {
                  double diferencia = 0;
                  String diferenciaTexto =
                      double.parse(ticket.totalDes).toStringAsFixed(2);
                  if (state is Success &&
                      state.eventType == TicketEventType.cashPayment) {
                    diferencia = state.data;
                    if (diferencia < 0) {
                      diferenciaTexto =
                          'Falta: ${(-diferencia).toStringAsFixed(2)}';
                    } else if (diferencia > 0) {
                      diferenciaTexto =
                          'Cambio: ${diferencia.toStringAsFixed(2)}';
                    } else {
                      diferenciaTexto = diferencia.toStringAsFixed(2);
                    }
                  }

                  return Text(
                    diferenciaTexto,
                    style: TextStyle(
                      color: diferencia < 0
                          ? AppColors.colorRed
                          : diferencia > 0
                              ? AppColors.colorGreen
                              : Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
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
                  bloc.add(
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
                    context: context,
                    ticket: ticket,
                    type: "Efectivo",
                    bloc: bloc);
              },
              child: const Text('Pagado'),
            ),
          ],
        ),
      );
    },
  );
}
