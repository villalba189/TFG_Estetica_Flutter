import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:product_repository/product_repository.dart';
import 'package:service_repository/service_repository.dart';

import '../class/bloc_events_class.dart';
import '../views/home/screens/clients/bloc/client_page_bloc.dart';
import '../views/home/screens/products/bloc/product_page_bloc.dart';
import '../views/home/screens/services/bloc/service_page_bloc.dart';

extension ShowDeleteDialog on BuildContext {
  void showDeleteDialog({
    ProductModel? product,
    ServiceModel? service,
    ClientModel? client,
    ProductPageBloc? productPageBloc,
    ServicePageBloc? servicePageBloc,
    ClientPageBloc? clientPageBloc,
  }) {
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Eliminar ${product != null ? "Producto" : service != null ? "Servicio" : "Cliente"}",
            style: const TextStyle(
              color: Color(0xFF000000),
              fontSize: 20,
            ),
          ),
          content: Text(
            product != null
                ? "¿Estás seguro de eliminar el producto ${product.name}?"
                : service != null
                    ? "¿Estás seguro de eliminar el servicio ${service.name}?"
                    : "¿Estás seguro de eliminar al cliente ${client!.name}?",
            style: const TextStyle(
              color: Color(0xFF000000),
              fontSize: 15,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (product != null) {
                  productPageBloc!.add(Event(
                      ProductPageEventsType.deleteProduct,
                      data: product.productId));
                } else if (service != null) {
                  servicePageBloc!.add(Event(
                      ServicePageEventsType.deleteService,
                      data: service.serviceId));
                } else if (client != null) {
                  clientPageBloc!.add(Event(ClientPageEventsType.deleteClient,
                      data: client.clientId));
                }
                Navigator.of(context).pop();
              },
              child: const Text(
                "Eliminar",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
