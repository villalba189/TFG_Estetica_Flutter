import 'dart:developer';

import 'package:estetica_app/src/styles/colors.dart';
import 'package:estetica_app/src/widgets/estetica_botton_sheet.dart';
import 'package:estetica_app/src/widgets/estetica_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_repository/service_repository.dart';
import 'package:ticket_repository/ticket_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../blocs/image_picker_cubit.dart';
import '../../../components/estetica_card.dart';
import '../../ticket/bloc/ticket_bloc.dart';
import '../bloc/service_page_bloc.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ServiceModel> services =
        context.select((ServicePageBloc value) => value.services);
    BlocEvent stateService =
        context.select((ServicePageBloc value) => value.state);

    return BlocConsumer<TicketBloc, BlocEvent>(
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
      builder: (context, state) {
        switch (stateService.runtimeType) {
          case Loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case Failure:
            return const Center(
              child: Text('Error al cargar los servicios'),
            );
          case Success:
            return Center(
              child: Wrap(
                spacing: 15,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: services
                    .map(
                      (service) => GestureDetector(
                          onTap: () {
                            context.read<TicketBloc>().add(Event(
                                TicketEventType.addTicketLine,
                                data: {'type': 'service', 'service': service}));
                          },
                          child: EsteticaCard(service: service)),
                    )
                    .toList(),
              ),
            );

          default:
            return const Center(
              child: Text('Error al cargar los servicios'),
            );
        }
      },
    );
  }
}
