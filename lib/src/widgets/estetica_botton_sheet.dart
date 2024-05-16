import 'package:estetica_app/src/resources/colors.dart';
import 'package:estetica_app/src/resources/strings.dart';
import 'package:estetica_app/src/widgets/estetica_show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:product_repository/product_repository.dart';
import 'package:service_repository/service_repository.dart';

import '../views/home/blocs/image_picker_cubit.dart';
import '../views/home/screens/products/bloc/product_page_bloc.dart';
import '../views/home/screens/products/screens/create_update_products_screen.dart';
import '../views/home/screens/services/bloc/service_page_bloc.dart';
import '../views/home/screens/services/screens/create_update_services_screen.dart';

extension ShowCustomBottomSheet on BuildContext {
  void showCustomBottomSheet({
    ProductModel? product,
    ServiceModel? service,
    ProductPageBloc? productPageBloc,
    ImagePickerCubit? imagePickerCubit,
    ServicePageBloc? servicePageBloc,
  }) {
    showModalBottomSheet(
      context: this,
      builder: (context) => CustomBottomSheet(
        product: product,
        service: service,
        imagePickerCubit: imagePickerCubit,
        productPageBloc: productPageBloc,
        servicePageBloc: servicePageBloc,
      ),
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  final ProductModel? product;
  final ServiceModel? service;
  final ImagePickerCubit? imagePickerCubit;
  final ProductPageBloc? productPageBloc;
  final ServicePageBloc? servicePageBloc;

  const CustomBottomSheet(
      {super.key,
      this.product,
      this.service,
      this.imagePickerCubit,
      this.productPageBloc,
      this.servicePageBloc});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Center(
          child: Container(
            width: 70,
            alignment: Alignment.center,
            child: const Divider(
              color: AppColors.colorGrey,
              thickness: 6.0,
            ),
          ),
        ),
        ListTile(
          title: Center(
            child: Text(
              product != null ? product?.name ?? '' : service?.name ?? '',
              style: const TextStyle(
                color: AppColors.colorBlack,
                fontSize: 20,
              ),
            ),
          ),
          shape:
              const Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
        ),
        ListTile(
          title: Text(
            "Editar ${product != null ? AppStrings.product : AppStrings.service}",
            style: const TextStyle(
              color: Color(0xFF000000),
              fontSize: 15,
            ),
          ),
          onTap: () {
            if (product != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_context) => CreateUpdateProductsScreen(
                    product: product,
                    bloc: productPageBloc!,
                    cubit: imagePickerCubit!,
                  ),
                ),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_context) => CreateUpdateServicesScreen(
                    service: service,
                    bloc: servicePageBloc!,
                    cubit: imagePickerCubit!,
                  ),
                ),
              );
            }
          },
        ),
        ListTile(
          title: Text(
            "Eliminar ${product != null ? AppStrings.product : AppStrings.service}",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
            context.showDeleteDialog(
              product: product,
              service: service,
              productPageBloc: productPageBloc,
              servicePageBloc: servicePageBloc,
            );
          },
        ),
      ],
    );
  }
}
