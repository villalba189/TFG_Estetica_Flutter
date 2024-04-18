import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/views/home/enums/client_page_events_type.dart';

import '../../../class/bloc_events_class.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientePageBloc extends Bloc<BlocEvent, BlocEvent> {
  final ClientRepo _clientRepository;
  List<ClientModel> clients = [];
  ClientePageBloc(this._clientRepository)
      : super(Event(ClientPageEventsType.getClients)) {
    on<Event>((event, emit) async {
      switch (event.eventType) {
        case ClientPageEventsType.getClients:
          emit.call(Loading(event.eventType));
          try {
            _clientRepository.getClients().then((value) {
              clients = value;
            });
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ClientPageEventsType.getClientById:
          emit.call(Loading(event.eventType));
          try {
            _clientRepository.getClientbyId(event.data as String).then((value) {
              emit(Event(ClientPageEventsType.getClientById, data: value));
            });
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ClientPageEventsType.addClient:
          emit.call(Loading(event.eventType));
          try {
            _clientRepository.addClient(event.data as ClientModel);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ClientPageEventsType.deleteClient:
          emit.call(Loading(event.eventType));
          try {
            _clientRepository.deleteClient(event.data as String);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ClientPageEventsType.updateClient:
          emit.call(Loading(event.eventType));
          try {
            _clientRepository.updateClient(event.data as ClientModel);
            emit(Event(ClientPageEventsType.updateClient));
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
      }
    });
  }
}
