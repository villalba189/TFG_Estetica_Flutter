import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/views/home/blocs/client_page_bloc.dart';
import 'package:estetica_app/src/views/home/blocs/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'class/bloc_events_class.dart';
import 'styles/colors.dart';
import 'views/home/enums/client_page_events_type.dart';
import 'views/home/enums/home_events_type.dart';
import 'views/home/views/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Estetica app TFG',
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          canvasColor: Colors.transparent,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) =>
                  HomeBloc()..add(Event(HomeEventsType.initialHome)),
            ),
            BlocProvider<ClientePageBloc>(
              create: (context) => ClientePageBloc(FirebaseClientRepo())
                ..add(Event(ClientPageEventsType.getClients)),
            ),
          ],
          child: const MyHomePage(),
        ));
  }
}
