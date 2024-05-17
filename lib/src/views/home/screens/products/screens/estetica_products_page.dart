import 'package:estetica_app/src/views/home/screens/products/bloc/product_page_bloc.dart';
import 'package:estetica_app/src/views/home/screens/products/resources/strings.dart';
import 'package:estetica_app/src/views/home/screens/ticket/bloc/ticket_bloc.dart';
import 'package:estetica_app/src/views/home/components/estetica_card.dart';
import 'package:estetica_app/src/widgets/estetica_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';

import '../../../../../class/bloc_events_class.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ProductModel> productsFiltered =
        context.select((ProductPageBloc value) => value.productsFiltered);
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
              child: Text(ProductsStrings.errorLoadingProducts),
            );
          case Success:
            return Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: productsFiltered
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
            );
          default:
            return const Center(
              child: Text(ProductsStrings.errorLoadingProducts),
            );
        }
      },
    );
  }
}
