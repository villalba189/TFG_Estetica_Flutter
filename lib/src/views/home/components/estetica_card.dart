import 'package:estetica_app/src/styles/colors.dart';
import 'package:estetica_app/src/widgets/estetica_botton_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';
import 'package:service_repository/service_repository.dart';

import '../blocs/image_picker_cubit.dart';
import '../screens/products/bloc/product_page_bloc.dart';
import '../screens/services/bloc/service_page_bloc.dart';

class EsteticaCard extends StatelessWidget {
  final ProductModel? product;
  final ServiceModel? service;

  const EsteticaCard({super.key, this.product, this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 200,
      width: 200,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              product?.image ??
                  service?.image ??
                  'https://firebasestorage.googleapis.com/v0/b/estetica-app-tfg.appspot.com/o/producto.webp?alt=media&token=83be52f9-d03b-4723-832d-efeafd9ac9b7',
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/estetica-app-tfg.appspot.com/o/producto.webp?alt=media&token=83be52f9-d03b-4723-832d-efeafd9ac9b7');
              },
              fit: BoxFit.cover,
              height: double.maxFinite,
              width: double.maxFinite,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColorLight.withOpacity(0.1),
                    AppColors.primaryColorLight.withOpacity(0.8),
                    AppColors.primaryColorLight,
                    AppColors.primaryColor,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.name ?? service?.name ?? 'Producto',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Precio: ${product?.price.toString() ?? service?.price.toString() ?? 0} €',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      product != null
                          ? context.showCustomBottomSheet(
                              product: product,
                              productPageBloc: context.read<ProductPageBloc>(),
                              imagePickerCubit:
                                  context.read<ImagePickerCubit>(),
                            )
                          : context.showCustomBottomSheet(
                              service: service,
                              servicePageBloc: context.read<ServicePageBloc>(),
                              imagePickerCubit:
                                  context.read<ImagePickerCubit>(),
                            );
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
