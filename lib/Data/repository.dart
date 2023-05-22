// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_bloc/Data/Models/event_model.dart';
import 'package:gdsc_bloc/Data/Models/groups_model.dart';
import 'package:gdsc_bloc/Data/Models/message_model.dart';
import 'package:gdsc_bloc/Data/Models/resource_model.dart';
import 'package:gdsc_bloc/Data/Models/twitter_model.dart';
import 'package:gdsc_bloc/Util/shared_preference_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Repository {
  Future<bool> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    final auth = FirebaseAuth.instance;
    try {
      User user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        await SharedPreferencesManager().setLoggedIn(value: true);
        await SharedPreferencesManager().setId(value: user.uid);
        await SharedPreferencesManager().setName(value: name);
        debugPrint("Account created Succesfull");
        return true;
      } else {
        debugPrint("Account creation failed");
        return false;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    final auth = FirebaseAuth.instance;
    try {
      User user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        await SharedPreferencesManager().setLoggedIn(value: true);
        await SharedPreferencesManager().setId(value: user.uid);
        await SharedPreferencesManager().setName(value: user.displayName!);
        debugPrint("Login Succesfull");
        return true;
      } else {
        debugPrint("Login failed");
        return false;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> logoutUser() async {
    final auth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();
    try {
      await auth.signOut();
      await googleSignIn.signOut();
      await SharedPreferencesManager().setLoggedIn(value: false);
      debugPrint("Logout Succesfull");
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: email);
      debugPrint("Reset Password email sent Succesfullly");
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> changePassword(
      {required String email,
      required String oldPassword,
      required String newPassword}) async {
    final auth = FirebaseAuth.instance;
    try {
      User user = auth.currentUser!;
      final credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      debugPrint("Change Password Succesfull");
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
// ! NOT IMPORTANT FOR NOW
  // Future<bool> changeEmail(
  //     {required String email,
  //     required String password,
  //     required String newEmail}) async {
  //   final auth = FirebaseAuth.instance;
  //   try {
  //     User user = auth.currentUser!;
  //     final credential =
  //         EmailAuthProvider.credential(email: email, password: password);
  //     await user.reauthenticateWithCredential(credential);
  //     await user.updateEmail(newEmail);
  //     debugPrint("Change Email Succesfull");
  //     return true;
  //   } on FirebaseException catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  Future<bool> deleteUser(
      {required String email, required String password}) async {
    final auth = FirebaseAuth.instance;
    try {
      User user = auth.currentUser!;
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(credential);
      await user.delete();
      debugPrint("Delete User Succesfull");
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // 'https://www.googleapis.com/auth/calendar',
      ],
    );
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        print("The accessTOken is ${googleSignInAuthentication.accessToken}");
        print("The refreshToken is ${googleSignInAuthentication.idToken}");

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          await SharedPreferencesManager().setAuthAccessToken(
              value: googleSignInAuthentication.accessToken!);
          await SharedPreferencesManager()
              .setAuthRefreshToken(value: googleSignInAuthentication.idToken!);
          await SharedPreferencesManager().setLoggedIn(value: true);
          await SharedPreferencesManager()
              .setName(value: userCredential.user!.displayName!);
          await SharedPreferencesManager()
              .setId(value: userCredential.user!.uid);
          debugPrint("Login Succesfull");
          return true;
        } else {
          debugPrint("Login failed");
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<List<Event>> getEvents() async* {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final events = firebaseFirestore.collection("event").snapshots().map(
          (event) => event.docs.map((e) => Event.fromJson(e.data())).toList());

      yield* events;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future sendMessage({
    required String message,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection("messages").add({
        "message": message,
        "name": await SharedPreferencesManager().getName(),
        "id": await SharedPreferencesManager().getId(),
        "time": DateTime.now().millisecondsSinceEpoch,
        "timestamp": DateTime.now().toString(),
      });
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Stream<List<Message>> getMessages() async* {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final messages = firebaseFirestore
          .collection("messages")
          .orderBy("time", descending: false)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Message.fromJson(e.data())).toList());

      yield* messages;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> getResources() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resources")
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());
      return resources;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Event>> getEvent() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final event = await firebaseFirestore.collection("event").get().then(
          (value) => value.docs.map((e) => Event.fromJson(e.data())).toList());
      return event;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> searchResources({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resources")
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());

      return resources
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  
  Future<List<Event>> searchEvent({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final events = await firebaseFirestore.collection("event").get().then(
          (value) => value.docs.map((e) => Event.fromJson(e.data())).toList());

      return events
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> addEventToCalendar(
      {required String summary,
      required Timestamp start,
      required Timestamp end}) async {
    try {
      print("Calendar called");
      const String url =
          'https://www.googleapis.com/calendar/v3/calendars/emilio/events';

      final String accessToken =
          await SharedPreferencesManager().getAuthAccessToken();

      final Map<String, dynamic> event = {
        "summary": summary,
        "start": {
          "dateTime": start.toDate().toIso8601String(),
          "timeZone": "Nairobi"
        },
        "end": {
          "dateTime": end.toDate().toIso8601String(),
          "timeZone": "Nairobi"
        }
      };

      final String body = json.encode(event);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print(response.body);

      if (response.statusCode == 200) {
        debugPrint("event added to calendar");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());

      return false;
    }
  }

  Future<List<TwitterModel>> getSpaces() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final spaces = await firebaseFirestore.collection("twitter").get().then(
          (value) =>
              value.docs.map((e) => TwitterModel.fromJson(e.data())).toList());
              print(spaces);
      return spaces;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<TwitterModel>> searchSpace({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final spaces = await firebaseFirestore.collection("twitter").get().then(
          (value) =>
              value.docs.map((e) => TwitterModel.fromJson(e.data())).toList());

      return spaces
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }


  Future<List<GroupsModel>> getGroups() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final groups = await firebaseFirestore.collection("announcements").get().then(
          (value) =>
              value.docs.map((e) => GroupsModel.fromJson(e.data())).toList());
      return groups;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<GroupsModel>> searchGroup({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final group = await firebaseFirestore.collection("announcements").get().then(
          (value) =>
              value.docs.map((e) => GroupsModel.fromJson(e.data())).toList());

      return group
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }
}
