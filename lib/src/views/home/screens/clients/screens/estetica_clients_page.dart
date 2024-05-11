import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../class/bloc_events_class.dart';
import '../../ticket/bloc/ticket_bloc.dart';
import '../bloc/client_page_bloc.dart';
import '../../../../../widgets/estetica_snack_bar.dart';
import '../widgets/slider_client_list.dart';

class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TicketBloc, BlocEvent>(
      listener: (context, state) {
        if (state.eventType == TicketEventType.addClient) {
          if (state.runtimeType == Success) {
            context.showSnackBar(
                message:
                    '${(state.data as ClientModel).name} ${(state.data as ClientModel).surname} añadido al ticket ');
          }
        }
      },
      builder: (context, state) {
        List<ClientModel> clientsFiltered =
            context.select((ClientPageBloc bloc) => bloc.clientsFiltered);
        BlocEvent stateClient =
            context.select((ClientPageBloc bloc) => bloc.state);

        switch (stateClient.runtimeType) {
          case Success:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: clientsFiltered
                  .map(
                    (client) => GestureDetector(
                      onTap: () {
                        context.read<TicketBloc>().add(
                            Event(TicketEventType.addClient, data: client));
                      },
                      child: SlidableClient(client: client),
                    ),
                  )
                  .toList(),
            );
          case Failure:
            return const Center(
              child: Text('Error al cargar los clientes'),
            );
          case Loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            return Container();
        }
      },
    );
  }
}
