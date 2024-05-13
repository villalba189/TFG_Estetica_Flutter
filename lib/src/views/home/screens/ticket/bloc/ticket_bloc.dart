import 'dart:developer';

import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/class/bloc_events_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_repository/ticket_repository.dart';

enum TicketEventType {
  initial,
  incrementQuantity,
  decrementQuantity,
  deleteTicketLine,
  addTicketLine,
  addClient,
  finalizeTicket,
  editTicket,
  deleteTicket,
  sendTicket,
  cashPayment,
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

  bool isPaid = false;

  String toPay = '0';

  TicketBloc(
    this.ticketRepository,
    this.context,
  ) : super(Event(TicketEventType.initial)) {
    on<Event>((event, emit) {
      log('Event: ${event.eventType}');
      void recalculateTotals() {
        total =
            ticketLineas.fold(0, (prev, element) => prev + (element.subtotal));
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
          log('initial');
          emit(Loading(event.eventType));
          ticketLineas.clear(); // Limpiar contenido del ticket al iniciar
          client = ClientModel(); // Limpiar cliente al iniciar
          total = 0; // Reiniciar total al iniciar
          totalDiscount = 0; // Reiniciar total con descuento al iniciar
          try {
            emit(Success(event.eventType, data: ticketLineas));
          } catch (e) {
            emit(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case TicketEventType.editTicket:
          log('editTick');
          emit(Loading(event.eventType));
          try {
            tick = event.data as bool;
            emit(Success(event.eventType, data: ticketLineas));
          } catch (e) {
            emit(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case TicketEventType.incrementQuantity:
          log('incrementQuantity');
          emit(Loading(event.eventType));
          try {
            int index = ticketLineas.indexWhere((l) => l.id == event.data.id);
            if (index != -1) {
              ticketLineas[index].quantity += 1;

              double price = 0;
              if (ticketLineas[index].product != null) {
                price = (ticketLineas[index].product?.price as num).toDouble();
              } else if (ticketLineas[index].service != null) {
                price = (ticketLineas[index].service?.price as num).toDouble();
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
          log('decrementQuantity');
          emit(Loading(event.eventType));
          try {
            int index = ticketLineas.indexWhere((l) => l.id == event.data.id);
            if (index != -1 && ticketLineas[index].quantity > 1) {
              ticketLineas[index].quantity -= 1;

              double price = 0;
              if (ticketLineas[index].product != null) {
                price = (ticketLineas[index].product?.price as num).toDouble();
              } else if (ticketLineas[index].service != null) {
                price = (ticketLineas[index].service?.price as num).toDouble();
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
          log('deleteTicketLine');
          emit(Loading(event.eventType));
          try {
            ticketLineas.removeWhere((element) => element.id == event.data.id);
            recalculateTotals();
            emit(Success(event.eventType, data: ticketLineas));
          } catch (e) {
            log('Error deleting ticket line: $e');
            emit(Failure(event.eventType, errorType: e.toString()));
          }
          break;

        case TicketEventType.addTicketLine:
          log('addTicketLine');
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
          log('addClient');
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
        case TicketEventType.finalizeTicket:
          log('finalizeTicket loaded');
          emit.call(Loading(event.eventType));
          try {
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
            Navigator.pop(context);
            // context.showMetodoPagoDialog(
            //   ticket: TicketModel(
            //     client: client,
            //     lineas: ticketLineas,
            //     total: total.toString(),
            //     totalDes: totalDiscount.toString(),
            //     date: DateTime.now(),
            //     id: FirebaseTicketRepo().ticketsCollection.doc().id,
            //   ),
            // );
            emit.call(Success(event.eventType));
          } catch (e) {
            log('finalizeTicket error: $e');
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case TicketEventType.deleteTicket:
          log('deleteTicket');
          emit.call(Loading(event.eventType));
          try {
            ticketRepository.deleteTicket(event.data as TicketModel);
            emit.call(Success(event.eventType));
          } catch (e) {
            log('deleteTicket error: $e');
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;

        case TicketEventType.cashPayment:
          emit(Loading(event.eventType));
          try {
            toPay = (totalDiscount - double.parse(event.data)).toString();
            isPaid = double.parse(toPay) >= totalDiscount;
            emit(Success(event.eventType, data: isPaid));
          } catch (e) {
            emit(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case TicketEventType.sendTicket:
          emit(Loading(event.eventType));
          try {
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
            Navigator.pop(context);
            emit(Success(event.eventType));
          } catch (e) {
            emit(Failure(event.eventType, errorType: e.toString()));
          }
          break;
      }
    });
  }
}
