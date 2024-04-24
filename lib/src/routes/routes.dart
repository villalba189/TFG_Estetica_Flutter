import 'package:client_repository/client_repository.dart';
import 'package:product_repository/product_repository.dart';
import 'package:service_repository/service_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../class/bloc_events_class.dart';
import '../views/home/blocs/client_page_bloc.dart';
import '../views/home/blocs/home_bloc.dart';
import '../views/home/blocs/product_page_bloc.dart';
import '../views/home/blocs/service_page_bloc.dart';
import '../views/home/enums/client_page_events_type.dart';
import '../views/home/enums/home_events_type.dart';
import '../views/home/views/home.dart';

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
    // GoRoute(
    //   path: '/client/:clientId',
    //   builder: (context, state) => Builder(
    //     builder: (context) => MultiBlocProvider(
    //       providers: [
    //         BlocProvider<HomeBloc>(
    //           create: (context) =>
    //               HomeBloc()..add(Event(HomeEventsType.initialHome)),
    //         ),
    //         BlocProvider<ClientePageBloc>(
    //           create: (context) => ClientePageBloc(FirebaseClientRepo())
    //             ..add(Event(ClientPageEventsType.getClientById,
    //                 data: state.pathParameters['clientId'])),
    //         ),
    //       ],
    //       child: ,
    //     ),
    //   ),
    // ),
  ],
);
