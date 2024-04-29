import 'package:estetica_app/src/components/estetica_appbar.dart';
import 'package:estetica_app/src/views/home/components/estetica_botton_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home_bloc.dart';
import 'clients/screens/estetica_clients_page.dart';
import 'products/screens/estetica_products_page.dart';
import 'services/screens/estetica_services_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> esteticaPages = [
    const ProductPage(),
    const ServicePage(),
    const ClientPage(),
  ];

  @override
  Widget build(BuildContext context) {
    int index = context.select((HomeBloc bloc) => bloc.selectedIndex);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const EsteticaBottomNavBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            esteticaBar(
                titulo: 'Estetica Beatriz',
                leadingActive: false,
                actionsActive: true,
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
