import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/resources/colors.dart';
import 'package:estetica_app/src/resources/spaces.dart';
import 'package:estetica_app/src/views/home/blocs/home_bloc.dart';
import 'package:estetica_app/src/views/home/screens/ticket/resources/strings.dart';
import 'package:estetica_app/src/views/home/screens/ticket/widgets/slider_ticket_list.dart';
import 'package:estetica_app/src/views/home/screens/ticket/widgets/paymant_dialog.dart';
import 'package:estetica_app/src/widgets/estetica_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    BlocEvent stateTicket = context.select((TicketBloc bloc) => bloc.state);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryColor),
            accountName: Text(client.name ?? TicketStrings.invitado),
            accountEmail: Text(client.email ?? TicketStrings.invitadoEmail),
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context
                    .read<HomeBloc>()
                    .add(Event(HomeEventsType.selectedIndex, data: 2));
              },
              child: Row(
                children: [
                  Expanded(
                    child: CircleAvatar(
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
                  AppSpaces.spaceW10,
                  GestureDetector(
                      onTap: () {
                        context
                            .read<TicketBloc>()
                            .add(Event(TicketEventType.removeClient));
                      },
                      child: Icon(
                        Icons.person_remove,
                        size: 15,
                      )),
                ],
              ),
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
                  return SingleChildScrollView(
                    child: Column(
                      children: ticketLines
                          .map(
                            (line) => SlidableTicketLine(line: line),
                          )
                          .toList(),
                    ),
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
                AppSpaces.spaceH16,
                SizedBox(
                  width: double.infinity,
                  child: EsteticaButton(
                      model: EsteticaButtonModel(
                        text: TicketStrings.finalizeTicket,
                        type: EsteticaButtonType.secondary,
                        isLoading: stateTicket is Loading,
                        isEnable: ticketLines.isNotEmpty,
                      ),
                      onTapFunction: () {
                        Navigator.pop(context);
                        context.showMetodoPagoDialog(
                            ticket: TicketModel(
                              id: FirebaseTicketRepo()
                                  .ticketsCollection
                                  .doc()
                                  .id,
                              date: DateTime.now(),
                              client: client,
                              lineas: ticketLines,
                              total: total.toString(),
                              totalDes: totalDiscount.toString(),
                            ),
                            bloc: context.read<TicketBloc>());
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
