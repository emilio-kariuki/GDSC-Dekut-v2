import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gdsc_bloc/Blocs/Network/network_bloc.dart';
import 'package:gdsc_bloc/Data/Models/event_model.dart';
import 'package:gdsc_bloc/Data/Models/groups_model.dart';
import 'package:gdsc_bloc/Data/Models/resource_model.dart';
import 'package:gdsc_bloc/Data/Models/twitter_model.dart';
import 'package:gdsc_bloc/Data/repository.dart';

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

  Future<List<Resource>> getResources() {
    return Repository().getResources();
  }

  Future<List<Resource>> searchResources({required String query}) async {
    return Repository().searchResources(query: query);
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
}
