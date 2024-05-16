import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';
import 'package:ticket_repository/ticket_repository.dart';
import 'package:estetica_app/src/class/bloc_events_class.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

enum TicketEventType {
  initial,
  incrementQuantity,
  decrementQuantity,
  deleteTicketLine,
  addTicketLine,
  addClient,
  editTicket,
  deleteTicket,
  sendTicket,
  cashPayment,
  saveTicket,
}

class TicketBloc extends Bloc<BlocEvent, BlocEvent> {
  final TicketRepo ticketRepository;
  final BuildContext context;
  List<LineaTicketModel> ticketLineas = [];
  ClientModel client = ClientModel();

  double total = 0;
  double subtotal = 0;
  double totalDiscount = 0;

  bool tick = false;

  TicketBloc(
    this.ticketRepository,
    this.context,
  ) : super(Event(TicketEventType.initial)) {
    on<Event>(
      (event, emit) async {
        void recalculateTotals() {
          total = ticketLineas.fold(
              0, (prev, element) => prev + (element.subtotal));
          if (client.discount != null) {
            totalDiscount = total - (total * (client.discount as int) / 100);
          } else {
            totalDiscount = total;
          }
        }

        void addOrUpdateTicketLine(dynamic item, bool isProduct) {
          var found = false;
          for (var line in ticketLineas) {
            if ((isProduct && line.product?.productId == item.productId) ||
                (!isProduct && line.service == item)) {
              line.quantity += 1;
              line.subtotal = line.quantity *
                  (isProduct
                      ? double.parse(item.price.toString())
                      : double.parse(item.price.toString()));
              found = true;
              break;
            }
          }

          if (!found) {
            ticketLineas.add(LineaTicketModel(
              id: FirebaseTicketRepo().lineasCollection.doc().id,
              product: isProduct ? item : null,
              service: isProduct ? null : item,
              quantity: 1,
              subtotal: item.price,
            ));
          }

          recalculateTotals();
        }

        switch (event.eventType) {
          case TicketEventType.initial:
            emit(Loading(event.eventType));
            ticketLineas.clear();
            client = ClientModel();
            total = 0;
            totalDiscount = 0;
            try {
              emit(Success(event.eventType, data: ticketLineas));
            } catch (e) {
              emit(Failure(event.eventType, errorType: e.toString()));
            }
            break;
          case TicketEventType.editTicket:
            emit(Loading(event.eventType));
            try {
              tick = event.data as bool;
              emit(Success(event.eventType, data: ticketLineas));
            } catch (e) {
              emit(Failure(event.eventType, errorType: e.toString()));
            }
            break;
          case TicketEventType.incrementQuantity:
            emit(Loading(event.eventType));
            try {
              int index = ticketLineas.indexWhere((l) => l.id == event.data.id);
              if (index != -1) {
                ticketLineas[index].quantity += 1;

                double price = 0;
                if (ticketLineas[index].product != null) {
                  price =
                      (ticketLineas[index].product?.price as num).toDouble();
                } else if (ticketLineas[index].service != null) {
                  price =
                      (ticketLineas[index].service?.price as num).toDouble();
                }

                ticketLineas[index].subtotal =
                    ticketLineas[index].quantity * price;

                recalculateTotals();
                emit(Success(event.eventType, data: ticketLineas));
              }
            } catch (e) {
              emit(Failure(event.eventType, errorType: e.toString()));
            }
            break;

          case TicketEventType.decrementQuantity:
            emit(Loading(event.eventType));
            try {
              int index = ticketLineas.indexWhere((l) => l.id == event.data.id);
              if (index != -1 && ticketLineas[index].quantity > 1) {
                ticketLineas[index].quantity -= 1;

                double price = 0;
                if (ticketLineas[index].product != null) {
                  price =
                      (ticketLineas[index].product?.price as num).toDouble();
                } else if (ticketLineas[index].service != null) {
                  price =
                      (ticketLineas[index].service?.price as num).toDouble();
                }

                ticketLineas[index].subtotal =
                    ticketLineas[index].quantity * price;

                recalculateTotals();
                emit(Success(event.eventType, data: ticketLineas));
              } else if (index != -1) {
                add(Event(TicketEventType.deleteTicketLine,
                    data: ticketLineas[index]));
              }
            } catch (e) {
              emit(Failure(event.eventType, errorType: e.toString()));
            }
            break;

          case TicketEventType.deleteTicketLine:
            emit(Loading(event.eventType));
            try {
              ticketLineas
                  .removeWhere((element) => element.id == event.data.id);
              recalculateTotals();
              emit(Success(event.eventType, data: ticketLineas));
            } catch (e) {
              emit(Failure(event.eventType, errorType: e.toString()));
            }
            break;

          case TicketEventType.addTicketLine:
            emit(Loading(event.eventType));
            tick = true;
            dynamic item = event.data['type'] == 'product'
                ? event.data['product']
                : event.data['service'];
            bool isProduct = event.data['type'] == 'product';

            addOrUpdateTicketLine(item, isProduct);

            emit(Success(event.eventType, data: item));
            break;

          case TicketEventType.addClient:
            emit.call(Loading(event.eventType));
            tick = true;
            client = event.data as ClientModel;
            total = ticketLineas.fold(
              0,
              (previousValue, element) =>
                  previousValue + (element.subtotal * element.quantity),
            );
            if (client.discount != null) {
              totalDiscount = total - (total * (client.discount as int) / 100);
            } else {
              totalDiscount = total;
            }
            emit.call(Success(event.eventType, data: client));
            break;

          case TicketEventType.deleteTicket:
            emit.call(Loading(event.eventType));
            try {
              ticketRepository.deleteTicket(event.data as TicketModel);
              emit.call(Success(event.eventType));
            } catch (e) {
              emit.call(Failure(event.eventType, errorType: e.toString()));
            }
            break;

          case TicketEventType.cashPayment:
            emit(Loading(event.eventType));
            try {
              double total = totalDiscount;
              double cantidadIntroducida = double.parse(event.data);

              double diferencia = cantidadIntroducida - total;
              emit(Success(event.eventType, data: diferencia));
            } catch (e) {
              emit(Failure(event.eventType, errorType: e.toString()));
            }
            break;
          case TicketEventType.sendTicket:
            emit(Loading(event.eventType));
            try {
              final emailBody = generateEmailBody(
                client,
                ticketLineas,
                totalDiscount,
                total,
              );

              final smtpServer =
                  gmail('pp.villa.agu@gmail.com', 'qpaf yrbd ermk gfhe');
              final message = Message()
                ..from =
                    const Address('pp.villa.agu@gmail.com', 'Estetica Beatriz')
                ..recipients.add(client.email!)
                ..subject = 'Ticket de compra'
                ..html = emailBody;

              await send(message, smtpServer);
              add(Event(TicketEventType.saveTicket));
            } catch (e) {
              emit(Failure(event.eventType, errorType: e.toString()));
            }
            break;

          case TicketEventType.saveTicket:
            ticketRepository.addTicket(
              TicketModel(
                client: client,
                lineas: ticketLineas,
                total: total.toString(),
                totalDes: totalDiscount.toString(),
                date: DateTime.now(),
                id: FirebaseTicketRepo().ticketsCollection.doc().id,
              ),
            );
            add(Event(TicketEventType.initial));
        }
      },
    );
  }
}

String generateEmailBody(
  ClientModel client,
  List<LineaTicketModel> ticketLineas,
  double totalDiscount,
  double total,
) {
  final rows = ticketLineas.map((line) {
    return '''
    <tr>
      <td style="padding: 8px; border: 1px solid #ddd;">${line.product?.name ?? line.service?.name ?? 'N/A'}</td>
      <td style="padding: 8px; border: 1px solid #ddd; text-align: center;">${line.quantity}</td>
      <td style="padding: 8px; border: 1px solid #ddd; text-align: right;">${line.subtotal.toStringAsFixed(2)}</td>
    </tr>
    ''';
  }).join();

  return '''
  <html>
    <body style="font-family: Arial, sans-serif; line-height: 1.6;">
      <h1 style="color: #333;">Estética Beatriz</h1>
      <p>Avinguda de Sant Andreu, 13A, 03294 Foia Elx, Alicante</p>
      <p>Teléfono: 651500922</p>
      <p>Email: info@esteticabeatriz.com</p>
      <hr style="border: 0; border-top: 1px solid #ddd;">
      <h2 style="color: #333;">Ticket de Compra</h2>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <thead>
          <tr>
            <th style="padding: 8px; border: 1px solid #ddd; background-color: #f2f2f2;">Producto/Servicio</th>
            <th style="padding: 8px; border: 1px solid #ddd; background-color: #f2f2f2; text-align: center;">Cantidad</th>
            <th style="padding: 8px; border: 1px solid #ddd; background-color: #f2f2f2; text-align: right;">Subtotal</th>
          </tr>
        </thead>
        <tbody>
          $rows
        </tbody>
      </table>
      <hr style="border: 0; border-top: 1px solid #ddd;">
      <p><strong>Cliente:</strong> ${client.name ?? 'N/A'} ${client.surname ?? 'N/A'}</p>
      <p><strong>Total:</strong> ${total.toStringAsFixed(2)}</p>
      <p><strong>Descuento:</strong> ${client.discount ?? 0}%</p>
      <p><strong>Total con Descuento:</strong> ${totalDiscount.toStringAsFixed(2)}</p>
    </body>
  </html>
  ''';
}
