import 'package:estetica_app/src/class/bloc_events_class.dart';
import 'package:estetica_app/src/components/estetica_appbar.dart';
import 'package:estetica_app/src/styles/colors.dart';
import 'package:estetica_app/src/views/home/components/estetica_botton_nav_bar.dart';
import 'package:estetica_app/src/views/home/screens/products/bloc/product_page_bloc.dart';
import 'package:estetica_app/src/views/home/screens/products/screens/create_update_products_screen.dart';
import 'package:estetica_app/src/views/home/screens/ticket/screens/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home_bloc.dart';
import '../blocs/image_picker_cubit.dart';
import 'clients/bloc/client_page_bloc.dart';
import 'clients/screens/create_update_clients_screen.dart';
import 'clients/screens/estetica_clients_page.dart';
import 'products/screens/estetica_products_page.dart';
import 'services/bloc/service_page_bloc.dart';
import 'services/screens/create_update_services_screen.dart';
import 'services/screens/estetica_services_page.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<Widget> esteticaPages = [
    const ProductPage(),
    const ServicePage(),
    const ClientPage(),
  ];

  @override
  Widget build(BuildContext context) {
    int index = context.select((HomeBloc bloc) => bloc.selectedIndex);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const TicketScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_context) => CreateUpdateProductsScreen(
                      bloc: context.read<ProductPageBloc>(),
                      cubit: context.read<ImagePickerCubit>(),
                    ),
                  ));
                  break;
                case 1:
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_context) => CreateUpdateServicesScreen(
                      bloc: context.read<ServicePageBloc>(),
                      cubit: context.read<ImagePickerCubit>(),
                    ),
                  ));
                  break;
                case 2:
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_context) => CreateUpdateClientsScreen(
                      bloc: context.read<ClientPageBloc>(),
                      cubit: context.read<ImagePickerCubit>(),
                    ),
                  ));
                  break;
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20, bottom: 20),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: AppColors.primaryColor,
              ),
              child: const Icon(Icons.add, color: AppColors.colorWhite),
            ),
          ),
          const EsteticaBottomNavBar(),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            esteticaBar(
                titulo: 'Estetica Beatriz',
                leadingActive: false,
                actionsActive: true,
                ticketActive: true,
                context: context),
            SliverList(
              delegate: SliverChildListDelegate(
                [esteticaPages[index]],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
