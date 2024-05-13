import 'package:brand_repository/brand_repository.dart';
import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/resources/strings.dart';
import 'package:product_repository/product_repository.dart';
import 'package:service_repository/service_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_repository/ticket_repository.dart';

import 'class/bloc_events_class.dart';
import 'resources/colors.dart';
import 'views/home/blocs/home_bloc.dart';
import 'views/home/blocs/image_picker_cubit.dart';
import 'views/home/screens/clients/bloc/client_page_bloc.dart';
import 'views/home/screens/home_screen.dart';
import 'views/home/screens/products/bloc/product_page_bloc.dart';
import 'views/home/screens/services/bloc/service_page_bloc.dart';
import 'views/home/screens/ticket/bloc/ticket_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
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
          BlocProvider<ClientPageBloc>(
            create: (context) => ClientPageBloc(FirebaseClientRepo())
              ..add(Event(ClientPageEventsType.getClients)),
          ),
          BlocProvider<ProductPageBloc>(
            create: (context) =>
                ProductPageBloc(FirebaseProductRepo(), FirebaseBrandRepo())
                  ..add(Event(ProductPageEventsType.getProducts)),
          ),
          BlocProvider<ServicePageBloc>(
            create: (context) => ServicePageBloc(FirebaseServiceRepo())
              ..add(Event(ServicePageEventsType.getServices)),
          ),
          BlocProvider<ImagePickerCubit>(
            create: (context) => ImagePickerCubit(),
          ),
          BlocProvider(
              create: (context) => TicketBloc(FirebaseTicketRepo(), context)
                ..add(Event(TicketEventType.initial))),
        ],
        child: MyHomePage(),
      ),
    );
  }
}
