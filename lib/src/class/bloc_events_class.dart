abstract class BlocEvent {
  final dynamic eventType;
  final dynamic data;

  BlocEvent(this.eventType, {this.data});
}

class Event extends BlocEvent {
  Event(super.evenType, {super.data});
}

class Loading extends BlocEvent {
  Loading(super.evenType, {super.data});
}

class Success extends BlocEvent {
  Success(super.evenType, {super.data});
}

class Failure extends BlocEvent {
  final dynamic errorType;

  Failure(super.evenType, {super.data, this.errorType});
}
