import 'package:estetica_app/src/views/home/enums/home_events_type.dart';

import '../../../class/bloc_events_class.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<BlocEvent, BlocEvent> {
  int selectedIndex = 0;
  HomeBloc() : super(Event(HomeEventsType.initialHome)) {
    on<Event>((event, emit) {
      switch (event.eventType) {
        case HomeEventsType.initialHome:
          emit(Event(HomeEventsType.initialHome));
          break;
        case HomeEventsType.selectedIndex:
          selectedIndex = event.data;
          emit.call(Event(HomeEventsType.selectedIndex, data: selectedIndex));
          break;
      }
    });
  }
}
