part of 'app_functions_cubit.dart';

abstract class AppFunctionsState extends Equatable{
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

class EventDeleted extends AppFunctionsState {}

class EventDeletionFailed extends AppFunctionsState {
  final String message;

   const EventDeletionFailed({required this.message});

  @override
  List<Object> get props => [message];
}


class GroupDeleted extends AppFunctionsState {}

class GroupDeletionFailed extends AppFunctionsState {
  final String message;

   const GroupDeletionFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class AnnouncementDeleted extends AppFunctionsState {}

class AnnouncementDeletionFailed extends AppFunctionsState {
  final String message;

   const AnnouncementDeletionFailed({required this.message});

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




class LeadFetched extends AppFunctionsState {
  final LeadsModel lead;

   const LeadFetched({required this.lead});

  @override
  List<Object> get props => [lead];
}



class LeadFetchingFailed extends AppFunctionsState {
  final String message;

   const LeadFetchingFailed({required this.message});

  @override
  List<Object> get props => [message];
}


class AnnouncementFetched extends AppFunctionsState {
  final AnnouncementModel announcement;

   const AnnouncementFetched({required this.announcement});

  @override
  List<Object> get props => [announcement];
}

class AnnouncementFetchingFailed extends AppFunctionsState {
  final String message;

   const AnnouncementFetchingFailed({required this.message});

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



class LeadUpdating extends AppFunctionsState {}

class LeadUpdated extends AppFunctionsState {}

class LeadUpdatingFailed extends AppFunctionsState {
  final String message;

   const LeadUpdatingFailed({required this.message});

  @override
  List<Object> get props => [message];
}


class GroupUpdating extends AppFunctionsState {}

class GroupUpdated extends AppFunctionsState {}

class GroupUpdatingFailed extends AppFunctionsState {
  final String message;

   const GroupUpdatingFailed({required this.message});

  @override
  List<Object> get props => [message];
}




class SpaceUpdating extends AppFunctionsState {}

class SpaceUpdated extends AppFunctionsState {}

class SpaceUpdatingFailed extends AppFunctionsState {
  final String message;

   const SpaceUpdatingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class AnnouncementUpdating extends AppFunctionsState {}

class AnnouncementUpdated extends AppFunctionsState {}

class AnnouncementUpdatingFailed extends AppFunctionsState {
  final String message;

   const AnnouncementUpdatingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class ResourceUpdating extends AppFunctionsState {}

class ResourceUpdated extends AppFunctionsState {}

class ResourceUpdatingFailed extends AppFunctionsState {
  final String message;

   const ResourceUpdatingFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class PickTime extends AppFunctionsState {
  final String time;

   const PickTime({required this.time});

  @override
  List<Object> get props => [time];
}

class PickSpaceTime extends AppFunctionsState {
  final Timestamp time;

   const PickSpaceTime({required this.time});

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



class LeadCreated extends AppFunctionsState {}

class LeadCreating extends AppFunctionsState{}
class CreateLeadFailed extends AppFunctionsState {}





class SpaceCreated extends AppFunctionsState {}

class SpaceCreating extends AppFunctionsState {}

class CreateSpaceFailed extends AppFunctionsState {}




class GroupCreated extends AppFunctionsState {}

class GroupCreating extends AppFunctionsState {}

class CreateGroupFailed extends AppFunctionsState {}



class AnnouncementCreated extends AppFunctionsState {}

class AnnouncementCreating extends AppFunctionsState {}

class CreateAnnouncementFailed extends AppFunctionsState {}




class ApprovingResource extends AppFunctionsState {}

class ResourceApproved extends AppFunctionsState {}

class ApprovingResourceFailed extends AppFunctionsState {
  final String message;

   const ApprovingResourceFailed({required this.message});

  @override
  List<Object> get props => [message];
}




class FetchResourcesLoading extends AppFunctionsState {}

class FetchResourceSuccess extends AppFunctionsState {
  final Resource resource;

   const FetchResourceSuccess({required this.resource});

  @override
  List<Object> get props => [resource];
}

class FetchResourceFailure extends AppFunctionsState {
  final String message;

   const FetchResourceFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class FetchSpacesLoading extends AppFunctionsState {}

class FetchSpaceSuccess extends AppFunctionsState {
  final TwitterModel space;

   const FetchSpaceSuccess({required this.space});

  @override
  List<Object> get props => [space];
}


// fetch a s specific group
class FetchGroupLoading extends AppFunctionsState {}

class FetchGroupSuccess extends AppFunctionsState {
  final GroupsModel group;

   const FetchGroupSuccess({required this.group});

  @override
  List<Object> get props => [group];
}

class FetchGroupFailure extends AppFunctionsState {
  final String message;

   const FetchGroupFailure({required this.message});

  @override
  List<Object> get props => [message];
}




class FetchSpaceFailure extends AppFunctionsState {
  final String message;

   const FetchSpaceFailure({required this.message});

  @override
  List<Object> get props => [message];
}


class SpaceDeleted extends AppFunctionsState {}

class SpaceDeletionFailed extends AppFunctionsState {
  final String message;

   const SpaceDeletionFailed({required this.message});

  @override
  List<Object> get props => [message];
}


class LeadDeleted extends AppFunctionsState {}

class LeadDeletionFailed extends AppFunctionsState {
  final String message;

   const LeadDeletionFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class FeedbackLoading extends AppFunctionsState {}

class FeedbackSuccess extends AppFunctionsState {
  final List<FeedbackModel> feedback;

   const FeedbackSuccess({required this.feedback});

  @override
  List<Object> get props => [feedback];
}

class FeedbackFailure extends AppFunctionsState {
  final String message;

   const FeedbackFailure({required this.message});

  @override
  List<Object> get props => [message];
}


class ReportLoading extends AppFunctionsState {}

class ReportSuccess extends AppFunctionsState {
  final List<ReportModel> reports;

   const ReportSuccess({required this.reports});

  @override
  List<Object> get props => [reports];
}

class ReportFailure extends AppFunctionsState {
  final String message;

   const ReportFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class UserFetching extends AppFunctionsState {}
class UserFetched extends AppFunctionsState {
  final UserModel user;

   const UserFetched({required this.user});

  @override
  List<Object> get props => [user];
}

class UserFetchingFailed extends AppFunctionsState {
  final String message;

   const UserFetchingFailed({required this.message});

  @override
  List<Object> get props => [message];
}