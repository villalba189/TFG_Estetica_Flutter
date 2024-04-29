import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../../../components/estetica_appbar.dart';
import '../bloc/client_page_bloc.dart';

class CreateUpdateClientsScreen extends StatelessWidget {
  final ClientModel? client;

  const CreateUpdateClientsScreen({Key? key, this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: client?.name ?? '');
    final TextEditingController emailController =
        TextEditingController(text: client?.email ?? '');
    final TextEditingController phoneController =
        TextEditingController(text: client?.phone ?? '');

    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          esteticaBar(
              titulo: 'Estetica Beatriz',
              leadingActive: true,
              actionsActive: false,
              context: context),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (client != null) {
                          context.read<ClientePageBloc>().add(
                                Event(
                                  ClientPageEventsType.updateClient,
                                  data: ClientModel(
                                    clientId: client!.clientId,
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                  ),
                                ),
                              );
                        } else {
                          context.read<ClientePageBloc>().add(
                                Event(
                                  ClientPageEventsType.addClient,
                                  data: ClientModel(
                                    clientId: FirebaseClientRepo()
                                        .clientsCollection
                                        .doc()
                                        .id,
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                  ),
                                ),
                              );
                        }
                        router.pop();
                      },
                      child:
                          Text(client != null ? 'Update Client' : 'Add Client'),
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    ));
  }
}
