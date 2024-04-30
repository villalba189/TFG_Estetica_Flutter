import 'package:estetica_app/src/class/bloc_events_class.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_repository/service_repository.dart';

enum ServicePageEventsType {
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
      : super(Event(ServicePageEventsType.getServices)) {
    on<Event>((event, emit) async {
      switch (event.eventType) {
        case ServicePageEventsType.getServices:
          emit.call(Loading(event.eventType));
          try {
            services = await _serviceRepository.getServices();
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
          try {
            _serviceRepository.deleteService(event.data as String);
            services.removeWhere((element) => element.serviceId == event.data);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
      }
    });
  }
}
