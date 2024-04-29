import 'dart:developer';

import 'package:estetica_app/src/styles/colors.dart';
import 'package:estetica_app/src/views/home/screens/products/bloc/product_page_bloc.dart';
import 'package:estetica_app/src/widgets/estetica_card.dart';
import 'package:estetica_app/src/widgets/estetica_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';

import '../../../../../class/bloc_events_class.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ProductModel> products = context.read<ProductPageBloc>().products;
    return BlocBuilder<ProductPageBloc, BlocEvent>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Failure) {
          return Center(
            child: Text(state.errorType),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: products
                .map(
                  (product) => GestureDetector(
                      onTap: () {
                        context.showSnackBar(
                            message:
                                'Producto añadido al ticket ${product.name}');
                      },
                      child: EsteticaCard(product: product)),
                )
                .toList(),
          );
        }
      },
    );
  }
}
