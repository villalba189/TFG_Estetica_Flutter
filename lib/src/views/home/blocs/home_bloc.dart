import '../../../class/bloc_events_class.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeEventsType {
  initialHome,
  selectedIndex,
}

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
