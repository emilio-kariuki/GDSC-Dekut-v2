part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class GetEvents extends EventEvent {}

class SearchEvent extends EventEvent {
  final String query;

  const SearchEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class GetSpaces extends EventEvent {}

class SearchSpace extends EventEvent {
  final String query;

  const SearchSpace({required this.query});

  @override
  List<Object> get props => [query];
}

class GetGroups extends EventEvent {}

class SearchGroup extends EventEvent {
  final String query;

  const SearchGroup({required this.query});

  @override
  List<Object> get props => [query];
}
