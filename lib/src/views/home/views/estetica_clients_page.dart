import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../class/bloc_events_class.dart';
import '../blocs/client_page_bloc.dart';
import '../enums/client_page_events_type.dart';

class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ClientModel> clients = context.read<ClientePageBloc>().clients;
    return BlocBuilder<ClientePageBloc, BlocEvent>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Failure) {
          return Center(
            child: Text(state.errorType),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: clients
                .map(
                  (client) => ListTile(
                    title: Text(client.name),
                    subtitle: Text(client.phone ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<ClientePageBloc>().add(
                              Event(
                                ClientPageEventsType.deleteClient,
                                data: client.clientId,
                              ),
                            );
                      },
                    ),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }
}
