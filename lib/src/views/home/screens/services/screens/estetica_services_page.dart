import 'dart:developer';

import 'package:estetica_app/src/styles/colors.dart';
import 'package:estetica_app/src/widgets/estetica_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_repository/service_repository.dart';
import 'package:ticket_repository/ticket_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../ticket/bloc/ticket_bloc.dart';
import '../bloc/service_page_bloc.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ServiceModel> services =
        context.select((ServicePageBloc value) => value.services);

    return BlocListener<TicketBloc, BlocEvent>(
      listener: (context, state) {
        if (state.eventType == TicketEventType.addTicketLine) {
          if (state.runtimeType == Success) {
            log(state.data.toString());
            context.showSnackBar(
                message:
                    'Servicio añadido al ticket ${(state.data as ServiceModel).name}');
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: services
            .map(
              (service) => GestureDetector(
                  onTap: () {
                    context.read<TicketBloc>().add(Event(
                        TicketEventType.addTicketLine,
                        data: {'type': 'service', 'service': service}));
                  },
                  child: Container(
                    height: 1800,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          service.name ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          service.description ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          service.price.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )),
            )
            .toList(),
      ),
    );
  }
}
