import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/resources/strings.dart';
import 'package:estetica_app/src/widgets/estetica_show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../resources/colors.dart';
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
        extentRatio: 0.45,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => context.showDeleteDialog(
              client: client,
              clientPageBloc: context.read<ClientPageBloc>(),
            ),
            backgroundColor: AppColors.colorRed,
            foregroundColor: AppColors.colorWhite,
            icon: Icons.delete,
            label: AppStrings.delete,
          ),
          SlidableAction(
            onPressed: (context) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (contextCli) => CreateUpdateClientsScreen(
                  client: client,
                  bloc: context.read<ClientPageBloc>(),
                  cubit: context.read<ImagePickerCubit>(),
                ),
              ));
            },
            backgroundColor: AppColors.colorCian,
            foregroundColor: AppColors.colorWhite,
            icon: Icons.edit,
            label: AppStrings.edit,
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
              color: AppColors.colorGrey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2), // Cambios en la sombra
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            "${client.name} ${client.surname ?? ''}",
            style: const TextStyle(color: AppColors.colorWhite),
          ),
          subtitle: Text(client.email ?? '',
              style: const TextStyle(color: AppColors.colorWhite)),
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
