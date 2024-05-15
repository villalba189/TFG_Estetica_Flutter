import 'package:estetica_app/src/class/bloc_events_class.dart';
import 'package:estetica_app/src/resources/colors.dart';
import 'package:estetica_app/src/resources/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_repository/ticket_repository.dart';

import '../../../blocs/home_bloc.dart';
import '../bloc/ticket_bloc.dart';

class SlidableTicketLine extends StatelessWidget {
  final LineaTicketModel line;

  const SlidableTicketLine({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(line.id),
      startActionPane: ActionPane(
        extentRatio: 0.5,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              context
                  .read<TicketBloc>()
                  .add(Event(TicketEventType.incrementQuantity, data: line));
            },
            backgroundColor: AppColors.colorGreen,
            foregroundColor: AppColors.colorWhite,
            icon: Icons.add,
          ),
          SlidableAction(
            onPressed: (_) {
              context
                  .read<TicketBloc>()
                  .add(Event(TicketEventType.decrementQuantity, data: line));
            },
            backgroundColor: AppColors.colorRed,
            foregroundColor: AppColors.colorWhite,
            icon: Icons.remove,
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              context
                  .read<TicketBloc>()
                  .add(Event(TicketEventType.deleteTicketLine, data: line));
            },
            backgroundColor: AppColors.colorRed,
            foregroundColor: AppColors.colorWhite,
            icon: Icons.delete,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          context.read<HomeBloc>().add(Event(HomeEventsType.selectedIndex,
              data: line.product != null ? 0 : 1));
        },
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.colorWhite,
            border: Border(
              bottom: BorderSide(color: AppColors.colorGrey, width: 1),
            ),
          ),
          child: ListTile(
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    line.product?.image ?? line.service?.image ?? '',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                AppSpaces.spaceW10,
                Expanded(
                  child: Text(
                    line.product?.name ?? line.service?.name ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AppSpaces.spaceW8,
                Text(
                    "${line.product?.price!.toStringAsFixed(2) ?? line.service?.price!.toStringAsFixed(2)}€",
                    style: const TextStyle(
                        color: AppColors.colorBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            leading: Text("${line.quantity} x"),
            trailing: Text(
              "${line.subtotal}€",
              style: const TextStyle(fontSize: 15, color: AppColors.colorGreen),
            ),
          ),
        ),
      ),
    );
  }
}
