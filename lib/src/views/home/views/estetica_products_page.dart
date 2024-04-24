import 'dart:developer';

import 'package:estetica_app/src/styles/colors.dart';
import 'package:estetica_app/src/views/home/blocs/product_page_bloc.dart';
import 'package:estetica_app/src/views/home/widgets/estetica_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';

import '../../../class/bloc_events_class.dart';

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
                        log("Producto añadido al ticket: ${product.productId}");
                        context.showSnackBar(
                            message:
                                'Producto añadido al ticket ${product.name}');
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              product.description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              product.price.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      )),
                )
                .toList(),
          );
        }
      },
    );
  }
}
