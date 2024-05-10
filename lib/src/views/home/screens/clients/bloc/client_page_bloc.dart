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
  addImagenStorage,
}

enum ClientPageErrorsType {
  correoNoValido,
  telefonoNoValido,
  nombreNoValido,
  apellidoNoValido,
}

class ClientPageBloc extends Bloc<BlocEvent, BlocEvent> {
  final ClientRepo _clientRepository;
  List<ClientModel> clients = [];

  // The error message
  String nameError = '';
  String surnameError = '';
  String emailError = '';
  String phoneError = '';

  // The visibility of the error messages
  bool nameErrorVisible = false;
  bool surnameErrorVisible = false;
  bool emailErrorVisible = false;
  bool phoneErrorVisible = false;

// The path of the image
  String imagePath = '';

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
            await _clientRepository.addClient(event.data as ClientModel);
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
        case ClientPageEventsType.addImagenStorage:
          emit.call(Loading(event.eventType));
          try {
            String imageData = event.data[2];
            imagePath = imageData == ''
                ? ''
                : await _clientRepository.addImagenStorage(
                    event.data[0] as String,
                    event.data[1] as String,
                    event.data[2] as String);
            (event.data[3] as Function)(imagePath);
            emit.call(Success(event.eventType));
          } catch (e) {
            log(e.toString());
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
      }
      switch (event.eventType) {
        case ClientPageErrorsType.nombreNoValido:
          String name = event.data as String;
          final nameRegex = RegExp(
              r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s-]{2,}$'); // Aceptar solo letras, espacios y guiones, mínimo 2 caracteres
          bool isValidName = nameRegex.hasMatch(name);
          log(name);
          if (name.isEmpty) {
            emit.call(Failure(event.eventType));
            nameError = 'Name is required';
            nameErrorVisible = true;
            return;
          } else if (!isValidName) {
            emit.call(Failure(event.eventType));
            nameError = 'Invalid name';
            nameErrorVisible = true;
            return;
          } else {
            nameErrorVisible = false;
            nameError = '';
            emit.call(Success(event.eventType));
          }
          break;

        case ClientPageErrorsType.apellidoNoValido:
          String surname = event.data as String;
          final surnameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s-]{2,}$');
          bool isValidSurname = surnameRegex.hasMatch(surname);
          if (surname.isEmpty) {
            surnameErrorVisible = false;
            surnameError = '';
            emit.call(Success(event.eventType));
            return;
          } else if (!isValidSurname) {
            emit.call(Failure(event.eventType));
            surnameError = 'Invalid surname';
            surnameErrorVisible = true;
            return;
          } else {
            surnameErrorVisible = false;
            surnameError = '';
            emit.call(Success(event.eventType));
          }
          break;
        case ClientPageErrorsType.correoNoValido:
          String email = event.data as String;
          final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
          bool isValidEmail = emailRegex.hasMatch(email);
          if (email.isEmpty) {
            emit.call(Failure(event.eventType));
            emailError = 'Email is required';
            emailErrorVisible = true;
            return;
          } else if (!isValidEmail) {
            emit.call(Failure(event.eventType));
            emailError = 'Invalid email';
            emailErrorVisible = true;
            return;
          } else {
            emailErrorVisible = false;
            emailError = '';
            emit.call(Success(event.eventType));
          }
          break;

        case ClientPageErrorsType.telefonoNoValido:
          String phone = event.data as String;
          final phoneRegex = RegExp(
              r'^[6-9]\d{8}$'); // Número de teléfono español de 9 dígitos
          bool isValidPhone = phoneRegex.hasMatch(phone);
          if (phone.isEmpty) {
            emit.call(Failure(event.eventType));
            phoneError = 'Phone is required';
            phoneErrorVisible = true;
            return;
          } else if (!isValidPhone) {
            emit.call(Failure(event.eventType));
            phoneError = 'Invalid phone';
            phoneErrorVisible = true;
            return;
          } else {
            phoneErrorVisible = false;
            phoneError = '';
            emit.call(Success(event.eventType));
          }
          break;
      }
    });
  }
}
