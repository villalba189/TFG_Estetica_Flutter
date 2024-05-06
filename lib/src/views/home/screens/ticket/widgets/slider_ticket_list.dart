import 'package:estetica_app/src/class/bloc_events_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_repository/ticket_repository.dart';

import '../bloc/ticket_bloc.dart';

class SlidableTicketLine extends StatelessWidget {
  final LineaTicketModel line;

  const SlidableTicketLine({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    int quantity = context.select((TicketBloc bloc) => bloc.quantity);
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
                  .add(Event(TicketEventType.incrementQuantity));
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.add,
          ),
          SlidableAction(
            onPressed: (_) {
              // Agregar lógica para decrementar la cantidad
              if (quantity > 0) {
                context
                    .read<TicketBloc>()
                    .add(Event(TicketEventType.decrementQuantity));
              } else {
                context
                    .read<TicketBloc>()
                    .add(Event(TicketEventType.deleteTicketLine, data: line));
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
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
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        child: ListTile(
          title: Text("${line.product?.name ?? line.service?.name}"),
          leading: Text(line.quantity),
          trailing: Text("${line.subtotal}\$"),
        ),
      ),
    );
  }
}
