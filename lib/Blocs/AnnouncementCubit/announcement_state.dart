part of 'announcement_cubit.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();

  @override
  List<Object> get props => [];
}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

class AnnouncementSuccess extends AnnouncementState {
  final List<AnnouncementModel> announcements;

  const AnnouncementSuccess({required this.announcements});

  @override
  List<Object> get props => [announcements];
}

class AnnouncementFailure extends AnnouncementState {
  final String message;

  const AnnouncementFailure({required this.message});

  @override
  List<Object> get props => [message];
}
