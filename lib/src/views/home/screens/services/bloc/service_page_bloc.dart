import 'package:estetica_app/src/class/bloc_events_class.dart';
import 'package:estetica_app/src/views/home/screens/services/resources/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_repository/service_repository.dart';

enum ServicePageEventsType {
  getServices,
  getServicesById,
  addService,
  updateService,
  deleteService,
  addImagenStorage,
  filterByName,
}

enum ServicePageErrorsType {
  serviceNameNoValido,
  servicePriceNoValido,
  serviceDescriptionNoValido,
}

class ServicePageBloc extends Bloc<BlocEvent, BlocEvent> {
  final ServiceRepo _serviceRepository;
  List<ServiceModel> services = [];
  List<ServiceModel> servicesFiltered = [];

  String nameError = '';
  String priceError = '';
  String descriptionError = '';

  bool nameErrorVisible = false;
  bool priceErrorVisible = false;
  bool descriptionErrorVisible = false;

  String imagePath = '';

  ServicePageBloc(this._serviceRepository)
      : super(Event(ServicePageEventsType.getServices)) {
    on<Event>((event, emit) async {
      switch (event.eventType) {
        case ServicePageEventsType.getServices:
          emit.call(Loading(event.eventType));
          try {
            services = await _serviceRepository.getServices();
            servicesFiltered = services;
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;

        case ServicePageEventsType.filterByName:
          emit.call(Loading(event.eventType));
          if (event.data == '') {
            servicesFiltered = services;
          }
          try {
            servicesFiltered = services
                .where((element) => element.name!
                    .toLowerCase()
                    .contains((event.data as String).toLowerCase()))
                .toList();
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ServicePageEventsType.getServicesById:
          emit.call(Loading(event.eventType));
          try {
            _serviceRepository
                .getServicebyId(event.data as String)
                .then((value) {
              emit(Event(ServicePageEventsType.getServicesById, data: value));
            });
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ServicePageEventsType.addService:
          emit.call(Loading(event.eventType));
          try {
            _serviceRepository.addService(event.data as ServiceModel);
            services.add(event.data as ServiceModel);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ServicePageEventsType.updateService:
          emit.call(Loading(event.eventType));
          try {
            _serviceRepository.updateService(event.data as ServiceModel);
            services.removeWhere((element) => element.serviceId == event.data);
            services.add(event.data as ServiceModel);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ServicePageEventsType.deleteService:
          emit.call(Loading(event.eventType));
          ServiceModel service = event.data as ServiceModel;
          try {
            _serviceRepository.deleteService(service.serviceId!);
            _serviceRepository.deleteImagenStorage(service);
            services.removeWhere(
                (element) => element.serviceId == service.serviceId);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ServicePageEventsType.addImagenStorage:
          emit.call(Loading(event.eventType));
          try {
            String imageData = event.data[2];
            imagePath = imageData == ''
                ? ''
                : await _serviceRepository.addImagenStorage(
                    event.data[0] as String,
                    event.data[1] as String,
                    event.data[2] as String);
            (event.data[3] as Function)(imagePath);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
      }
      switch (event.eventType) {
        case ServicePageErrorsType.serviceNameNoValido:
          String name = event.data as String;
          final nameRegex = RegExp(
              r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s-]{2,}$'); // Aceptar solo letras, espacios y guiones, mínimo 2 caracteres
          bool isValidName = nameRegex.hasMatch(name);

          if (name.isEmpty) {
            emit.call(Failure(event.eventType));
            nameError = ServicesStrings.serviceNameRequired;
            nameErrorVisible = true;
            return;
          } else if (!isValidName) {
            emit.call(Failure(event.eventType));
            nameError = ServicesStrings.serviceNameInvalid;
            nameErrorVisible = true;
            return;
          } else {
            nameErrorVisible = false;
            nameError = '';
            emit.call(Success(event.eventType));
          }
          break;
        case ServicePageErrorsType.servicePriceNoValido:
          double? price = double.tryParse(event.data as String);
          String priceString = price.toString();
          int dotIndex = priceString.indexOf('.');
          if (price == null) {
            emit.call(Failure(event.eventType));
            priceError = ServicesStrings.servicePriceRequired;
            priceErrorVisible = true;
          } else if (price.isNegative || price == 0) {
            emit.call(Failure(event.eventType));
            priceError = ServicesStrings.servicePriceInvalidNegative;
            priceErrorVisible = true;
          } else if (dotIndex != -1 &&
              priceString.substring(dotIndex + 1).length > 2) {
            emit.call(Failure(event.eventType));
            priceError = ServicesStrings.servicePriceInvalidDecimals;
            priceErrorVisible = true;
          } else {
            priceErrorVisible = false;
            priceError = '';
            emit.call(Success(event.eventType));
          }
          break;
        case ServicePageErrorsType.serviceDescriptionNoValido:
          String description = event.data as String;
          if (description.isEmpty) {
            descriptionErrorVisible = false;
            descriptionError = '';
            emit.call(Success(event.eventType));
          } else if (description.length < 5) {
            emit.call(Failure(event.eventType));
            descriptionError = ServicesStrings.serviceDescriptionInvalid;
            descriptionErrorVisible = true;
          } else {
            descriptionErrorVisible = false;
            descriptionError = '';
            emit.call(Success(event.eventType));
          }
          break;
      }
    });
  }
}
