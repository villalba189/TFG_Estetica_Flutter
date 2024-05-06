import 'package:estetica_app/src/styles/colors.dart';
import 'package:estetica_app/src/views/home/screens/ticket/widgets/slider_ticket_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';
import 'package:ticket_repository/ticket_repository.dart';

import '../bloc/ticket_bloc.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String quantity =
        context.select((TicketBloc bloc) => bloc.quantity.toString());
    return Drawer(
      child: Column(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryColor),
            accountName: Text("Invitado"),
            accountEmail: Text("cliente@ejemplo.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                SlidableTicketLine(
                    line: LineaTicketModel(
                  id: "1",
                  quantity: quantity,
                  product: ProductModel(
                    productId: "1",
                    name: "Producto 1",
                    price: "50",
                    description: "Descripción del producto 1",
                    image: "https://via.placeholder.com/150",
                  ),
                  subtotal: '50',
                )),
              ],
            ),
          ),
          const ListTile(
            title: Text("Total: \$1000"),
            subtitle: Text("Descuento: 10% (\$100)"),
          ),
          const ListTile(
            title: Text("Total Des: \$900"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Acción para emitir el ticket
              },
              child: const Text("Emitir Ticket"),
            ),
          ),
        ],
      ),
    );
  }
}
