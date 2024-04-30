import 'dart:developer';

import 'package:client_repository/client_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ClientPageEventsType {
  addClient,
  deleteClient,
  updateClient,
  getClientById,
  getClients,
}

class ClientPageBloc extends Bloc<BlocEvent, BlocEvent> {
  final ClientRepo _clientRepository;
  List<ClientModel> clients = [];
  ClientPageBloc(this._clientRepository)
      : super(Event(ClientPageEventsType.getClients)) {
    on<Event>((event, emit) async {
      switch (event.eventType) {
        case ClientPageEventsType.getClients:
          emit.call(Loading(event.eventType));
          try {
            clients = await _clientRepository.getClients();

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
            clients.add(event.data as ClientModel);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ClientPageEventsType.deleteClient:
          emit.call(Loading(event.eventType));
          try {
            _clientRepository.deleteClient(event.data as String);
            clients.removeWhere((client) => client.clientId == event.data);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ClientPageEventsType.updateClient:
          emit.call(Loading(event.eventType));
          try {
            _clientRepository.updateClient(event.data as ClientModel);
            int index = clients.indexWhere((client) =>
                client.clientId == (event.data as ClientModel).clientId);
            if (index != -1) {
              clients[index] = event.data as ClientModel;
            }
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
      }
    });
  }
}
