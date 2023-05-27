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

class ImageUploading extends AppFunctionsState {}

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

