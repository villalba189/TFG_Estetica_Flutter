import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/styles/colors.dart';
import 'package:estetica_app/src/views/home/screens/ticket/widgets/slider_ticket_list.dart';
import 'package:estetica_app/src/widgets/estetica_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_repository/ticket_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../bloc/ticket_bloc.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ClientModel client = context.select((TicketBloc bloc) => bloc.client);
    List<LineaTicketModel> ticketLines =
        context.select((TicketBloc bloc) => bloc.ticketLineas);
    double total = context.select((TicketBloc bloc) => bloc.total);
    double totalDiscount =
        context.select((TicketBloc bloc) => bloc.totalDiscount);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryColor),
            accountName: Text(client.name ?? 'Invitado'),
            accountEmail: Text(client.email ?? 'Sin correo'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.primaryColorLight,
              backgroundImage: client.image != null
                  ? NetworkImage(client.image as String)
                  : null,
              child: client.image == null
                  ? const Icon(
                      Icons.person,
                      size: 30,
                      color: AppColors.colorWhite,
                    )
                  : null,
            ),
          ),
          Expanded(
            child: BlocBuilder<TicketBloc, BlocEvent>(
              builder: (context, state) {
                if (state is Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: ticketLines
                        .map(
                          (line) => SlidableTicketLine(line: line),
                        )
                        .toList(),
                  );
                }
              },
            ),
          ),
          const Divider(
            height: 1,
            thickness: 2,
            color: AppColors.primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total: ${total.toStringAsFixed(2)}€',
                  style: const TextStyle(fontSize: 16),
                ),
                if (client.discount != null) ...{
                  Text(
                    'Descuento: ${client.discount}% (${(total * (client.discount as int) / 100).toStringAsFixed(2)})€',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Total Des: ${totalDiscount.toStringAsFixed(2)}€',
                    style: const TextStyle(fontSize: 16),
                  ),
                },
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: EsteticaButton(
                    model: EsteticaButtonModel(
                      text: 'Finalizar Ticket',
                      type: EsteticaButtonType.secondary,
                    ),
                    onTapFunction: () => context
                        .read<TicketBloc>()
                        .add(Event(TicketEventType.finalizeTicket)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
