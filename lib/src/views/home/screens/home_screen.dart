import 'package:brand_repository/brand_repository.dart';
import 'package:estetica_app/src/class/bloc_events_class.dart';
import 'package:estetica_app/src/components/estetica_appbar.dart';
import 'package:estetica_app/src/resources/colors.dart';
import 'package:estetica_app/src/resources/spaces.dart';
import 'package:estetica_app/src/resources/strings.dart';
import 'package:estetica_app/src/views/home/components/estetica_botton_nav_bar.dart';
import 'package:estetica_app/src/views/home/screens/products/bloc/product_page_bloc.dart';
import 'package:estetica_app/src/views/home/screens/products/screens/create_update_products_screen.dart';
import 'package:estetica_app/src/views/home/screens/ticket/screens/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/utils.dart';
import '../../../widgets/estetica_text_form_field.dart';
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
  final TextEditingController textController = TextEditingController();
  MyHomePage({super.key});

  final List<Widget> esteticaPages = [
    const ProductPage(),
    const ServicePage(),
    const ClientPage(),
  ];

  @override
  Widget build(BuildContext context) {
    int index = context.select((HomeBloc bloc) => bloc.selectedIndex);
    List<BrandModel> marcas =
        context.select((ProductPageBloc value) => value.marcas);
    String marcaActual =
        context.select((ProductPageBloc value) => value.marcaActual);

    return GestureDetector(
      onTap: () => clearFocusAndHideKeyboard(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const TicketScreen(),
        bottomNavigationBar: const EsteticaBottomNavBar(),
        floatingActionButton: GestureDetector(
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
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              esteticaBar(
                  titulo: AppStrings.appName,
                  leadingActive: false,
                  actionsActive: true,
                  ticketActive: true,
                  context: context),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    index == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DropdownButton<String>(
                                value: marcaActual,
                                items: marcas
                                    .map((brand) => DropdownMenuItem(
                                          value: brand.name,
                                          child: Text(brand.name),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  context.read<ProductPageBloc>().add(Event(
                                      ProductPageEventsType.filterByBrand,
                                      data: value));
                                },
                                dropdownColor: AppColors.colorWhite,
                              ),
                              SizedBox(
                                width: 200,
                                child: EsteticaTextFormField(
                                  model: EsteticaTextFormFieldModel(
                                      type: EsteticaTextFormFieldType.text,
                                      hintText: AppStrings.buscar,
                                      controller: textController),
                                  onChanged: (value) {
                                    context.read<ProductPageBloc>().add(Event(
                                        ProductPageEventsType.filterByName,
                                        data: value));
                                  },
                                ),
                              )
                            ],
                          )
                        : index == 1
                            ? Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: EsteticaTextFormField(
                                  model: EsteticaTextFormFieldModel(
                                      type: EsteticaTextFormFieldType.text,
                                      hintText: 'Buscar...',
                                      controller: textController),
                                  onChanged: (value) {
                                    context.read<ServicePageBloc>().add(Event(
                                        ServicePageEventsType.filterByName,
                                        data: value));
                                  },
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: EsteticaTextFormField(
                                  model: EsteticaTextFormFieldModel(
                                      type: EsteticaTextFormFieldType.text,
                                      hintText: 'Buscar...',
                                      controller: textController),
                                  onChanged: (value) {
                                    context.read<ClientPageBloc>().add(Event(
                                        ClientPageEventsType.filterByName,
                                        data: value));
                                  },
                                ),
                              ),
                    AppSpaces.spaceH24,
                    esteticaPages[index]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
