import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_repository/ticket_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../../../resources/spaces.dart';
import '../../../../../widgets/estetica_button.dart';
import '../bloc/ticket_bloc.dart';

void showPagoRealizadoSuccessDialog({
  required BuildContext context,
  required TicketModel ticket,
  required String type,
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
        title: type == 'tarjeta'
            ? const Text('Pago con tarjeta')
            : const Text('Pago en efectivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pago realizado con éxito'),
            AppSpaces.spaceH24,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EsteticaButton(
                  model: EsteticaButtonModel(
                    text: 'Volver',
                    type: EsteticaButtonType.secondary,
                  ),
                  onTapFunction: () {
                    Navigator.pop(context);
                    bloc.add(
                      Event(TicketEventType.saveTicket),
                    );
                  },
                ),
                EsteticaButton(
                  model: EsteticaButtonModel(
                    text: 'Enviar',
                    type: EsteticaButtonType.secondary,
                    leftIcon: Icons.email,
                  ),
                  onTapFunction: () {
                    Navigator.pop(context);
                    bloc.add(
                      Event(TicketEventType.sendTicket),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
