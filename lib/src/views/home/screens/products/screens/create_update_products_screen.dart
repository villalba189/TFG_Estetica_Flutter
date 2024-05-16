import 'package:brand_repository/brand_repository.dart';
import 'package:estetica_app/src/resources/colors.dart';
import 'package:estetica_app/src/resources/images.dart';
import 'package:estetica_app/src/resources/spaces.dart';
import 'package:estetica_app/src/views/home/blocs/image_picker_cubit.dart';
import 'package:estetica_app/src/views/home/screens/products/resources/strings.dart';
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
              titulo: product != null
                  ? ProductsStrings.updateProduct
                  : ProductsStrings.addProduct,
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
                      onImageSelected: (imageSlect) {
                        context
                            .read<ImagePickerCubit>()
                            .setImageFile(imageSlect);
                      },
                      imagePath: (image == '' ? product?.image : image) ?? '',
                    ),
                    AppSpaces.spaceH24,
                    EsteticaTextFormField(
                      model: EsteticaTextFormFieldModel(
                        type: EsteticaTextFormFieldType.text,
                        controller: nameController,
                        labelText: ProductsStrings.productName,
                        hintText: ProductsStrings.productHintName,
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
                        labelText: ProductsStrings.productDescription,
                        hintText: ProductsStrings.productHintDescription,
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
                        labelText: ProductsStrings.productPrice,
                        hintText: ProductsStrings.productHintPrice,
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
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColors.colorWhite,
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
                      icon: const Icon(Icons.arrow_drop_down),
                      iconEnabledColor: AppColors.colorBlack,
                      dropdownColor: AppColors.colorWhite,
                    ),
                    AppSpaces.spaceH24,
                    SizedBox(
                      width: double.infinity,
                      child: EsteticaButton(
                        model: EsteticaButtonModel(
                            text: product != null
                                ? ProductsStrings.updateProduct
                                : ProductsStrings.addProduct,
                            type: EsteticaButtonType.primary,
                            isEnable: nameController.text.isNotEmpty &&
                                priceController.text.isNotEmpty &&
                                !nameErrorVisible &&
                                !descriptionErrorVisible &&
                                !priceErrorVisible,
                            isLoading: state is Loading),
                        onTapFunction: () {
                          String id =
                              FirebaseProductRepo().productsCollection.doc().id;
                          context.read<ProductPageBloc>().add(
                                Event(ProductPageEventsType.addImagenStorage,
                                    data: [
                                      product?.productId ?? id,
                                      nameController.text,
                                      image,
                                      (imagePath) {
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
                                                    image: imagePath == ''
                                                        ? product?.image
                                                        : imagePath,
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
                                                    productId: id,
                                                    name: nameController.text,
                                                    description:
                                                        descriptionController
                                                            .text,
                                                    price: double.tryParse(
                                                        priceController.text),
                                                    image: imagePath == ''
                                                        ? AppImages
                                                            .imagenPorDefecto
                                                        : imagePath,
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
