// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_bloc/data/Models/announcement_model.dart';
import 'package:gdsc_bloc/data/Models/event_model.dart';
import 'package:gdsc_bloc/data/Models/feedback_model.dart';
import 'package:gdsc_bloc/data/Models/groups_model.dart';
import 'package:gdsc_bloc/data/Models/leads_model.dart';
import 'package:gdsc_bloc/data/Models/report_model.dart';
import 'package:gdsc_bloc/data/Models/resource_model.dart';
import 'package:gdsc_bloc/data/Models/twitter_model.dart';
import 'package:gdsc_bloc/data/Models/user_model.dart';
import 'package:gdsc_bloc/data/Services/Providers/providers.dart';
import 'package:gdsc_bloc/utilities/shared_preference_manager.dart';

import '../event_bloc/event_bloc.dart';
part 'app_functions_state.dart';

class AppFunctionsCubit extends Cubit<AppFunctionsState> {
  AppFunctionsCubit() : super(const PasswordVisibile(isVisible: false));

  void changePasswordVisibility({required bool isVisible}) {
    if (isVisible) {
      emit(PasswordVisibile(isVisible: isVisible));
    } else {
      emit(PasswordInvisibile(isVisible: !isVisible));
    }
  }

  void changeTab({required int index}) {
    emit(TabChanged(index: index));
  }

  void changeCarousel({required int index}) {
    emit(CarouselChanged(index: index));
  }

  void changeAlignment({required bool align}) {
    emit(AlignmentChanged(alignment: !align));
  }

  void getImage() async {
    try {
      final pickedFile = await Providers().getImage();
      emit(ImageUploading(image: pickedFile));
      final imageUrl = await Providers().uploadImage(image: pickedFile);

      Future.delayed(const Duration(milliseconds: 1500));
      emit(ImagePicked(image: File(pickedFile.path), imageUrl: imageUrl));
    } catch (e) {
      emit(ImagePickingFailed(message: e.toString()));
    }
  }

  void updateUser({
    required String name,
    required String email,
    required String phone,
    required String github,
    required String linkedin,
    required String twitter,
    required String userId,
    required String technology,
    required String image,
  }) async {
    try {
      final user = await Providers().updateUser(
        name: name,
        email: email,
        phone: phone,
        github: github,
        linkedin: linkedin,
        twitter: twitter,
        userId: userId,
        technology: technology,
        image: image,
      );

      if (user) {
        emit(UpdateUserSuccess());
      } else {
        emit(const UpdateUserFailure(message: 'Failed to update user'));
      }
    } catch (e) {
      emit(UpdateUserFailure(message: e.toString()));
    }
  }

  void updateAnnouncement(
      {required String id,
      required String name,
      required String position,
      required String title}) async {
    try {
      emit(AnnouncementUpdating());
      final user = await Providers().updateParticularAnnouncement(
        id: id,
        name: name,
        position: position,
        title: title,
      );

      if (user) {
        emit(AnnouncementUpdated());
      } else {
        emit(
            const AnnouncementUpdatingFailed(message: 'Failed to update user'));
      }
    } catch (e) {
      emit(AnnouncementUpdatingFailed(message: e.toString()));
    }
  }

  void getLeads() async {
    try {
      emit(GetLeadsLoading());
      final leads = await Providers().getLeads();
      emit(GetLeadsSuccess(leads: leads));
    } catch (e) {
      emit(GetLeadsFailure(message: e.toString()));
    }
  }

  void deleteResource({required String id}) async {
    try {
      final isDeleted = await Providers().deleteResource(id: id);

      if (isDeleted) {
        emit(GroupDeleted());
      } else {
        emit(const GroupDeletionFailed(message: 'Failed to delete Group'));
      }
    } catch (e) {
      emit(GroupDeletionFailed(message: e.toString()));
    }
  }

  void deleteGroup({required String id}) async {
    try {
      final isDeleted = await Providers().deleteParticularGroup(id: id);

      if (isDeleted) {
        emit(ResourceDeleted());
      } else {
        emit(
            const ResourceDeletionFailed(message: 'Failed to delete resource'));
      }
    } catch (e) {
      emit(ResourceDeletionFailed(message: e.toString()));
    }
  }

  void deleteAnnouncement({required String id}) async {
    try {
      final isDeleted = await Providers().deleteParticularAnnouncement(id: id);

      if (isDeleted) {
        emit(AnnouncementDeleted());
      } else {
        emit(const AnnouncementDeletionFailed(
            message: 'Failed to delete announcement'));
      }
    } catch (e) {
      emit(ResourceDeletionFailed(message: e.toString()));
    }
  }

  void deleteEvent({required String id}) async {
    try {
      final isDeleted = await Providers().deleteEvent(id: id);

      if (isDeleted) {
        emit(EventDeleted());
      } else {
        emit(const EventDeletionFailed(message: 'Failed to delete Event'));
      }
    } catch (e) {
      emit(EventDeletionFailed(message: e.toString()));
    }
  }

  void deleteLead({required String email}) async {
    try {
      final isDeleted = await Providers().deleteLead(email: email);

      if (isDeleted) {
        emit(LeadDeleted());
      } else {
        emit(const LeadDeletionFailed(message: 'Failed to delete lead'));
      }
    } catch (e) {
      emit(LeadDeletionFailed(message: e.toString()));
    }
  }

  void deleteSpace({required String id}) async {
    try {
      final isDeleted = await Providers().deleteParticularSpace(id: id);

      if (isDeleted) {
        emit(SpaceDeleted());
      } else {
        emit(const SpaceDeletionFailed(message: 'Failed to delete Space'));
      }
    } catch (e) {
      emit(SpaceDeletionFailed(message: e.toString()));
    }
  }

  void sendFeedBack({required String feedback}) async {
    try {
      final isSent = await Providers().createFeedback(feedback: feedback);

      if (isSent) {
        emit(FeedbackSent());
      } else {
        emit(const FeedbackSendingFailed(message: 'Failed to send feedback'));
      }
    } catch (e) {
      emit(FeedbackSendingFailed(message: e.toString()));
    }
  }

  void reportProblem({
    required String title,
    required String description,
    required String appVersion,
    required String contact,
    required String image,
  }) async {
    try {
      final isSent = await Providers().reportProblem(
        title: title,
        description: description,
        appVersion: appVersion,
        contact: contact,
        image: image,
      );

      if (isSent) {
        emit(ReportProblemSent());
      } else {
        emit(const ReportProblemSendingFailed(
            message: 'Failed to report problem'));
      }
    } catch (e) {
      emit(ReportProblemSendingFailed(message: e.toString()));
    }
  }

  void getTwitterSpaces() async {
    try {
      emit(TwitterSpaceLoading());
      final twitterSpaces = await Providers().getSpaces();
      emit(TwitterSpaceSuccess(spaces: twitterSpaces));
    } catch (e) {
      emit(TwitterSpaceFailure(message: e.toString()));
    }
  }

  void dropDownClicked({required String value}) {
    emit(DropDownChanged(value: value));
  }

  void createResource({
    required String title,
    required String link,
    required String imageUrl,
    required String description,
    required String category,
  }) async {
    try {
      final isCreated = await Providers().createResource(
        title: title,
        link: link,
        imageUrl: imageUrl,
        description: description,
        category: category,
      );

      if (isCreated) {
        emit(ResourceSent());
      } else {
        emit(const ResourceSendingFailed(message: 'Failed to send resource'));
      }
    } catch (e) {
      emit(ResourceSendingFailed(message: e.toString()));
    }
  }

  void createAnnouncement({
    required String title,
    required String name,
    required String position,
  }) async {
    try {
      emit(AnnouncementCreating());
      final isCreated = await Providers().createAnnouncement(
        title: title,
        name: name,
        position: position,
      );

      if (isCreated) {
        emit(AnnouncementCreated());
      } else {
        emit(CreateAnnouncementFailed());
      }
    } catch (e) {
      emit(CreateAnnouncementFailed());
    }
  }

  void createAdminResource({
    required String title,
    required String link,
    required String imageUrl,
    required String description,
    required String category,
  }) async {
    try {
      final isCreated = await Providers().createAdminResource(
        title: title,
        link: link,
        imageUrl: imageUrl,
        description: description,
        category: category,
      );

      if (isCreated) {
        emit(ResourceSent());
      } else {
        emit(const ResourceSendingFailed(message: 'Failed to send resource'));
      }
    } catch (e) {
      emit(ResourceSendingFailed(message: e.toString()));
    }
  }

  void copyToClipboard({required String text}) async {
    try {
      await Providers().copyToClipboard(text: text);
      emit(Copied());
    } catch (e) {
      emit(CopyingFailed(message: e.toString()));
    }
  }

  void downloadAndSaveImage(
      {required String image, required String fileName}) async {
    try {
      emit(Saving());
      await Providers().downloadAndSaveImage(url: image, fileName: fileName);
      emit(Saved());
    } catch (e) {
      emit(SavingFailed(message: e.toString()));
    }
  }

  void fetchEvent({required String id}) async {
    try {
      final event = await Providers().getParticularEvent(id: id);

      if (event != null) {
        emit(EventFetched(event: event));
      } else {
        emit(const EventFetchingFailed(message: 'Failed to fetch event'));
      }
    } catch (e) {
      emit(EventFetchingFailed(message: e.toString()));
    }
  }

  void fetchLead({required String email}) async {
    try {
      final lead = await Providers().getLead(email: email);
      if (lead != null) {
        emit(LeadFetched(lead: lead));
      } else {
        emit(const LeadFetchingFailed(message: 'Failed to fetch Lead'));
      }
    } catch (e) {
      emit(LeadFetchingFailed(message: e.toString()));
    }
  }

  void fetchAnnouncement({required String id}) async {
    try {
      final announcement = await Providers().getParticularAnnouncement(id: id);

      if (announcement != null) {
        emit(AnnouncementFetched(announcement: announcement));
      } else {
        emit(const AnnouncementFetchingFailed(
            message: 'Failed to fetch Announcement'));
      }
    } catch (e) {
      emit(AnnouncementFetchingFailed(message: e.toString()));
    }
  }

  void updateEvent({
    required String id,
    required String title,
    required String venue,
    required String organizers,
    required String link,
    required String imageUrl,
    required String description,
    required String startTime,
    required String endTime,
    required Timestamp date,
  }) async {
    try {
      emit(EventUpdating());
      final isUpdated = await Providers().updateEvent(
        id: id,
        title: title,
        venue: venue,
        organizers: organizers,
        link: link,
        imageUrl: imageUrl,
        description: description,
        startTime: startTime,
        endTime: endTime,
        date: date,
      );

      if (isUpdated) {
        emit(EventUpdated());
        EventBloc().add(GetEvents());
      } else {
        emit(const EventUpdatingFailed(message: 'Failed to update event'));
      }
    } catch (e) {
      emit(EventUpdatingFailed(message: e.toString()));
    }
  }

  void updateSpace({
    required String id,
    required String title,
    required String link,
    required Timestamp startTime,
    required Timestamp endTime,
    required String image,
    required Timestamp date,
  }) async {
    try {
      emit(SpaceUpdating());
      final isUpdated = await Providers().updateSpace(
        id: id,
        title: title,
        link: link,
        startTime: startTime,
        endTime: endTime,
        image: image,
        date: date,
      );

      if (isUpdated) {
        emit(SpaceUpdated());
      } else {
        emit(const SpaceUpdatingFailed(message: 'Failed to update Space'));
      }
    } catch (e) {
      emit(SpaceUpdatingFailed(message: e.toString()));
    }
  }

  void pickTime({required BuildContext context}) async {
    final time = await Providers().selectTime(context);
    emit(PickTime(time: time));
  }

  void pickSpaceTime({required BuildContext context}) async {
    final time = await Providers().selectSpaceTime(context);
    emit(PickSpaceTime(time: time));
  }

  void pickDate({required BuildContext context}) async {
    final date = await Providers().selectDate(context);
    emit(PickDate(date: date!));
  }

  void completeEvent({required String id}) async {
    try {
      final isCompleted = await Providers().completeEvent(id: id);

      if (isCompleted) {
        emit(EventCompleted());
      } else {
        emit(CompleteEventFailed());
      }
    } catch (e) {
      emit(CompleteEventFailed());
    }
  }

  void startEvent({required String id}) async {
    try {
      final isCompleted = await Providers().startParticularEvent(id: id);

      if (isCompleted) {
        emit(EventStarted());
      } else {
        emit(StartEventFailed());
      }
    } catch (e) {
      emit(StartEventFailed());
    }
  }

  void createEvent({
    required String title,
    required String venue,
    required String organizers,
    required String link,
    required String imageUrl,
    required String description,
    required String startTime,
    required String endTime,
    required Timestamp date,
  }) async {
    try {
      emit(EventCreating());
      final isCreated = await Providers().createEvent(
        title: title,
        venue: venue,
        organizers: organizers,
        link: link,
        imageUrl: imageUrl,
        description: description,
        startTime: startTime,
        endTime: endTime,
        date: date,
      );

      if (isCreated) {
        emit(EventCreated());
      } else {
        emit(CreateEventFailed());
      }
    } catch (e) {
      emit(CreateEventFailed());
    }
  }

  void createLead({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String github,
    required String twitter,
    required String bio,
    required String image,
  }) async {
    try {
      emit(LeadCreating());
      final isCreated = await Providers().createLead(
        name: name,
        email: email,
        phone: phone,
        role: role,
        github: github,
        twitter: twitter,
        bio: bio,
        image: image,
      );

      if (isCreated) {
        emit(LeadCreated());
      } else {
        emit(CreateLeadFailed());
      }
    } catch (e) {
      emit(CreateLeadFailed());
    }
  }

  void updateLead({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String github,
    required String twitter,
    required String bio,
    required String image,
  }) async {
    try {
      emit(LeadUpdating());
      final isCreated = await Providers().updateLead(
        name: name,
        email: email,
        phone: phone,
        role: role,
        github: github,
        twitter: twitter,
        bio: bio,
        image: image,
      );

      if (isCreated) {
        emit(LeadUpdated());
      } else {
        emit(const LeadUpdatingFailed(message: "Failed to update the lead"));
      }
    } catch (e) {
      emit(const LeadUpdatingFailed(message: "Failed to update the lead"));
    }
  }

  void createSpace({
    required String title,
    required String link,
    required Timestamp startTime,
    required Timestamp endTime,
    required String image,
    required Timestamp date,
  }) async {
    try {
      emit(SpaceCreating());
      final isCreated = await Providers().createSpace(
        title: title,
        link: link,
        startTime: startTime,
        endTime: endTime,
        image: image,
        date: date,
      );
      if (isCreated) {
        emit(SpaceCreated());
      } else {
        emit(CreateSpaceFailed());
      }
    } catch (e) {
      emit(CreateSpaceFailed());
    }
  }

  void createGroup({
    required String title,
    required String description,
    required String imageUrl,
    required String link,
  }) async {
    try {
      emit(GroupCreating());
      final isCreated = await Providers().createGroup(
        title: title,
        description: description,
        imageUrl: imageUrl,
        link: link,
      );

      if (isCreated) {
        emit(GroupCreated());
      } else {
        emit(CreateGroupFailed());
      }
    } catch (e) {
      emit(CreateGroupFailed());
    }
  }

  void approveResource({required String id}) async {
    try {
      final isApproved = await Providers().approveResource(id: id);

      if (isApproved) {
        emit(ResourceApproved());
      } else {
        emit(const ApprovingResourceFailed(
            message: "Failed to approve resource"));
      }
    } catch (e) {
      emit(
          const ApprovingResourceFailed(message: "Failed to approve resource"));
    }
  }

  void fetchResource({required String id}) async {
    try {
      emit(FetchResourcesLoading());
      final resource = await Providers().getParticularResource(id: id);

      if (resource != null) {
        emit(FetchResourceSuccess(resource: resource));
      } else {
        emit(const FetchResourceFailure(message: "Failed to fetch resource"));
      }
    } catch (e) {
      emit(const FetchResourceFailure(message: "Failed to fetch resource"));
    }
  }

  void fetchSpace({required String id}) async {
    try {
      emit(FetchSpacesLoading());
      final space = await Providers().getParticularSpaces(id: id);

      if (space != null) {
        emit(FetchSpaceSuccess(space: space));
      } else {
        emit(const FetchSpaceFailure(message: "Failed to fetch Space"));
      }
    } catch (e) {
      emit(const FetchSpaceFailure(message: "Failed to fetch Space"));
    }
  }

  void fetchGroup({required String id}) async {
    try {
      emit(FetchGroupLoading());
      final group = await Providers().getParticularGroup(id: id);

      if (group != null) {
        emit(FetchGroupSuccess(group: group));
      } else {
        emit(const FetchGroupFailure(message: "Failed to fetch Group"));
      }
    } catch (e) {
      emit(const FetchGroupFailure(message: "Failed to fetch Group"));
    }
  }

  void updateGroup({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required String link,
  }) async {
    try {
      emit(GroupUpdating());
      final isUpdated = await Providers().updateGroup(
        id: id,
        title: title,
        link: link,
        imageUrl: imageUrl,
        description: description,
      );

      if (isUpdated) {
        emit(GroupUpdated());
      } else {
        emit(const GroupUpdatingFailed(message: "Failed to update Group"));
      }
    } catch (e) {
      emit(const GroupUpdatingFailed(message: "Failed to update Group"));
    }
  }

  void updateResource({
    required String id,
    required String title,
    required String link,
    required String imageUrl,
    required String description,
    required String category,
  }) async {
    try {
      emit(ResourceUpdating());
      final isUpdated = await Providers().updateResource(
        id: id,
        title: title,
        link: link,
        imageUrl: imageUrl,
        description: description,
        category: category,
      );

      if (isUpdated) {
        emit(ResourceUpdated());
      } else {
        emit(
            const ResourceUpdatingFailed(message: "Failed to update resource"));
      }
    } catch (e) {
      emit(const ResourceUpdatingFailed(message: "Failed to update resource"));
    }
  }

  void fetchFeedback() async {
    try {
      emit(FeedbackLoading());
      final feedback = await Providers().getFeedback();

      if (feedback != null) {
        emit(FeedbackSuccess(feedback: feedback));
      } else {
        emit(const FeedbackFailure(message: "Failed to  feedback"));
      }
    } catch (e) {
      emit(const FeedbackFailure(message: "Failed to  feedback"));
    }
  }

  void getReports() async {
    try {
      emit(ReportLoading());
      final reports = await Providers().getReports();

      if (reports != null) {
        emit(ReportSuccess(reports: reports));
      } else {
        emit(const ReportFailure(message: "Failed to  reports"));
      }
    } catch (e) {
      emit(const ReportFailure(message: "Failed to  reports"));
    }
  }

  void fetchUser() async {
    try {
      emit(UserFetching());
      final userId = await SharedPreferencesManager().getId();
      final user = await Providers().getUser(userId: userId);

      if (user != null) {
        emit(UserFetched(user: user));
      } else {
        emit(const UserFetchingFailed(message: "Failed to  user"));
      }
    } catch (e) {
      emit(const UserFetchingFailed(message: "Failed to  user"));
    }
  }
}
