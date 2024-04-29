import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/views/home/screens/clients/screens/create_update_clients_screen.dart';
import 'package:product_repository/product_repository.dart';
import 'package:service_repository/service_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../class/bloc_events_class.dart';
import '../views/home/screens/clients/bloc/client_page_bloc.dart';
import '../views/home/blocs/home_bloc.dart';
import '../views/home/screens/products/bloc/product_page_bloc.dart';
import '../views/home/screens/services/bloc/service_page_bloc.dart';
import '../views/home/screens/home_screen.dart';

GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Builder(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) =>
                  HomeBloc()..add(Event(HomeEventsType.initialHome)),
            ),
            BlocProvider<ClientePageBloc>(
              create: (context) => ClientePageBloc(FirebaseClientRepo())
                ..add(Event(ClientPageEventsType.getClients)),
            ),
            BlocProvider<ProductPageBloc>(
              create: (context) => ProductPageBloc(FirebaseProductRepo())
                ..add(Event(ProductPageEventsType.getProducts)),
            ),
            BlocProvider<ServicePageBloc>(
              create: (context) => ServicePageBloc(FirebaseServiceRepo())
                ..add(Event(ServicePageState.getServices)),
            ),
          ],
          child: const MyHomePage(),
        ),
      ),
    ),
    GoRoute(
      path: '/client',
      builder: (context, state) {
        return BlocProvider<ClientePageBloc>(
          create: (context) => ClientePageBloc(FirebaseClientRepo()),
          child: CreateUpdateClientsScreen(client: state.extra as ClientModel?),
        );
      },
    ),
  ],
);
