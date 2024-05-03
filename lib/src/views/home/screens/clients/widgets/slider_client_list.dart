import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/widgets/estetica_show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../styles/colors.dart';
import '../../../blocs/image_picker_cubit.dart';
import '../bloc/client_page_bloc.dart';
import '../screens/create_update_clients_screen.dart';

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
            onPressed: (context) => context.showDeleteDialog(
              client: client,
              clientPageBloc: context.read<ClientPageBloc>(),
            ),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_context) => CreateUpdateClientsScreen(
                  client: client,
                  bloc: context.read<ClientPageBloc>(),
                  cubit: context.read<ImagePickerCubit>(),
                ),
              ));
            },
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorListClient,
          border: const Border(
            bottom: BorderSide(
              color: AppColors.colorGrey,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 2), // Cambios en la sombra
            ),
          ],
        ),
        child: ListTile(
          title: Text("${client.name} ${client.surname ?? ''}"),
          subtitle: Text(client.email ?? ''),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(client.image ?? ''),
                fit: BoxFit.cover,
                onError: (_, __) => const Icon(Icons.person, size: 30),
              ),
            ),
            child: client.image == null
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
        ),
      ),
    );
  }
}
