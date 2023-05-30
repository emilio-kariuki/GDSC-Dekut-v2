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

class AlignmentChanged extends AppFunctionsState {
  final bool alignment;

  const AlignmentChanged({required this.alignment});

  @override
  List<Object> get props => [alignment];
}

class ImagePicked extends AppFunctionsState {
  final File image;
  final String imageUrl;

  const ImagePicked({required this.image, required this.imageUrl});

  @override
  List<Object> get props => [image, imageUrl];
}

class ImagePickingFailed extends AppFunctionsState {
  final String message;

  const ImagePickingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class ImageUploading extends AppFunctionsState {
  final File image;

  const ImageUploading({required this.image});

  @override
  List<Object> get props => [image];
}

class UpdateUserLoading extends AppFunctionsState {}

class UpdateUserSuccess extends AppFunctionsState {}

class UpdateUserFailure extends AppFunctionsState {
  final String message;

  const UpdateUserFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class GetLeadsLoading extends AppFunctionsState {}

class GetLeadsSuccess extends AppFunctionsState {
  final List<LeadsModel> leads;

  const GetLeadsSuccess({required this.leads});

  @override
  List<Object> get props => [leads];
}

class GetLeadsFailure extends AppFunctionsState {
  final String message;

  const GetLeadsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ResourceDeleted extends AppFunctionsState {}

class ResourceDeletionFailed extends AppFunctionsState {
  final String message;

  const ResourceDeletionFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class FeedbackSent extends AppFunctionsState {}

class FeedbackSendingFailed extends AppFunctionsState {
  final String message;

  const FeedbackSendingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class ReportProblemSent extends AppFunctionsState {}

class ReportProblemSendingFailed extends AppFunctionsState {
  final String message;

  const ReportProblemSendingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class TwitterSpaceLoading extends AppFunctionsState {}

class TwitterSpaceSuccess extends AppFunctionsState {
  final List<TwitterModel> spaces;

  const TwitterSpaceSuccess({required this.spaces});

  @override
  List<Object> get props => [spaces];
}

class TwitterSpaceFailure extends AppFunctionsState {
  final String message;

  const TwitterSpaceFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class DropDownChanged extends AppFunctionsState {
  final String value;

  const DropDownChanged({required this.value});

  @override
  List<Object> get props => [value];
}

class ResourceSending extends AppFunctionsState {}

class ResourceSent extends AppFunctionsState {}

class ResourceSendingFailed extends AppFunctionsState {
  final String message;

  const ResourceSendingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class Copied extends AppFunctionsState {}

class CopyingFailed extends AppFunctionsState {
  final String message;

  const CopyingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class Saved extends AppFunctionsState {}

class Saving extends AppFunctionsState {}

class SavingFailed extends AppFunctionsState {
  final String message;

  const SavingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class EventFetched extends AppFunctionsState {
  final Event event;

  const EventFetched({required this.event});

  @override
  List<Object> get props => [event];
}

class EventFetchingFailed extends AppFunctionsState {
  final String message;

  const EventFetchingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class EventUpdating extends AppFunctionsState {}

class EventUpdated extends AppFunctionsState {}

class EventUpdatingFailed extends AppFunctionsState {
  final String message;

  const EventUpdatingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class PickTime extends AppFunctionsState {
  final String time;

  const PickTime({required this.time});

  @override
  List<Object> get props => [time];
}



class PickDate extends AppFunctionsState {
  final DateTime date;

  const PickDate({required this.date});

  @override
  List<Object> get props => [date];
}

class EventCompleted extends AppFunctionsState {}

class CompleteEventFailed extends AppFunctionsState {}

class EventStarted extends AppFunctionsState {}

class StartEventFailed extends AppFunctionsState {}


class EventCreated extends AppFunctionsState {}

class EventCreating extends AppFunctionsState {}

class CreateEventFailed extends AppFunctionsState {}


