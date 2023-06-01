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

class GetPastEvents extends EventEvent {}

class SearchPastEvent extends EventEvent {
  final String query;

  const SearchPastEvent({required this.query});

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

class GetResource extends EventEvent {
  final String category;

  const GetResource({required this.category});

  @override
  List<Object> get props => [category];
}

class GetAllResource extends EventEvent {
  const GetAllResource();
}

class GetAllAnnouncements extends EventEvent {
  const GetAllAnnouncements();
}
class SearchAnnouncement extends EventEvent {
  final String query;

  const SearchAnnouncement({required this.query});

  @override
  List<Object> get props => [query];
}


class GetUnApprovedResource extends EventEvent {
  const GetUnApprovedResource();
}

class GetUserResources extends EventEvent {}

class SearchUserResource extends EventEvent {
  final String query;

  const SearchUserResource({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchUnApprovedResource extends EventEvent {
  final String query;

  const SearchUnApprovedResource({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchResource extends EventEvent {
  final String query;

  const SearchResource({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchCategoryResource extends EventEvent {
  final String query;
  final String category;

  const SearchCategoryResource({required this.query, required this.category});

  @override
  List<Object> get props => [query, category];
}

class GetDevelopers extends EventEvent {}

class Initial extends EventEvent {}
