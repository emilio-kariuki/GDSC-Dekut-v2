import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_bloc/Blocs/Network/network_bloc.dart';
import 'package:gdsc_bloc/Data/Models/announcement_model.dart';
import 'package:gdsc_bloc/Data/Models/developer_model.dart';
import 'package:gdsc_bloc/Data/Models/event_model.dart';
import 'package:gdsc_bloc/Data/Models/feedback_model.dart';
import 'package:gdsc_bloc/Data/Models/groups_model.dart';
import 'package:gdsc_bloc/Data/Models/leads_model.dart';
import 'package:gdsc_bloc/Data/Models/report_model.dart';
import 'package:gdsc_bloc/Data/Models/resource_model.dart';
import 'package:gdsc_bloc/Data/Models/twitter_model.dart';
import 'package:gdsc_bloc/Data/Models/user_model.dart';
import 'package:gdsc_bloc/Data/Repository/repository.dart';

class Providers {
  Future<bool> createAccount(
      {required String email,
      required String password,
      required String name}) async {
    var response = Repository().registerUser(
      email: email,
      password: password,
      name: name,
    );
    return response;
  }

  Future<bool> loginAccount(
      {required String email, required String password}) async {
    var response = Repository().loginUser(
      email: email,
      password: password,
    );
    return response;
  }

  Future<bool> logoutAccount() async {
    var response = Repository().logoutUser();
    return response;
  }

  Future<bool> resetPassword({required String email}) async {
    var response = Repository().resetPassword(email: email);
    return response;
  }

  Future<bool> changePassword(
      {required String email,
      required String oldPassword,
      required String newPassword}) async {
    var response = Repository().changePassword(
      email: email,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    return response;
  }

  Future<bool> deleteAccount(
      {required String email, required String password}) async {
    var response = Repository().deleteUser(email: email, password: password);
    return response;
  }

  Future<bool> signInWithGoogle() async {
    var response = Repository().signInWithGoogle();
    return response;
  }

  observeNetwork() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        NetworkBloc().add(const NetworkNotify());
      } else {
        NetworkBloc().add(const NetworkNotify(isConnected: true));
      }
    });
  }

  Stream<List<Event>> getEvents() {
    return Repository().getEvents();
  }

  Future<List<Event>> getEvent() {
    return Repository().getEvent();
  }

  Future<List<Resource>> getResources({required String category}) {
    return Repository().getResources(category: category);
  }

  Future<List<Resource>> getUserResources({required String userId}) async {
    return Repository().getUserResources(userId: userId);
  }

  Future<List<Resource>> searchResources({required String query}) async {
    return Repository().searchResources(query: query);
  }

  Future<List<Resource>> searchUserResources(
      {required String query, required String userId}) async {
    return Repository().searchUserResources(query: query, userId: userId);
  }

  Future<bool> deleteResource({required String id}) async {
    return Repository().deleteResource(id: id);
  }

  Future<List<Resource>> searchCategoryResources(
      {required String query, required String category}) async {
    final response = await Repository()
        .searchCategoryResources(query: query, category: category);

    return response;
  }

  Future<List<Event>> searchEvent({required String query}) async {
    final response = await Repository().searchEvent(query: query);
    return response;
  }

  Future<bool> addEventToCalendar(
      {required String summary,
      required Timestamp start,
      required Timestamp end}) async {
    final response = await Repository()
        .addEventToCalendar(summary: summary, start: start, end: end);

    return response;
  }

  Future<List<TwitterModel>> getSpaces() async {
    final response = await Repository().getSpaces();
    return response;
  }

  Future<List<TwitterModel>> searchSpace({required String query}) async {
    final response = await Repository().searchSpace(query: query);
    return response;
  }

  Future<List<GroupsModel>> getGroups() async {
    final response = await Repository().getGroups();
    return response;
  }

  Future<List<GroupsModel>> searchGroup({required String query}) async {
    final response = await Repository().searchGroup(query: query);
    return response;
  }

  Future<File> getImage() async {
    final response = await Repository().getImage();
    return response;
  }

  Future<UserModel> getUser({required String userId}) async {
    final response = await Repository().getUser(userId: userId);
    return response;
  }

  Future<bool> updateUser({
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
    final response = await Repository().updateUser(
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

    return response;
  }

  Future<String> uploadImage({required File image}) async {
    final imageUrl = await Repository().uploadImage(image: image);
    return imageUrl;
  }

  Future<List<LeadsModel>> getLeads() async {
    final response = await Repository().getLeads();
    return response;
  }

  Future<bool> createFeedback({
    required String feedback,
  }) async {
    final response = await Repository().createFeedback(
      feedback: feedback,
    );
    return response;
  }

  Future<bool> reportProblem({
    required String title,
    required String description,
    required String appVersion,
    required String contact,
    required String image,
  }) async {
    final response = await Repository().reportProblem(
      title: title,
      description: description,
      appVersion: appVersion,
      contact: contact,
      image: image,
    );
    return response;
  }

  Future<bool> contactDeveloper({required String email}) async {
    final response = await Repository().contactDeveloper(
      email: email,
    );
    return response;
  }

  Future<List<DeveloperModel>> getDevelopers() async {
    final response = await Repository().getDevelopers();
    return response;
  }

  Future<List<AnnouncementModel>> getAnnoucement() async {
    final response = await Repository().getAnnoucement();
    return response;
  }

  Stream<List<AnnouncementModel>> getAnnoucements() async* {
    final response = Repository().getAnnoucements();
    yield* response;
  }

  Future<bool> openLink({required String link}) async {
    final response = await Repository().openLink(link: link);
    return response;
  }

  Future<bool> createResource({
    required String title,
    required String link,
    required String imageUrl,
    required String description,
    required String category,
  }) async {
    final response = Repository().createResource(
        title: title,
        link: link,
        imageUrl: imageUrl,
        description: description,
        category: category);
    return response;
  }

  Future<bool> createAdminResource({
    required String title,
    required String link,
    required String imageUrl,
    required String description,
    required String category,
  }) async {
    final response = Repository().createAdminResource(
        title: title,
        link: link,
        imageUrl: imageUrl,
        description: description,
        category: category);
    return response;
  }

  Future<bool> copyToClipboard({required String text}) async {
    final response = await Repository().copyToClipboard(text: text);
    return response;
  }

  Future<bool> downloadAndSaveImage(
      {required String url, required String fileName}) async {
    final response =
        await Repository().downloadAndSaveImage(url: url, fileName: fileName);
    return response;
  }

  Future share({required String message}) async {
    final response = await Repository().share(message: message);
    return response;
  }

  Future tweet({required String message}) async {
    final response = await Repository().tweet(message: message);
    return response;
  }

  Future sendMessage({
    required String message,
    required String image,
  }) async {
    final response = await Repository().sendMessage(
      message: message,
      image: image,
    );
    return response;
  }

  Future<bool> deleteMessage({required int time}) async {
    final response = await Repository().deleteMessage(time: time);
    return response;
  }

  Future<bool> isUserAdmin() async {
    final response = await Repository().isUserAdmin();
    return response;
  }

  Future<bool> createEvent({
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
    final response = await Repository().createEvent(
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
    return response;
  }

  Future<List<Event>> getPastEvent() async {
    final response = await Repository().getPastEvent();
    return response;
  }

  Future<List<Event>> searchPastEvent({required String query}) async {
    final response = await Repository().searchPastEvent(query: query);
    return response;
  }

  Future<Event> getParticularEvent({required String id}) async {
    final response = await Repository().getParticularEvent(id: id);
    return response;
  }

  Future<bool> completeEvent({required String id}) async {
    final response = await Repository().finishParticularEvent(id: id);
    return response;
  }

  Future<bool> updateEvent({
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
    final response = await Repository().updateEvent(
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
    return response;
  }

  Future<String> selectTime(BuildContext context) async {
    final response = await Repository().selectTime(context);
    return response;
  }

  Future<Timestamp> selectSpaceTime(BuildContext context) async {
    final response = await Repository().selectSpaceTime(context);
    return response;
  }

  Future<DateTime?> selectDate(BuildContext context) async {
    final response = await Repository().selectDate(context);
    return response;
  }

  Future<bool> startParticularEvent({required String id}) async {
    final response = await Repository().startParticularEvent(id: id);
    return response;
  }

  Future<List<Resource>> getAllResources() async {
    final response = await Repository().getAllResources();
    return response;
  }

  Future<List<Resource>> getUnApprovedResources() async {
    final response = await Repository().getUnApprovedResources();
    return response;
  }

  Future<List<Resource>> searchUnApprovedResources(
      {required String query}) async {
    final response = await Repository().searchUnApprovedResources(query: query);
    return response;
  }

  Future<bool> approveResource({required String id}) async {
    final response = await Repository().approveResource(id: id);
    return response;
  }

  Future<Resource> getParticularResource({required String id}) async {
    final response = await Repository().getParticularResource(id: id);
    return response;
  }

  Future<bool> updateResource({
    required String id,
    required String title,
    required String link,
    required String imageUrl,
    required String description,
    required String category,
  }) async {
    final response = await Repository().updateResource(
      id: id,
      title: title,
      link: link,
      imageUrl: imageUrl,
      description: description,
      category: category,
    );
    return response;
  }

  Future<bool> deleteEvent({required String id}) async {
    final response = await Repository().deleteEvent(id: id);
    return response;
  }

  Future<AnnouncementModel> getParticularAnnouncement(
      {required String id}) async {
    final response = await Repository().getParticularAnnouncement(id: id);
    return response;
  }

  Future<bool> deleteParticularAnnouncement({required String id}) async {
    final response = await Repository().deleteParticularAnnouncement(id: id);
    return response;
  }

  Future<bool> updateParticularAnnouncement(
      {required String id,
      required String name,
      required String position,
      required String title}) async {
    final response = await Repository().updateParticularAnnouncement(
        id: id, name: name, position: position, title: title);
    return response;
  }

  Future<bool> createAnnouncement(
      {required String name,
      required String position,
      required String title}) async {
    final response = await Repository()
        .createAnnouncement(name: name, position: position, title: title);
    return response;
  }

  Future<List<AnnouncementModel>> getAnnouncements() async {
    final response = await Repository().getAnnouncements();
    return response;
  }

  Future<List<AnnouncementModel>> searchAnnouncement(
      {required String query}) async {
    final response = await Repository().searchAnnouncement(query: query);
    return response;
  }

  Future<TwitterModel> getParticularSpaces({required String id}) async {
    final response = await Repository().getParticularSpaces(id: id);
    return response;
  }

  Future<bool> deleteParticularSpace({required String id}) async {
    final response = await Repository().deleteParticularSpace(id: id);
    return response;
  }

  Future<bool> createSpace({
    required String title,
    required String link,
    required Timestamp startTime,
    required Timestamp endTime,
    required String image,
    required Timestamp date,
  }) async {
    final response = await Repository().createSpace(
      title: title,
      link: link,
      startTime: startTime,
      endTime: endTime,
      image: image,
      date: date,
    );
    return response;
  }

  Future<bool> updateSpace({
    required String id,
    required String title,
    required String link,
    required Timestamp startTime,
    required Timestamp endTime,
    required String image,
    required Timestamp date,
  }) async {
    final response = await Repository().updateSpace(
      id: id,
      title: title,
      link: link,
      startTime: startTime,
      endTime: endTime,
      image: image,
      date: date,
    );
    return response;
  }

  Future<GroupsModel> getParticularGroup({required String id}) async {
    final response = await Repository().getParticularGroup(id: id);
    return response;
  }

  Future<bool> deleteParticularGroup({required String id}) async {
    final response = await Repository().deleteParticularGroup(id: id);
    return response;
  }

  Future<bool> createGroup({
    required String title,
    required String description,
    required String imageUrl,
    required String link,
  }) async {
    final response = await Repository().createGroup(
      title: title,
      description: description,
      imageUrl: imageUrl,
      link: link,
    );
    return response;
  }

  Future<bool> updateGroup({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required String link,
  }) async {
    final response = await Repository().updateGroup(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      link: link,
    );
    return response;
  }

  Future<bool> createLead({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String github,
    required String twitter,
    required String bio,
    required String image,
  }) async {
    final response = await Repository().createLead(
      name: name,
      email: email,
      phone: phone,
      role: role,
      github: github,
      twitter: twitter,
      bio: bio,
      image: image,
    );
    return response;
  }

  Future<bool> updateLead({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String github,
    required String twitter,
    required String bio,
    required String image,
  }) async {
    final response = await Repository().updateLead(
      name: name,
      email: email,
      phone: phone,
      role: role,
      github: github,
      twitter: twitter,
      bio: bio,
      image: image,
    );
    return response;
  }

  Future<bool> deleteLead({required String email}) async {
    final response = await Repository().deleteLead(email: email);
    return response;
  }

  Future<LeadsModel> getLead({required String email}) async {
    final response = await Repository().getLead(email: email);
    return response;
  }

  Future<List<FeedbackModel>> getFeedback() async {
    final response = await Repository().getFeedback();
    return response;
  }


  Future<List<ReportModel>> getReports() async {
    final response = await Repository().getReports();
    return response;
  }
}
