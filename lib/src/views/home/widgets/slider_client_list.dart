import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../class/bloc_events_class.dart';
import '../../../styles/colors.dart';
import '../blocs/client_page_bloc.dart';
import '../enums/client_page_events_type.dart';

class SlidableClient extends StatelessWidget {
  final ClientModel client;
  const SlidableClient({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        extentRatio: 0.4,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => context.read<ClientePageBloc>().add(
                  Event(ClientPageEventsType.deleteClient,
                      data: client.clientId),
                ),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) => context.push('/client/${client.clientId}'),
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.colorListClient,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: ListTile(
          title: Text("${client.name} ${client.surname}"),
          subtitle: Text(client.email ?? ''),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ),
    );
  }
}
