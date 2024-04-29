import 'package:estetica_app/src/class/bloc_events_class.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_repository/service_repository.dart';

enum ServicePageState {
  getServices,
  getServicesById,
  addService,
  updateService,
  deleteService,
}

class ServicePageBloc extends Bloc<BlocEvent, BlocEvent> {
  final ServiceRepo _serviceRepository;
  List<ServiceModel> services = [];
  ServicePageBloc(this._serviceRepository)
      : super(Event(ServicePageState.getServices)) {
    on<Event>((event, emit) async {
      switch (event.eventType) {
        case ServicePageState.getServices:
          emit.call(Loading(event.eventType));
          try {
            _serviceRepository.getServices().then((value) {
              services = value;
            });
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ServicePageState.getServicesById:
          emit.call(Loading(event.eventType));
          try {
            _serviceRepository
                .getServicebyId(event.data as String)
                .then((value) {
              emit(Event(ServicePageState.getServicesById, data: value));
            });
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ServicePageState.addService:
          emit.call(Loading(event.eventType));
          try {
            _serviceRepository.addService(event.data as ServiceModel);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ServicePageState.updateService:
          emit.call(Loading(event.eventType));
          try {
            _serviceRepository.updateService(event.data as ServiceModel);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ServicePageState.deleteService:
          emit.call(Loading(event.eventType));
          try {
            _serviceRepository.deleteService(event.data as String);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
      }
    });
  }
}
