import 'package:product_repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../../../components/estetica_appbar.dart';
import '../bloc/product_page_bloc.dart';

class CreateUpdateProductsScreen extends StatelessWidget {
  final ProductModel? product;
  final ProductPageBloc bloc;

  const CreateUpdateProductsScreen({Key? key, this.product, required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: product?.name ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: product?.description ?? '');
    final TextEditingController priceController =
        TextEditingController(text: product?.price.toString() ?? '');

    return BlocProvider.value(
      value: bloc,
      child: FormularioProduct(
          nameController: nameController,
          descriptionController: descriptionController,
          priceController: priceController,
          product: product),
    );
  }
}

class FormularioProduct extends StatelessWidget {
  const FormularioProduct({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.product,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          esteticaBar(
              titulo: 'Estetica Beatriz',
              leadingActive: true,
              actionsActive: false,
              context: context),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (product != null) {
                          context.read<ProductPageBloc>().add(
                                Event(
                                  ProductPageEventsType.updateProduct,
                                  data: ProductModel(
                                    productId: product!.productId,
                                    name: nameController.text,
                                    description: descriptionController.text,
                                    price: priceController.text,
                                  ),
                                ),
                              );
                        } else {
                          context.read<ProductPageBloc>().add(
                                Event(
                                  ProductPageEventsType.addProduct,
                                  data: ProductModel(
                                    productId: FirebaseProductRepo()
                                        .productsCollection
                                        .doc()
                                        .id,
                                    name: nameController.text,
                                    description: descriptionController.text,
                                    price: priceController.text,
                                  ),
                                ),
                              );
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                          product != null ? 'Update Product' : 'Add Product'),
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    ));
  }
}
