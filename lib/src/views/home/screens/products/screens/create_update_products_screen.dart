import 'package:brand_repository/brand_repository.dart';
import 'package:estetica_app/src/styles/colors.dart';
import 'package:estetica_app/src/styles/spaces.dart';
import 'package:estetica_app/src/views/home/blocs/image_picker_cubit.dart';
import 'package:estetica_app/src/widgets/estetica_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../../../components/estetica_appbar.dart';
import '../../../../../widgets/estetica_text_form_field.dart';
import '../../../components/image_picker_widget.dart';
import '../bloc/product_page_bloc.dart';

class CreateUpdateProductsScreen extends StatelessWidget {
  final ProductModel? product;
  final ProductPageBloc bloc;
  final ImagePickerCubit cubit;

  const CreateUpdateProductsScreen(
      {Key? key, this.product, required this.bloc, required this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    cubit.removeImage();
    final TextEditingController nameController =
        TextEditingController(text: product?.name ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: product?.description ?? '');
    final TextEditingController priceController =
        TextEditingController(text: product?.price?.toStringAsFixed(2) ?? '');

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductPageBloc>.value(value: bloc),
        BlocProvider<ImagePickerCubit>.value(value: cubit),
      ],
      child: FormularioProduct(
        nameController: nameController,
        descriptionController: descriptionController,
        priceController: priceController,
        product: product,
      ),
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
    String brand = product?.brand ?? '';
    final ProductPageBloc read = context.read<ProductPageBloc>();
    bool nameErrorVisible =
        context.select((ProductPageBloc bloc) => bloc.nameErrorVisible);
    bool descriptionErrorVisible =
        context.select((ProductPageBloc bloc) => bloc.descriptionErrorVisible);
    bool priceErrorVisible =
        context.select((ProductPageBloc bloc) => bloc.priceErrorVisible);
    String nameError = context.select((ProductPageBloc bloc) => bloc.nameError);
    String descriptionError =
        context.select((ProductPageBloc bloc) => bloc.descriptionError);
    String priceError =
        context.select((ProductPageBloc bloc) => bloc.priceError);

    String image =
        context.select((ImagePickerCubit cubit) => cubit.imageFile?.path ?? '');
    List<BrandModel> marcas =
        context.select((ProductPageBloc bloc) => bloc.marcas);
    BlocEvent state = context.select((ProductPageBloc bloc) => bloc.state);

    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          esteticaBar(
              titulo: 'Estetica Beatriz',
              leadingActive: true,
              actionsActive: false,
              ticketActive: false,
              context: context),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    AppSpaces.spaceH24,
                    ImagePickerWidget(
                      onImageSelected: (_image) {
                        context.read<ImagePickerCubit>().setImageFile(_image);
                      },
                      imagePath: (image == '' ? product?.image : image) ?? '',
                    ),
                    AppSpaces.spaceH24,
                    EsteticaTextFormField(
                      model: EsteticaTextFormFieldModel(
                        type: EsteticaTextFormFieldType.text,
                        controller: nameController,
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        errorText: nameErrorVisible ? nameError : null,
                      ),
                      onChanged: (String value) {
                        read.add(Event(
                          ProductPageErrorsType.productNameNoValido,
                          data: value,
                        ));
                      },
                    ),
                    AppSpaces.spaceH24,
                    EsteticaTextFormField(
                      model: EsteticaTextFormFieldModel(
                        type: EsteticaTextFormFieldType.text,
                        controller: descriptionController,
                        labelText: 'Description',
                        hintText: 'Enter your description',
                        errorText:
                            descriptionErrorVisible ? descriptionError : null,
                      ),
                      onChanged: (String value) {
                        read.add(Event(
                          ProductPageErrorsType.productDescriptionNoValido,
                          data: value,
                        ));
                      },
                    ),
                    AppSpaces.spaceH24,
                    EsteticaTextFormField(
                      model: EsteticaTextFormFieldModel(
                        type: EsteticaTextFormFieldType.number,
                        controller: priceController,
                        labelText: 'Price',
                        hintText: 'Enter your price',
                        errorText: priceErrorVisible ? priceError : null,
                      ),
                      onChanged: (String value) {
                        read.add(Event(
                          ProductPageErrorsType.productPriceNoValido,
                          data: value,
                        ));
                      },
                    ),
                    AppSpaces.spaceH24,
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      items: marcas.map((e) {
                        return DropdownMenuItem(
                          value: e.name,
                          child: Text(e.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        brand = value!;
                      },
                      icon: const Icon(
                          Icons.arrow_drop_down), // Icono desplegable
                      iconEnabledColor:
                          Colors.black, // Color del icono del desplegable
                      dropdownColor:
                          Colors.white, // Color de fondo del menú desplegable
                    ),
                    AppSpaces.spaceH24,
                    SizedBox(
                      width: double.infinity,
                      child: EsteticaButton(
                        model: EsteticaButtonModel(
                            text: product != null
                                ? 'Update Product'
                                : 'Add Product',
                            type: EsteticaButtonType.primary,
                            isEnable: nameController.text.isNotEmpty &&
                                priceController.text.isNotEmpty &&
                                !nameErrorVisible &&
                                !descriptionErrorVisible &&
                                !priceErrorVisible,
                            isLoading: state is Loading),
                        onTapFunction: () {
                          context.read<ProductPageBloc>().add(
                                Event(ProductPageEventsType.addImagenStorage,
                                    data: [
                                      product?.productId ??
                                          FirebaseProductRepo()
                                              .productsCollection
                                              .doc()
                                              .id,
                                      nameController.text,
                                      image,
                                      (_imagePath) {
                                        if (product != null) {
                                          context.read<ProductPageBloc>().add(
                                                Event(
                                                  ProductPageEventsType
                                                      .updateProduct,
                                                  data: ProductModel(
                                                    productId:
                                                        product!.productId,
                                                    name: nameController.text,
                                                    description:
                                                        descriptionController
                                                            .text,
                                                    price: double.tryParse(
                                                        priceController.text),
                                                    image: _imagePath == ''
                                                        ? product?.image
                                                        : _imagePath,
                                                    brand: brand,
                                                  ),
                                                ),
                                              );
                                        } else {
                                          context.read<ProductPageBloc>().add(
                                                Event(
                                                  ProductPageEventsType
                                                      .addProduct,
                                                  data: ProductModel(
                                                    productId:
                                                        FirebaseProductRepo()
                                                            .productsCollection
                                                            .doc()
                                                            .id,
                                                    name: nameController.text,
                                                    description:
                                                        descriptionController
                                                            .text,
                                                    price: double.tryParse(
                                                        priceController.text),
                                                    image: _imagePath == ''
                                                        ? 'https://firebasestorage.googleapis.com/v0/b/estetica-app-tfg.appspot.com/o/producto.webp?alt=media&token=83be52f9-d03b-4723-832d-efeafd9ac9b7'
                                                        : _imagePath,
                                                    brand: brand,
                                                  ),
                                                ),
                                              );
                                        }
                                        Navigator.of(context).pop();
                                      }
                                    ]),
                              );
                        },
                      ),
                    )
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
