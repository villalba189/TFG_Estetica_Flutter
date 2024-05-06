import 'package:estetica_app/src/class/bloc_events_class.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_repository/ticket_repository.dart';

enum TicketEventType {
  initial,
  incrementQuantity,
  decrementQuantity,
  deleteTicketLine,
}

class TicketBloc extends Bloc<BlocEvent, BlocEvent> {
  final TicketRepo ticketRepository;

  int quantity = 0;

  TicketBloc(
    this.ticketRepository,
  ) : super(Event(TicketEventType.initial)) {
    on<Event>((event, emit) {
      switch (event.eventType) {
        case TicketEventType.initial:
          emit.call(Loading(event.eventType));
          break;
        case TicketEventType.incrementQuantity:
          emit.call(Loading(event.eventType));
          try {
            quantity = quantity + 1;
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case TicketEventType.decrementQuantity:
          emit.call(Loading(event.eventType));
          try {
            quantity = quantity - 1;
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case TicketEventType.deleteTicketLine:
          emit.call(Loading(event.eventType));
          try {
            ticketRepository.deleteLinea(event.data as LineaTicketModel);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        default:
          emit.call(Failure(event.eventType, errorType: 'Event not found'));
      }
    });
  }
}
