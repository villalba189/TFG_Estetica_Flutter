import 'dart:developer';

import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../class/bloc_events_class.dart';
import '../blocs/client_page_bloc.dart';
import '../widgets/estetica_snack_bar.dart';
import '../widgets/slider_client_list.dart';

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
                  (client) => GestureDetector(
                    onTap: () {
                      log("Cliente añadido al ticket: ${client.clientId}");
                      context.showSnackBar(
                          message:
                              'Cliente añadido al ticket ${client.name} ${client.surname}');
                    },
                    child: SlidableClient(client: client),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }
}
