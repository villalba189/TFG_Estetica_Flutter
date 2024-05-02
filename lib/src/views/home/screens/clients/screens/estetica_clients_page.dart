import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../class/bloc_events_class.dart';
import '../bloc/client_page_bloc.dart';
import '../../../../../widgets/estetica_snack_bar.dart';
import '../widgets/slider_client_list.dart';

class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientPageBloc, BlocEvent>(
      builder: (context, state) {
        List<ClientModel> clients =
            context.select((ClientPageBloc bloc) => bloc.clients);
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: clients
                .map(
                  (client) => GestureDetector(
                    onTap: () {
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
