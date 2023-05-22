part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventSuccess extends EventState {
  final List<Event> events;

  const EventSuccess({required this.events});

  @override
  List<Object> get props => [events];
}

class EventFailure extends EventState {
  final String message;

  const EventFailure({required this.message});

  @override
  List<Object> get props => [message];
}

//search for any event

class SearchEventLoading extends EventState {}

class SearchEventSuccess extends EventState {
  final List<Event> events;

  const SearchEventSuccess({required this.events});

  @override
  List<Object> get props => [events];
}

class SearchEventFailure extends EventState {
  final String message;

  const SearchEventFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// twitter spaces

class TwitterLoading extends EventState {}

class TwitterSuccess extends EventState {
  final List<TwitterModel> spaces;

  const TwitterSuccess({required this.spaces});

  @override
  List<Object> get props => [spaces];
}

class TwitterFailure extends EventState {
  final String message;

  const TwitterFailure({required this.message});

  @override
  List<Object> get props => [message];
}

//search for any Twitter

class SearchTwitterLoading extends EventState {}

class SearchTwitterSuccess extends EventState {
  final List<TwitterModel> spaces;

  const SearchTwitterSuccess({required this.spaces});

  @override
  List<Object> get props => [spaces];
}

class SearchTwitterFailure extends EventState {
  final String message;

  const SearchTwitterFailure({required this.message});

  @override
  List<Object> get props => [message];
}

//search groups

class GroupsLoading extends EventState {}

class GroupsSuccess extends EventState {
  final List<GroupsModel> groups;

  const GroupsSuccess({required this.groups});

  @override
  List<Object> get props => [groups];
}

class GroupsFailure extends EventState {
  final String message;

  const GroupsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

//search for any Groups

class SearchGroupsLoading extends EventState {}

class SearchGroupsSuccess extends EventState {
  final List<GroupsModel> groups;

  const SearchGroupsSuccess({required this.groups});

  @override
  List<Object> get props => [groups];
}

class SearchGroupsFailure extends EventState {
  final String message;

  const SearchGroupsFailure({required this.message});

  @override
  List<Object> get props => [message];
}
