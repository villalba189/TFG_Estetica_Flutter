import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../../../components/estetica_appbar.dart';
import '../bloc/client_page_bloc.dart';

class CreateUpdateClientsScreen extends StatelessWidget {
  final ClientModel? client;
  final ClientPageBloc bloc;

  const CreateUpdateClientsScreen({Key? key, this.client, required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: client?.name ?? '');
    final TextEditingController emailController =
        TextEditingController(text: client?.email ?? '');
    final TextEditingController phoneController =
        TextEditingController(text: client?.phone ?? '');

    return BlocProvider.value(
      value: bloc,
      child: FormularioClient(
          nameController: nameController,
          emailController: emailController,
          phoneController: phoneController,
          client: client),
    );
  }
}

class FormularioClient extends StatelessWidget {
  const FormularioClient({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.client,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final ClientModel? client;

  @override
  Widget build(BuildContext context) {
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
                          context.read<ClientPageBloc>().add(
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
                          context.read<ClientPageBloc>().add(
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
                        Navigator.of(context).pop();
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
