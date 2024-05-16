import 'package:estetica_app/src/views/home/screens/clients/bloc/client_page_bloc.dart';
import 'package:estetica_app/src/views/home/screens/products/bloc/product_page_bloc.dart';
import 'package:estetica_app/src/views/home/screens/services/bloc/service_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../class/bloc_events_class.dart';
import '../resources/colors.dart';
import '../resources/styles.dart';
import '../views/home/screens/ticket/bloc/ticket_bloc.dart';

SliverAppBar esteticaBar(
    {required String titulo,
    required bool leadingActive,
    required bool actionsActive,
    required bool ticketActive,
    required BuildContext context}) {
  return SliverAppBar(
    shadowColor: AppColors.colorGrey,
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        color: AppColors.colorWhite,
      ),
    ),
    backgroundColor: AppColors.colorWhite,
    elevation: 5.0,
    forceElevated: true,
    pinned: true,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        if (leadingActive) ...[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_sharp,
                  color: AppColors.primaryColor),
            ),
          )
        ],
        if (ticketActive) ...[
          BlocBuilder<TicketBloc, BlocEvent>(
            builder: (context, state) {
              bool tick = context.select((TicketBloc bloc) => bloc.tick);
              return Builder(
                builder: (newContext) => Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          context.read<TicketBloc>().add(
                              Event(TicketEventType.editTicket, data: false));
                          Scaffold.of(context).openDrawer();
                        },
                        child: const Icon(Icons.receipt,
                            color: AppColors.primaryColor),
                      ),
                    ),
                    if (tick) ...[
                      const Positioned(
                        right: 0,
                        top: 0,
                        child: Icon(Icons.brightness_1,
                            size: 10, color: AppColors.colorRed),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
        Expanded(
          child: Center(
            child: Text(
              titulo,
              style: AppTextStyle.styleCabecera,
            ),
          ),
        ),
      ],
    ),
    actions: [
      if (actionsActive) ...[
        GestureDetector(
          onTap: () {
            context
                .read<ProductPageBloc>()
                .add(Event(ProductPageEventsType.getProducts));
            context
                .read<ServicePageBloc>()
                .add(Event(ServicePageEventsType.getServices));
            context
                .read<ClientPageBloc>()
                .add(Event(ClientPageEventsType.getClients));
          },
          child: Container(
            padding: const EdgeInsets.all(7.0),
            margin: const EdgeInsets.only(right: 5),
            decoration: const ShapeDecoration(
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
            ),
            child: const Icon(Icons.rotate_left_sharp, color: Colors.white),
          ),
        ),
      ]
    ],
  );
}
