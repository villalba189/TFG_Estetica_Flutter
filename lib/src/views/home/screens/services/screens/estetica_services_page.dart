import 'package:estetica_app/src/views/home/screens/services/resources/strings.dart';
import 'package:estetica_app/src/widgets/estetica_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_repository/service_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../components/estetica_card.dart';
import '../../ticket/bloc/ticket_bloc.dart';
import '../bloc/service_page_bloc.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ServiceModel> servicesFiltered =
        context.select((ServicePageBloc value) => value.servicesFiltered);
    BlocEvent stateService =
        context.select((ServicePageBloc value) => value.state);

    return BlocConsumer<TicketBloc, BlocEvent>(
      listener: (context, state) {
        if (state.eventType == TicketEventType.addTicketLine) {
          if (state.runtimeType == Success) {
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
              child: Text(ServicesStrings.errorLoadingServices),
            );
          case Success:
            return Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: servicesFiltered
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
            );

          default:
            return const Center(
              child: Text(ServicesStrings.errorLoadingServices),
            );
        }
      },
    );
  }
}
