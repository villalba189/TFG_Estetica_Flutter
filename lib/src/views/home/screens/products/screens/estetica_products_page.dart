import 'package:estetica_app/src/views/home/screens/products/bloc/product_page_bloc.dart';
import 'package:estetica_app/src/views/home/screens/ticket/bloc/ticket_bloc.dart';
import 'package:estetica_app/src/widgets/estetica_botton_sheet.dart';
import 'package:estetica_app/src/views/home/components/estetica_card.dart';
import 'package:estetica_app/src/widgets/estetica_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../blocs/image_picker_cubit.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ProductModel> products =
        context.select((ProductPageBloc value) => value.products);
    BlocEvent stateProduct =
        context.select((ProductPageBloc value) => value.state);
    return BlocConsumer<TicketBloc, BlocEvent>(
      listener: (context, state) {
        if (state.eventType == TicketEventType.addTicketLine) {
          if (state.runtimeType == Success) {
            context.showSnackBar(
                message:
                    'Producto añadido al ticket ${(state.data as ProductModel).name}');
          }
        }
      },
      builder: (context, state) {
        switch (stateProduct.runtimeType) {
          case Loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case Failure:
            return const Center(
              child: Text('Error al cargar los productos'),
            );
          case Success:
            return Center(
              child: Wrap(
                spacing: 15,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: products
                    .map(
                      (product) => GestureDetector(
                          onTap: () {
                            context.read<TicketBloc>().add(Event(
                                TicketEventType.addTicketLine,
                                data: {'type': 'product', 'product': product}));
                          },
                          child: EsteticaCard(product: product)),
                    )
                    .toList(),
              ),
            );
          default:
            return const Center(
              child: Text('Error al cargar los productos'),
            );
        }
      },
    );
  }
}
