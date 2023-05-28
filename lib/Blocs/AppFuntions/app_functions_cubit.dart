import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_bloc/Data/Models/leads_model.dart';
import 'package:gdsc_bloc/Data/Models/twitter_model.dart';
import 'package:gdsc_bloc/Data/Repository/providers.dart';
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
      final imageUrl = await Providers().uploadImage(image: pickedFile);
      emit(ImageUploading());
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

  void getLeads() async {
    try {
      emit(GetLeadsLoading());
      final leads = await Providers().getLeads();
      emit(GetLeadsSuccess(leads: leads));
    } catch (e) {
      emit(GetLeadsFailure(message: e.toString()));
    }
  }

  void deleteResource({required String title}) async {
    try {
      final isDeleted = await Providers().deleteResource(title: title);

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
}
