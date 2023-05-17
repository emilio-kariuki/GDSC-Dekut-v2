part of 'app_functions_cubit.dart';

abstract class AppFunctionsState extends Equatable {
  const AppFunctionsState();

  @override
  List<Object> get props => [];
}


class PasswordVisibile extends AppFunctionsState {
  final bool isVisible;

  const PasswordVisibile({required this.isVisible});

  @override
  List<Object> get props => [isVisible];
}

class PasswordInvisibile extends AppFunctionsState {
  final bool isVisible;

  const PasswordInvisibile({required this.isVisible});

  @override
  List<Object> get props => [isVisible];
}

class TabChanged extends AppFunctionsState {
  final int index;

  const TabChanged({required this.index});

  @override
  List<Object> get props => [index];
}

class CarouselChanged extends AppFunctionsState {
  final int index;

  const CarouselChanged({required this.index});

  @override
  List<Object> get props => [index];
}

class SearchResourceLoading extends AppFunctionsState {}

class SearchResourceSuccess extends AppFunctionsState {
  final List<Resource> resources;

  const SearchResourceSuccess({required this.resources});

  @override
  List<Object> get props => [resources];
}

class SearchResourceFailure extends AppFunctionsState {
  final String message;

  const SearchResourceFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AlignmentChanged extends AppFunctionsState {
  final bool alignment;

  const AlignmentChanged({required this.alignment});

  @override
  List<Object> get props => [alignment];
}